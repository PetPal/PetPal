//
//  HamburgerViewController.swift
//  PetPal
//
//  Created by LING HAO on 4/19/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet var menuView: UIView!
    @IBOutlet var contentView: UIView!
    
    var menuViewController: MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            
            contentView.addSubview(contentViewController.view)
            
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseIn, animations: {
                self.contentViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (complete: Bool) in
            }
        }
    }
    
    @IBOutlet var contentViewLeadingConstraint: NSLayoutConstraint!
    var originalContentViewMargin: CGFloat = 0.0
    var quarterWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quarterWidth = view.frame.width / 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onPanContentView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            originalContentViewMargin = contentViewLeadingConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            let offset = originalContentViewMargin + translation.x
            if offset >= 0 {
                if velocity.x > 0.0 {
                    let scale = 1 - ((translation.x / (3 * quarterWidth)) * 0.1)
                    contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
                } else {
                    let scale = ((-translation.x / (3 * quarterWidth)) * 0.1) + 0.9
                    contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
                contentViewLeadingConstraint.constant = offset
            }
        } else if sender.state == UIGestureRecognizerState.ended {
//            UIView.animate(withDuration: 1.0, animations: {
//                if velocity.x > 0.0 {
//                    self.contentViewLeadingConstraint.constant = 3 * self.quarterWidth
//                } else {
//                    self.contentViewLeadingConstraint.constant = 0
//                }
//            })
            UIView.animate(withDuration: 1.0, animations: {
                if velocity.x > 0.0 {
                    // translate then scale (only translate)
//                    let transform = CGAffineTransform(translationX: 3 * self.quarterWidth, y: 0)
//                    transform.concatenating(CGAffineTransform(scaleX: 0.9, y: 0.9))
                    // scale then translate (only scale)
//                    let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                    transform.concatenating(CGAffineTransform(translationX: 3 * self.quarterWidth, y: 0))
                    let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.contentView.transform = transform
                    self.contentViewLeadingConstraint.constant = 3 * self.quarterWidth
                } else {
                    let transform = CGAffineTransform(translationX: 0, y: 0)
                    transform.scaledBy(x: 1.0, y: 1.0)
                    print("transform \(transform)")
                    self.contentView.transform = transform
                    self.contentViewLeadingConstraint.constant = 0
                }
            })
        }
    }
    
}
