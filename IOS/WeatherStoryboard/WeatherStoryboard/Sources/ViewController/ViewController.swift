//
//  ViewController.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2021/12/25.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var num: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textBegin: \((textField.text) ?? "Empty")")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textEnd: \((textField.text) ?? "Empty")")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textShouldReturn: \((textField.text) ?? "Empty")")
        textField.resignFirstResponder()
        return true
    }

    @IBAction func numUp(_ sender: UIButton) {
        num += 1
        numLabel.text = String(num)
    }
}

