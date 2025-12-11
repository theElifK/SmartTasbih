//
//  AddTasbihViewModel.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//

import Foundation
import Combine
import SwiftUI
import CoreData

final class AddTasbihViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var target: String = ""
    @Published var isSaving: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    func validate() -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            alertMessage = "Lütfen bir isim girin."
            showAlert = true
            return false
        }
        guard trimmed.count <= 100 else {
            alertMessage = "İsim 100 karakterden kısa olmalı."
            showAlert = true
            return false
        }
        return true
    }

    func save(completion: @escaping (Bool) -> Void) {
        guard validate() else { completion(false); return }
        // target String → Int dönüşümü
           let targetInt = Int64(target) ?? 0
        isSaving = true
        // DispatchQueue ile kısa bir gecikme UX için (isteğe bağlı)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let new = TasbihDataModel(context: self.context) // Core Data entity
            new.id = UUID()
            new.name = self.name.trimmingCharacters(in: .whitespacesAndNewlines)
            new.target = targetInt
            new.createdAt = Date()

            do {
                try self.context.save()
                DispatchQueue.main.async {
                    self.isSaving = false
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isSaving = false
                    self.alertMessage = "Kaydetme sırasında hata: \(error.localizedDescription)"
                    self.showAlert = true
                    completion(false)
                }
            }
        }
    }
}
