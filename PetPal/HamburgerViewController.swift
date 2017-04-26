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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            contentViewLeadingConstraint.constant = originalContentViewMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.3, animations: { 
                if velocity.x > 0.0 {
                    let quarterWidth = self.view.frame.width / 4
                    self.contentViewLeadingConstraint.constant = 3 * quarterWidth
                } else {
                    self.contentViewLeadingConstraint.constant = 0
                }
            })
        }
    }
    
}
