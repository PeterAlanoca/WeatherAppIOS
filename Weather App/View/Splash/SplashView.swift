//
//  SplashView.swift
//  Weather App
//
//  Created by Peter Alanoca on 30/12/22.
//

import SwiftUI

struct SplashView: View {

    @State private var isActive = false
    
    var body: some View {
       VStack {
           if self.isActive {
               MainTabView()
           } else {
               LottieView(lottieFile: "logo")
                   .frame(width: 260, height: 260)
                   .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
               Text("Weather App")
                   .font(.largeTitle.weight(.bold))
                   .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
           }
       }
       .onAppear {
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               withAnimation {
                   self.isActive = true
               }
           }
       }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .previewDevice("iPhone 11")
    }
}
