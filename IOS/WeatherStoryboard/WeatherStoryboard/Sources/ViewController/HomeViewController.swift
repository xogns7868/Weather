//
//  ViewController.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2021/12/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UITextFieldDelegate {
    var viewModel: WeatherSummaryViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var num: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.$weatherSummary.sink { result in
            print(String(result?.latitude ?? 0))
        }.store(in: &cancellables)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        print("textEditing = \((self.textField.text) ?? "Empty")")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textBegin: \((textField.text) ?? "Empty")")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textEnd: \((textField.text) ?? "Empty")")
        numLabel.text = textField.text
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
