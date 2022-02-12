//
//  AppDelegate.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2021/12/25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dataManager = DataManager()
        let viewModel = WeatherSummaryViewModel(weatherFetcher: dataManager)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as? HomeViewController
        viewController?.weatherSummaryViewModel = viewModel
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
