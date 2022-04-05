//
//  ReactionViewController.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/22.
//

import Foundation
import UIKit

class ReactionViewController: UIViewController {
    
    @IBOutlet weak var dim: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentBottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewHeightConstraint: NSLayoutConstraint!
    // IBOutlet here ...
    
    enum CardViewState {
        case fullExpanded
        case halfExpanded
        case collapsed
    }

    
    var cardViewState : CardViewState = .collapsed
    
    // to store the card view top constraint value before the dragging start
    // default is 30 pt from safe area top
    var cardPanStartingConstant : CGFloat = 30.0
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(viewPan)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCard()
    }
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        // how much distance has user dragged the card view
        // positive number means user dragged downward
        // negative number means user dragged upward
        let translation = panRecognizer.translation(in: self.view)
        let velocity = panRecognizer.velocity(in: self.view)
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingConstant = cardViewHeightConstraint.constant
        case .changed :
            if self.cardPanStartingConstant - translation.y < self.view.frame.height - 30 {
                self.cardViewHeightConstraint.constant = self.cardPanStartingConstant - translation.y
            }
            self.dim.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewHeightConstraint.constant)
        case .ended :
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
               let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                
                if self.cardViewHeightConstraint.constant > (safeAreaHeight + bottomPadding) * 0.75 {
                    showCard(atState: .fullExpanded)
                } else if self.cardViewHeightConstraint.constant > (safeAreaHeight + bottomPadding) * 0.5 {
                    showCard(atState: .halfExpanded)
                } else {
                    showCard(atState: .collapsed)
                }
            }

        default:
            break
        }
    }
    
    private func showCard(atState: CardViewState = .collapsed) {
        
        // ensure there's no pending layout changes before animation runs
        self.view.layoutIfNeeded()
        
        // set the new top constraint value for card view
        // card view won't move up just yet, we need to call layoutIfNeeded()
        // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height {
            
            if atState == .fullExpanded {
                cardViewHeightConstraint.constant = safeAreaHeight - 30
            } else if atState == .halfExpanded {
                cardViewHeightConstraint.constant = safeAreaHeight / 2.0
            } else {
                cardViewHeightConstraint.constant = contentView.frame.height
            }
            cardPanStartingConstant = cardViewHeightConstraint.constant
        }
        // move card up from bottom
        // create a new property animator
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        // run the animation
        showCard.startAnimation()
    }
    
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
        print(value)
        let fullDimAlpha : CGFloat = 0.7
        
        // ensure safe area height and safe area bottom padding is not nil
        guard let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
              let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
            return fullDimAlpha
        }
        
        // when card view top constraint value is equal to this,
        // the dimmer view alpha is dimmest (0.7)
        let fullDimPosition = safeAreaHeight
        
        // when card view top constraint value is equal to this,
        // the dimmer view alpha is lightest (0.0)
        let noDimPosition = CGFloat(0)
        
        // if card view top constraint is lesser than fullDimPosition
        // it is dimmest
        if value > fullDimPosition {
            return fullDimAlpha
        }
        
        // if card view top constraint is more than noDimPosition
        // it is dimmest
        if value < noDimPosition {
            return 0.0
        }
        
        // else return an alpha value in between 0.0 and 0.7 based on the top constraint value
        return value / fullDimPosition
    }
}
