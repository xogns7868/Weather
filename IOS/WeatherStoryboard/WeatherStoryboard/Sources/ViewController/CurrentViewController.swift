//
//  CurrentViewController.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2021/12/25.
//

import UIKit

class CurrentViewController: UIViewController {
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
        
        selectedDateLabel.text = "선택된 날짜: \(dateFormat.string(from: datePicker.date))"
    }
    
    func timeUpdate() {
        let date = NSDate()
        currentDateLabel.text = "현재 날짜: \(dateFormat.string(from: date as Date))"
        datePicker.setDate(date as Date, animated: true)
    }
}
