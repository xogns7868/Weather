//
//  BottomSheetViewController.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/18.
//

import Foundation
import UIKit

public protocol BRQBottomSheetPresentable {
    var cornerRadius: CGFloat { get set }
    var animationTransitionDuration: TimeInterval { get set }
    var backgroundColor: UIColor { get set }
}


public class BottomSheetViewController: UIViewController {
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var contentViewHeight: NSLayoutConstraint!
    
    private let viewModel: BRQBottomSheetPresentable
    private let childViewController: UIViewController
    private var originBeforeAnimation: CGRect = .zero
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization
    //-----------------------------------------------------------------------------
    
    public init(viewModel: BRQBottomSheetPresentable, childViewController: UIViewController) {
        self.viewModel = viewModel
        self.childViewController = childViewController
        super.init(
            nibName: String(describing: BottomSheetViewController.self),
            bundle: Bundle(for: BottomSheetViewController.self)
        )
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomSheetViewController {
   
   override public func viewDidLoad() {
       super.viewDidLoad()
       contentView.alpha = 1
       configureChild()
       
       let gesture = UIPanGestureRecognizer(target: self, action: #selector(BottomSheetViewController.panGesture))
       contentView.addGestureRecognizer(gesture)
       gesture.delegate = self
       
       contentViewBottomConstraint.constant = -childViewController.view.frame.height
       view.layoutIfNeeded()
   }
   
   override public func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    
       contentViewBottomConstraint.constant = 0
       UIView.animate(withDuration: viewModel.animationTransitionDuration) {
           self.view.backgroundColor = self.viewModel.backgroundColor
           self.view.layoutIfNeeded()
       }
   }
   
   override public func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       contentView.roundCorners([.topLeft, .topRight], radius: viewModel.cornerRadius)
       originBeforeAnimation = contentView.frame
   }
    
    
}

//-----------------------------------------------------------------------------
// MARK: - Public Methods
//-----------------------------------------------------------------------------

extension BottomSheetViewController {
   public func dismissViewController() {
       contentViewBottomConstraint.constant = -childViewController.view.frame.height
       UIView.animate(withDuration: viewModel.animationTransitionDuration, animations: {
           self.view.layoutIfNeeded()
           self.view.backgroundColor = .clear
       }, completion: { _ in
           self.dismiss(animated: false, completion: nil)
       })
   }
}

//-----------------------------------------------------------------------------
// MARK: - Private Methods
//-----------------------------------------------------------------------------

private extension BottomSheetViewController {
   
   private func configureChild() {
       addChild(childViewController)
       contentView.addSubview(childViewController.view)
       childViewController.didMove(toParent: self)
       
       guard let childSuperView = childViewController.view.superview else { return }

        // 현재 Child View를 앱 전체 크기로 맞춰주는 작업
       NSLayoutConstraint.activate([
           childViewController.view.bottomAnchor.constraint(equalTo: childSuperView.bottomAnchor),
           childViewController.view.topAnchor.constraint(equalTo: childSuperView.topAnchor),
           childViewController.view.leftAnchor.constraint(equalTo: childSuperView.leftAnchor),
           childViewController.view.rightAnchor.constraint(equalTo: childSuperView.rightAnchor)
           ])
       
       childViewController.view.translatesAutoresizingMaskIntoConstraints = false
   }
   
   private func shouldDismissWithGesture(_ recognizer: UIPanGestureRecognizer) -> Bool {
       return recognizer.state == .ended
   }
   
   @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
       let point = recognizer.location(in: view)
       
       if shouldDismissWithGesture(recognizer) {
           dismissViewController()
       } else {
           if point.y <= originBeforeAnimation.origin.y {
               recognizer.isEnabled = false
               recognizer.isEnabled = true
               return
           }
           contentView.frame = CGRect(x: 0, y: point.y, width: view.frame.width, height: view.frame.height)
       }
   }
}

//-----------------------------------------------------------------------------
// MARK: - Event handling
//-----------------------------------------------------------------------------

extension BottomSheetViewController: UIGestureRecognizerDelegate {
   
   public func gestureRecognizer(
       _ gestureRecognizer: UIGestureRecognizer,
       shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
       ) -> Bool {
       
       return false
   }
   
   @IBAction private func topViewTap(_ sender: Any) {
       dismissViewController()
   }
}

public extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let roundedLayer = CAShapeLayer()
        roundedLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
        layer.mask = roundedLayer
    }
    
    func fadeTo(
        _ alpha: CGFloat,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        completion: (() -> Void)? = nil) {
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: {
                self.alpha = alpha
        },
            completion: nil
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    func fadeIn(duration: TimeInterval = 0.3, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        fadeTo(1, duration: duration, delay: delay, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.3, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        fadeTo(0, duration: duration, delay: delay, completion: completion)
    }
}


//--------------------------------------------------
// MARK: - UIViewController
//--------------------------------------------------

public extension UIViewController {
    func presentBottomSheet(_ bottomSheet: BottomSheetViewController, completion: (() -> Void)?) {
        self.present(bottomSheet, animated: false, completion: completion)
    }
}

public struct BRQBottomSheetViewModel: BRQBottomSheetPresentable {
   
    public var cornerRadius: CGFloat
    public var animationTransitionDuration: TimeInterval
    public var backgroundColor: UIColor
    
    public init() {
        cornerRadius = 20
        animationTransitionDuration = 0.3
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    public init(cornerRadius: CGFloat,
                animationTransitionDuration: TimeInterval,
                backgroundColor: UIColor ) {
        
        self.cornerRadius = cornerRadius
        self.animationTransitionDuration = animationTransitionDuration
        self.backgroundColor = backgroundColor
    }
}



