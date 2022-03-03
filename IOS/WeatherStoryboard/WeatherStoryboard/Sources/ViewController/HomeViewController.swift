//
//  ViewController.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2021/12/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController,
                          UITextFieldDelegate {
    
    var weatherSummaryViewModel: WeatherSummaryViewModel!
//    var currentSummaryViewModel: CurrentSummaryViewModel!
    
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var currentTempDescription: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet var tableView: UITableView!
    var num: Int = 3
    
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
            self.num = self.weatherSummaryViewModel.hourSummaries.count
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        currentTempDescription.textAlignment = .center
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        weatherSummaryViewModel.searchText = self.textField.text ?? "Seoul"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textBegin: \((textField.text) ?? "Empty")")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textShouldReturn: \((textField.text) ?? "Empty")")
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.num)
        return self.num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }

        return cell
    }
}
