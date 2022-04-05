//
//  CurrentViewController.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2021/12/25.
//

import UIKit
import Combine
import MaterialComponents.MaterialBottomSheet

class CurrentViewController: UIViewController {
    
    var fiveDayWeatherViewModel: FiveDayWeatherViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var bottomSheetOpenButton: UIButton!
    
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
            guard let selectedResult = result?.threeHourly.filter({ item in
                item.dtTxt == selectedDateFormat.string(from: date)
            }).first else {
                return
            }
            print("\(selectedResult.dtTxt) \(selectedResult.temp.celsius)")
        }.store(in: &cancellables)
    }
    
    @IBAction func onClick(_ sender: Any) {
        // Custom BottomSheet Open
        // openCustomBottomSheet()
        // MDC BottomSheet Open
        // MDCBottomSheetOpen()
        openDashboard()
    }
    
    private func openDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let reactionViewController = storyboard.instantiateViewController(identifier: "ReactionViewController")

        reactionViewController.modalPresentationStyle = .overCurrentContext
        present(reactionViewController, animated: true, completion: nil)
    }
    
    private func openCustomBottomSheet() {
        let myViewController = BottomViewController()
        
        let bottomSheetViewModel = BRQBottomSheetViewModel(
            cornerRadius: 20,
            animationTransitionDuration: 0.3,
            backgroundColor: UIColor.red.withAlphaComponent(0.5)
        )
        
        let bottomSheetVC = BottomSheetViewController(
            viewModel: bottomSheetViewModel,
            childViewController: myViewController
        )
        
        presentBottomSheet(bottomSheetVC, completion: nil)
    }
    
    private func MDCBottomSheetOpen() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BottomViewController")
        let shapeGenerator = MDCRectangleShapeGenerator()
        let cornerTreatment = MDCRoundedCornerTreatment(radius: 8)
        shapeGenerator.topLeftCorner = cornerTreatment
        shapeGenerator.topRightCorner = cornerTreatment
        
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc!)
        bottomSheet.setShapeGenerator(shapeGenerator, for: .closed)
        bottomSheet.setShapeGenerator(shapeGenerator, for: .extended)
        bottomSheet.setShapeGenerator(shapeGenerator, for: .preferred)
        
        present(bottomSheet, animated: true, completion: nil)
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
