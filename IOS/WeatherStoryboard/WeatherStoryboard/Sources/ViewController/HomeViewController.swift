//
//  ViewController.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2021/12/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UITextFieldDelegate {
    var weatherSummaryViewModel: WeatherSummaryViewModel!
//    var currentSummaryViewModel: CurrentSummaryViewModel!
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var currentTempDescription: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    var num: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherSummaryViewModel.$weatherSummary.sink { result in
            self.currentTempDescription.text = result?.current.weatherDetails.first?.weatherDescription
            if let icon = result?.current.weatherDetails.first?.weatherIcon {
                self.currentWeatherIcon.image = UIImage(named: icon)
                self.currentWeatherIcon.isHidden = false
            } else {
                self.currentWeatherIcon.isHidden = true
            }
        }.store(in: &cancellables)
        
        currentTempDescription.textAlignment = .center
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        weatherSummaryViewModel.searchText = self.textField.text ?? "Seoul"
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
