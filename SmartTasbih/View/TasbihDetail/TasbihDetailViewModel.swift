//
//  TasbihDetailViewModel.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//


import Foundation
import Combine
import CoreData
import UIKit

class TasbihDetailViewModel: ObservableObject {
    
    @Published var tasbih: TasbihDataModel?
    @Published var showAlert = false

    private let context: NSManagedObjectContext?

    init(tasbih: TasbihDataModel, context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.tasbih = tasbih
        self.context = context
    }
  
        
    func save() {
          do {
              try context?.save()
              objectWillChange.send() 
          } catch {
              print("Hata: Tasbih güncellenemedi -> \(error.localizedDescription)")
          }
      }

    var progress: Double {
      
        if tasbih?.target  == 0 { return 0.0 }
       
        return min(Double(tasbih?.count ?? 0) / Double(tasbih?.target ?? 0), 1.0)
    }
    
    func increaseCount() {
          tasbih?.count += 1

          save()

          checkTarget()
      }
  func checkTarget() {
         guard let target = tasbih?.target , target > 0 else { return }

        if tasbih?.count ?? 0 >= target {
             // Titreşim
             let generator = UINotificationFeedbackGenerator()
             generator.notificationOccurred(.success)
             
             // Alert göster
             showAlert = true
         }
     }
    func buttonDisabled() -> Bool {
        var result: Bool = false
        if tasbih?.target != 0 {
            result = tasbih?.count == tasbih?.target
        }else {
            result = false
        }
        return result
    }
}
