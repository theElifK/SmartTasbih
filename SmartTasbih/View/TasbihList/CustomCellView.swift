//
//  CustomCellView.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//

import SwiftUI

struct CustomCellView: View {
    let tasbih: TasbihDataModel
    let onDelete: () -> Void
    let onSelect: () -> Void
    
    var progress: Double {
        let count = Double(tasbih.count)
        let target = Double(tasbih.target) // Core Data’da “target” varsa
        if target == 0 { return 0 }
        return min(count / target, 1.0) // %100’ü geçmesin
    }
    private var percentageText: String {
        tasbih.target == 0 ? "100%" : "\(Int(progress * 100))%"
    }
    var body: some View {
        VStack{
                // Satıra tıklayınca detay açılır
                Button(action: onSelect) {
                    VStack(alignment: .leading) {
                        Text(tasbih.name ?? "-")
                            .font(.system(size: 24,weight: .semibold))
                            .foregroundColor(.black)
                        HStack{
                            
                            Text("\(tasbih.count)")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                            Text("/")
                                .font(.system(size:18))
                                .foregroundColor(.gray)
                            Text("\(tasbih.target)")
                                .font(.system(size:18))
                                .foregroundColor(.gray)
                            
                        }
                        
                        //Hedef belirlenmişse progres bar göster
                        if tasbih.target > 0 {
                            // Progress Bar
                            let p = progress * 100
                            
                            HStack{
                                ProgressView(value: progress)
                                    .tint(.green)
                                    .frame(height: 6)
                                    .clipShape(Capsule())
                                
                                if percentageText == "100%"{
                                    Image(systemName: "checkmark.square")
                                        .foregroundColor(.green)
                                }else{
                                    Text(percentageText)
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        HStack{
                            if let date = tasbih.createdAt {
                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            // Sadece ikon tıklanınca siler
                            Button(action: onDelete) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            .buttonStyle(.borderless) // HStack’e etki etmesin
                        }
                    }
                }
                .buttonStyle(.plain)
          
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 2)
        
      
    }
      
}
