//
//  LoginViewController.swift
//  FBPhotos
//
//  Created by kyo__hei on 2014/10/04.
//  Copyright (c) 2014年 kyo__hei. All rights reserved.
//

import UIKit
import FBPhotoViewerKit
import Accounts

class LoginViewController: BaseViewController {
    
    /**************************************************************************/
    // MARK: - Types
    /**************************************************************************/
    
    

    /**************************************************************************/
    // MARK: - View Life Cycle
    /**************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**************************************************************************/
    // MARK: - IBAction
    /**************************************************************************/
    
    @IBAction func didTapLoginButton(sender: UIButton) {
        SocialManager.sharedManager.requestAccessWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook, completion: { (accounts: [AnyObject]?, error: NSError!) -> Void in
            
            if error != nil {
                // エラー
                self.showAlertWithError(error)
            } else if accounts?.count == 0 {
                // アカウント0
                println("アカウント無し")
            } else if accounts?.count == 1 {
                let account = accounts?[0] as ACAccount
                println(account)
                
                let friendsVC = self.storyboard?.instantiateViewControllerWithIdentifier(MainStoryboard.ViewControllerIdentifiers.friendListsViewController) as FriendListsViewController
                friendsVC.account = account
                self.navigationController?.setViewControllers([friendsVC], animated: true)
                
            } else {
                // アカウントが複数
                println(accounts)
            }
        })
    }
}
