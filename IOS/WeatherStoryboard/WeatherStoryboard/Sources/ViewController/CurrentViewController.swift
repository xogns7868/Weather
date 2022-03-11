//
//  CurrentViewController.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2021/12/25.
//

import UIKit

class CurrentViewController: UIViewController {
    @IBOutlet weak var numLabel: UILabel!
    var num: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
    }
    @IBAction func numUp(_ sender: UIButton) {
        num += 1
        numLabel.text = String(num)
    }
}
