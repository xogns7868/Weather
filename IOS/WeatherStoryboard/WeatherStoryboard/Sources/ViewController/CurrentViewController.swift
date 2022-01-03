//
//  CurrentViewController.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2021/12/25.
//

import UIKit

class CurrentViewController: UIViewController {
    @IBOutlet weak var numLabel: UILabel!
    var num: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func numUp(_ sender: UIButton) {
        num += 1
        numLabel.text = String(num)
    }
}
