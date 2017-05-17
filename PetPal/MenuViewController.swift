//
//  MenuViewController.swift
//  PetPal
//
//  Created by LING HAO on 4/19/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

struct MenuItem {
    var title: String
    var color: UIColor
    var image: UIImage?
    var viewController: UIViewController?
    
    init(title: String, color: UIColor, image: UIImage?) {
        self.title = title
        self.color = color
        self.image = image
    }
}

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var collectionViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewLeadingConstraint: NSLayoutConstraint!
    // padding to make menu more centered
    let collectionViewBuffer = 20
    
    let initialMenuSelection = "initialMenuSelection"
    
    // profile show on top of view
    var profileNavigationController: UIViewController!
    var requestsNavigationController: UIViewController!
    var calendarNavigationController: UIViewController!
    var groupNavigationController: UITabBarController!
    var messagesNavigationController: UIViewController!
    var settingsNavigationController: UIViewController!
    
    // Make sure to set the viewController in viewDidLoad
    var menuItems: [MenuItem] = [
        MenuItem(title: "Requests", color: UIColor(colorWithHexValue: 0xE08E43), image: UIImage(named: "requests_64")),
        MenuItem(title: "Calendar", color: UIColor(colorWithHexValue: 0x7E4DC3), image: UIImage(named: "calendar_64")),
        MenuItem(title: "Groups", color: UIColor(colorWithHexValue: 0x9DA933), image: UIImage(named: "groups_64")),
        MenuItem(title: "Messages", color: UIColor(colorWithHexValue: 0x397FCC), image: UIImage(named: "chats_64")),
        MenuItem(title: "Logout", color: UIColor(colorWithHexValue: 0xC44D58), image: UIImage(named: "logout_64"))
    ]
    
    weak var hamburgerViewController: HamburgerViewController! {
        didSet {
            view.layoutIfNeeded()
            let defaults = UserDefaults.standard
            let key = initialMenuSelection + (User.currentUser?.screenName ?? "")
            if defaults.object(forKey: key) == nil {
                hamburgerViewController.contentViewController = profileNavigationController
            } else {
                let initIndex = defaults.integer(forKey: key)
                hamburgerViewController.contentViewController = menuItems[initIndex].viewController
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let user = User.currentUser
        profileName.text = user?.name
        if let avatar = user?.userAvatar {
            profileImage.file = avatar
            profileImage.loadInBackground()
            profileImage.setRounded()
        }
        
        initProfileView()
        NotificationCenter.default.addObserver(forName: PetPalConstants.userGroupUpdated, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.initProfileView()
        }
        
        // set collection view's content to be the visible view area
        collectionViewTrailingConstraint.constant = (view.frame.width / 4) + CGFloat(collectionViewBuffer)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        groupNavigationController = storyboard.instantiateViewController(withIdentifier: "GroupTabBarController") as! UITabBarController
        
        messagesNavigationController = storyboard.instantiateViewController(withIdentifier: "messagesNavigationController")
        
        let requestStoryboard = UIStoryboard(name: "Request", bundle: nil)
        requestsNavigationController = requestStoryboard.instantiateViewController(withIdentifier: "RequestsNavigationController")
        calendarNavigationController = requestStoryboard.instantiateViewController(withIdentifier: "CalendarNavigationController")

        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController")

        menuItems[0].viewController = requestsNavigationController
        menuItems[1].viewController = calendarNavigationController
        menuItems[2].viewController = groupNavigationController
        menuItems[3].viewController = messagesNavigationController
     }
    
    func initProfileView() {
        let user = User.currentUser
        profileName.text = user?.name
        if let avatar = user?.userAvatar {
            profileImage.file = avatar
            profileImage.loadInBackground()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTapProfile(_ sender: UITapGestureRecognizer) {
        hamburgerViewController.contentViewController = profileNavigationController
    }
    
    // MARK: - UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuItemCollectionViewCell
        cell.menuItem = menuItems[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewController = menuItems[indexPath.row].viewController {
            let defaults = UserDefaults.standard
            let key = initialMenuSelection + (User.currentUser?.screenName ?? "")
            defaults.set(indexPath.row, forKey: key)
            
            hamburgerViewController.contentViewController = viewController
        } else {
            Utilities.logoutUser()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - collectionViewTrailingConstraint.constant - collectionViewLeadingConstraint.constant - CGFloat(collectionViewBuffer)
        // show 2 column menu
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
   
    // MARK: - Animation
    func animateMenus() {
//        collectionView.performBatchUpdates({ 
//            let indexSet = IndexSet(integer: 0)
//            self.collectionView.reloadSections(indexSet)
//        }, completion: nil)
    }

   
}
