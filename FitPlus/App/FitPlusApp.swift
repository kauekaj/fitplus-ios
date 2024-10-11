//
//  FitPlusApp.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 22/02/24.
//

import Firebase 
import SwiftUI


@main
struct FitPlusApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DependencyAssembly.shared.resolveUserRepository() as! UserRepository)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        setupNavBarAppearance()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    private func setupNavigation() {
        let backIndicatorImage = UIImage(named: "appleIcon")
        let barAppearance = UINavigationBar.appearance()
        barAppearance.backIndicatorImage = backIndicatorImage
        barAppearance.backIndicatorImage?.withTintColor(.black)
        barAppearance.backIndicatorTransitionMaskImage = backIndicatorImage
        barAppearance.backItem?.backBarButtonItem?.isHidden = true
    }
    
    func setupNavBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.white
        
        let backIndicatorImage = UIImage(systemName: "chevron.left")
        navigationBarAppearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    }

}
