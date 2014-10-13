//
//  FriendListsViewController.swift
//  FBPhotos
//
//  Created by kyo__hei on 2014/10/04.
//  Copyright (c) 2014年 kyo__hei. All rights reserved.
//

import UIKit
import Accounts
import FBPhotosKit
import Alamofire

/**
*  友達一覧画面
*/
class FriendListsViewController: BaseViewController {
    
    /**************************************************************************/
    // MARK: - Properties
    /**************************************************************************/
    
    override var account: ACAccount? {
        didSet {
            SocialManager.sharedManager.requestAboutMe()
        }
    }
    
    /**************************************************************************/
    // MARK: - View Life Cycle
    /**************************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SocialManager.sharedManager.requestAboutMe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
