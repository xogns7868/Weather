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
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    // IBOutlet here ...
    
    enum CardViewState {
        case fullExpanded
        case halfExpanded
        case collapsed
    }
    
    var cardViewState : CardViewState = .collapsed
    
    // to store the card view top constraint value before the dragging start
    // default is 30 pt from safe area top
    var cardPanStartingTopConstant : CGFloat = 30.0
    
    var timer: Timer? = nil
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm ss EEE"
        datePicker(datePicker)
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(viewPan)
        
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
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        // how much distance has user dragged the card view
        // positive number means user dragged downward
        // negative number means user dragged upward
        let translation = panRecognizer.translation(in: self.view)
        let velocity = panRecognizer.velocity(in: self.view)
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstant = cardViewTopConstraint.constant
        case .changed :
            if self.cardPanStartingTopConstant + translation.y > 30.0 {
                self.cardViewTopConstraint.constant = self.cardPanStartingTopConstant + translation.y
            }
        case .ended :
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
               let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                
                if self.cardViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
                    showCard(atState: .fullExpanded)
                } else if self.cardViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.5 {
                    showCard(atState: .halfExpanded)
                } else {
                    showCard(atState: .collapsed)
                }
            }
        default:
            break
        }
        print("user has dragged \(translation.y) point vertically")
    }
    
    private func showCard(atState: CardViewState = .collapsed) {
        
        // ensure there's no pending layout changes before animation runs
        self.view.layoutIfNeeded()
        
        // set the new top constraint value for card view
        // card view won't move up just yet, we need to call layoutIfNeeded()
        // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            
            if atState == .fullExpanded {
                cardViewTopConstraint.constant = 30.0
            } else if atState == .halfExpanded {
                cardViewTopConstraint.constant = (safeAreaHeight + bottomPadding) / 2.0
            } else {
                cardViewTopConstraint.constant = safeAreaHeight - 200
            }
            cardPanStartingTopConstant = cardViewTopConstraint.constant
        }
        
        // move card up from bottom
        // create a new property animator
        let showCard = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        // run the animation
        showCard.startAnimation()
    }
    
    @IBAction func onClick(_ sender: Any) {
        // Custom BottomSheet Open
        // openCustomBottomSheet()
        // MDC BottomSheet Open
        // MDCBottomSheetOpen()
        showCard()
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
