//
//  Weather_AppApp.swift
//  Weather App
//
//  Created by Peter Alanoca on 30/12/22.
//

import SwiftUI

@main
struct Weather_AppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
