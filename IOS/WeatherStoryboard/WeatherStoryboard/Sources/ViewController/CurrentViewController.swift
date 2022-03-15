//
//  CurrentViewController.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2021/12/25.
//

import UIKit
import Combine

class CurrentViewController: UIViewController {
    
    var fiveDayWeatherViewModel: FiveDayWeatherViewModel!
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!
    var timer: Timer? = nil
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm ss EEE"
        datePicker(datePicker)
        
        fiveDayWeatherViewModel.$fiveDayWeatherSummary.sink { result in
            let selectedDateFormat = DateFormatter()
            selectedDateFormat.locale = Locale(identifier: "ko_KR")
            selectedDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let selectedDate = self.datePicker.date.zeroSeconds
            guard let date = selectedDate else {
                return
            }
            
            result?.threeHourly.forEach { item in
                print("\(selectedDateFormat.string(from: date)) \(item.dtTxt), \(item.temp)")
                print("\(selectedDateFormat.string(from: date) == item.dtTxt)")
            }
        }.store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidApper")
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeUpdate()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisapper")
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        let datePicker = sender
        fiveDayWeatherViewModel.searchText = "Seoul"
        selectedDateLabel.text = "선택된 날짜: \(dateFormat.string(from: datePicker.date))"
    }
    
    func timeUpdate() {
        let date = NSDate()
        currentDateLabel.text = "현재 날짜: \(dateFormat.string(from: date as Date))"
//        datePicker.setDate(date as Date, animated: true)
    }
}

extension Date {
    var zeroSeconds: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        return calendar.date(from: dateComponents)
    }
}
