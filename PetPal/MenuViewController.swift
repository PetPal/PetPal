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
    
    // profile show on top of view
    var profileNavigationController: UIViewController!
    
    var requestsNavigationController: UIViewController!
    var groupNavigationController: UIViewController!
    var chatNavigationController: UIViewController!
    
    // Make sure to set the viewController in viewDidLoad
    var menuItems: [MenuItem] = [
        MenuItem(title: "Requests", color: UIColor(colorLiteralRed: 224/256, green: 142/256, blue: 67/256, alpha: 1.0), image: UIImage(named: "requests_64")),
        MenuItem(title: "Groups", color: UIColor(colorLiteralRed: 157/256, green: 169/256, blue: 61/256, alpha: 1.0), image: UIImage(named: "groups_64")),
        MenuItem(title: "Chats", color: UIColor(colorLiteralRed: 57/256, green: 127/256, blue: 204/256, alpha: 1.0), image: UIImage(named: "chats_64")),
        MenuItem(title: "Logout", color: UIColor(colorLiteralRed: 196/256, green: 77/256, blue: 88/256, alpha: 1.0), image: UIImage(named: "logout_64"))
    ]
    
    weak var hamburgerViewController: HamburgerViewController! {
        didSet {
            view.layoutIfNeeded()
            hamburgerViewController.contentViewController = menuItems[0].viewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // initialize profile view
        let user = User.currentUser
        profileName.text = user?.name
        if let avatar = user?.userAvatar {
            profileImage.file = avatar
            profileImage.loadInBackground()
        }
        
        // set collection view's content to be the visible view area
        collectionViewTrailingConstraint.constant = (view.frame.width / 4) + CGFloat(collectionViewBuffer)

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        groupNavigationController = storyboard.instantiateViewController(withIdentifier: "GroupNavigationController")
        chatNavigationController = storyboard.instantiateViewController(withIdentifier: "ChatNavigationController")
        
        let requestStoryboard = UIStoryboard(name: "Request", bundle: nil)
        requestsNavigationController = requestStoryboard.instantiateViewController(withIdentifier: "RequestsNavigationController")

        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController")

        menuItems[0].viewController = requestsNavigationController
        menuItems[1].viewController = groupNavigationController
        menuItems[2].viewController = chatNavigationController
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
}
