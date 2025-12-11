//
//  TasbihListViewModel.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//

import SwiftUI
import CoreData
import Combine

class TasbihListViewModel: ObservableObject {

    @Published var items: [TasbihDataModel] = []

    private let context = CoreDataManager.shared.context

    init() {
        fetchItems()
    }

    func fetchItems() {
        let request = TasbihDataModel.fetchRequest()
        //Veriler oluşturma tarihine göre, yeniden eskiye sıralanır.
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        do {
            items = try context.fetch(request)
        } catch {
            print("Fetch hatası: \(error.localizedDescription)")
        }
    }

    func deleteItem(_ item: TasbihDataModel) {
        context.delete(item)
        CoreDataManager.shared.saveContext()
        fetchItems() // liste yenilensin
    }

    func addItem(title: String) {
        let newItem = TasbihDataModel(context: context)
        newItem.name = title
        CoreDataManager.shared.saveContext()
        fetchItems() // liste yenilensin
    }
    
}

