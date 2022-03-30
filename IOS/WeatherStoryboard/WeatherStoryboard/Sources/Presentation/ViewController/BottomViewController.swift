//
//  BottomViewController.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/18.
//

import UIKit

class BottomViewController: UIViewController {

    init() {
        super.init(
            nibName: String(describing: BottomViewController.self),
            bundle: Bundle(for: BottomViewController.self)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
