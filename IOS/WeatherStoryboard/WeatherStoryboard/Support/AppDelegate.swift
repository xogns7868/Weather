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

        let viewModel = DIFramework.shared.getWeatherSummaryViewModel()
        let fiveDayWeatherViewModel = DIFramework.shared.getFiveDayWeatherSummaryViewModel()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController
        (tabBarController?.viewControllers?[0] as? HomeViewController)?.weatherSummaryViewModel = viewModel
        (tabBarController?.viewControllers?[1] as? CurrentViewController)?.fiveDayWeatherViewModel = fiveDayWeatherViewModel


        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
     
        return true
    }
}
