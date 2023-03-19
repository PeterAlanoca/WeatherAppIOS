//
//  MainTabView.swift
//  Weather App
//
//  Created by Peter Alanoca on 30/12/22.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var index = 0

    var body: some View {
        TabView(selection: $index) {
            WeatherView(viewModel: .init())
                .tabItem {
                    Text("Clima")
                    Image(systemName: "cloud.sun")
                }.tag(0)
            HistoryView(viewModel: .init())
                .tabItem {
                    Text("Historial")
                    Image(systemName: "clock")
                }.tag(1)
        }
        .accentColor(Color.red)
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .previewDevice("iPhone 11")
    }
}
