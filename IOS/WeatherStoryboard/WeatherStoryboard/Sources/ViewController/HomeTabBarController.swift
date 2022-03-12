//
//  HomeTabBarController.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/11.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers?[0].tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        self.viewControllers?[1].tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
