//
//  TasbihDetailView.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//

import SwiftUI
import Combine

struct TasbihDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var vm: TasbihDetailViewModel
    
    @State private var count = 0
    
    init(tasbih: TasbihDataModel) {
        _vm = StateObject(
            wrappedValue: TasbihDetailViewModel(
                tasbih: tasbih,
                context: CoreDataManager.shared.context
            )
        )
    }
    var body: some View {
        
        VStack {
            VStack{
                Text(vm.tasbih?.name ?? "Tasbih")
                    .font(.largeTitle)
                Text("Hedef: \(vm.tasbih?.target ?? 0)")
                    .font(.headline)
                
            }  .padding()
            
            Spacer()
            
            ZStack {
                // Gri arka plan çemberi
                Circle()
                    .stroke(lineWidth: 20)
                    .foregroundColor(Color.gray.opacity(0.2))
                
                // Dolan progress çemberi
                Circle()
                    .trim(from: 0, to: vm.progress)  // ← en önemli kısım
                    .stroke(
                        Color.green,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))  // 12’den başlasın
                    .animation(.easeInOut(duration: 0.3), value: vm.progress)
                
                // Ortadaki sayaç sayısı
                Text("\(vm.tasbih?.count ?? 0)")
                    .font(.largeTitle)
                    .bold()
            }
            .frame(width: 200, height: 200)
            .padding()
            
            
            
            Button(action: {
                
                vm.increaseCount()  
                
            }) {
                Text("Çek")
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                //Hedef sayıya ulaşıldığında butonu rengini değiştir.
                    .background(vm.buttonDisabled() == false ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            //Hedef sayıya ulaşıldığında butonu disable et.
            .disabled(vm.buttonDisabled() == true ? true : false)
            .padding()
            .alert("Tebrikler!", isPresented: $vm.showAlert) {
                Button("Tamam", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Hedefe ulaştın!")
            }
            Spacer()
        }
    }
}
#Preview {
    
}
