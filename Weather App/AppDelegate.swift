//
//  AppDelegate.swift
//  Weather App
//
//  Created by Peter Alanoca on 31/12/22.
//

import UIKit
import GooglePlaces
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        DatabaseManager.setup(application)
        
        if let googleAPIKey = Configuration.string.value(for: "GOOGLE_API_KEY") {
            GMSPlacesClient.provideAPIKey(googleAPIKey)
            GMSServices.provideAPIKey(googleAPIKey)
        }
        
        setupNavigationBarStyle()
        setupTabBarStyle()
 
        return true
    }
    
    func setupNavigationBarStyle() {
        let navigationBarAppearance = UINavigationBar.appearance()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black
            ]
            let backButtonAppearance = UIBarButtonItemAppearance()
              backButtonAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.black
            ]
            appearance.backButtonAppearance = backButtonAppearance
            appearance.backgroundColor = .white
            navigationBarAppearance.standardAppearance = appearance
            navigationBarAppearance.scrollEdgeAppearance = appearance
        }
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
        ]
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.isTranslucent = true
    }
    
    func setupTabBarStyle() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().isTranslucent = true
    }

}

