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
    var hourSummaries: [HourSummaryViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherSummaryViewModel.$weatherSummary.sink { result in
            self.currentTempDescription.text = result?.current.weatherDetails.first?.weatherDescription
            if let icon = result?.current.weatherDetails.first?.weatherIcon {
                self.currentWeatherIcon.image = UIImage(systemName: icon)
                self.currentWeatherIcon.tintColor = .systemGray
                self.currentWeatherIcon.isHidden = false
            } else {
                self.currentWeatherIcon.isHidden = true
            }
        }.store(in: &cancellables)
        
        weatherSummaryViewModel.$hourSummaries.sink { result in
            self.hourSummaries = result
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        currentTempDescription.textAlignment = .center
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        weatherSummaryViewModel.searchText = self.textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        return self.hourSummaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.customLabel?.text = "\(self.hourSummaries[indexPath.row].timeFmt) = \(self.hourSummaries[indexPath.row].tempFmt)"
        cell.customLabel?.highlightedTextColor = .brown
        return cell
    }
}
