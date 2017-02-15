//
//  Animator.swift
//  Apss
//
//  Created by Eli Pacheco Hoyos on 4/7/16.
//  Copyright © 2016 Grability. All rights reserved.
//

import UIKit
import Foundation

enum AnimationType {
    case fade
    case bounce
    case c
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var timeForTransition : Double
    var type: AnimationType
    
    init(timeForTransition : Double, type: AnimationType) {
        self.timeForTransition = timeForTransition
        self.type = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timeForTransition
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        containerView.sendSubview(toBack: toViewController.view)
        containerView.addSubview(toViewController.view)
        
        if type == .fade {
            
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            
            toViewController.view.alpha = 0.0
            UIView.animate(withDuration: timeForTransition, animations: {
                fromViewController.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                toViewController.view.alpha = 1.0
            }, completion: { (finished) in
                fromViewController.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })

        }
        
        if type == .bounce {
            
            toViewController.view.frame = CGRect(x: toViewController.view.frame.origin.x,
                                                 y: toViewController.view.frame.origin.y,
                                                 width: fromViewController.view.frame.width,
                                                 height:fromViewController.view.frame.height)
            
            containerView.addSubview(toViewController.view)
            UIView.animate(withDuration: timeForTransition, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5.0, options: .curveLinear, animations: {
                toViewController.view.frame = fromViewController.view.frame
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        }
        
        if type == .c {
        
        }

    }
    
}

extension AnimationType: Equatable {
    static func ==(left: AnimationType, right: AnimationType) -> Bool {
        switch (left, right) {
        case (.fade, .fade):
            return true
        case (.bounce, .bounce):
            return true
        case (.c, .c):
            return true
        default:
            return false
        }
    }
}
