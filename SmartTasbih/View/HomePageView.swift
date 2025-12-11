//
//  HomePageView.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//

import SwiftUI

struct HomePageView: View {
    @State private var selectedTab = 0
    let tabs = ["Tesbihler", "Yeni Ekle"]
    
    
    var body: some View {
        
        VStack {
            // Üstte segment kontrol
            Picker("", selection: $selectedTab) {
                ForEach(0..<tabs.count) { index in
                    Text(tabs[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(16)
            
            // Seçilen tab’e göre içerik
            if selectedTab == 0 {
                TasbihListView()
            } else {
                AddTasbihView()
            }
            
        }
    }
}

#Preview {
    HomePageView()
}
