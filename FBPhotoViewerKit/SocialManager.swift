//
//  SocialManager.swift
//  FBPhotos
//
//  Created by kyo__hei on 2014/10/04.
//  Copyright (c) 2014年 kyo__hei. All rights reserved.
//

import UIKit
import Foundation
import Accounts
import Social

/**
*  ソーシャルアカウントへのアクセスなどを管理するシングルトンクラス
*/
public class SocialManager: NSObject {
    
    public typealias RequestAccessCompletionHandler = ([AnyObject]?, NSError!) -> Void
    public typealias RequestAboutUserCompletionHandler = (FBUserModel?, NSError!) -> Void
    
    /**************************************************************************/
    // MARK: - Types
    /**************************************************************************/
    public struct Error {
        static let errorDomain = "SocialManager"
        
        struct Code {
            static let userNotGranted = 1
            static let notSupportedType = 2
        }
    }
    
    private struct GraphAPIEndPoint {
        static let root = "https://graph.facebook.com"
        
        static let me = root + "/me"
    }
    
    /**************************************************************************/
    // MARK: - Properties
    /**************************************************************************/
    
    private let _fbAppID = "268362399954732"
    private let _store = ACAccountStore()
    private var _fbAccount: ACAccount?
    
    /**************************************************************************/
    // MARK: - Initializer
    /**************************************************************************/
    private override init() {
        
    }
    
    public class var sharedManager : SocialManager {
    struct Static {
        static let instance : SocialManager = SocialManager()
        }
        return Static.instance
    }
    
    
    /**************************************************************************/
    // MARK: - Public Method
    /**************************************************************************/
    
    /**
    各種ソーシャルアカウントへのアクセス権限を確認する
    
    :param: id ソーシャルアカウントのID
    
    :returns: アクセス権限
    */
    public func accessGrantedWithAccountTypeIdentifier(id: NSString) -> Bool {
        let accountType = _store.accountTypeWithAccountTypeIdentifier(id)
        return accountType.accessGranted
    }
    
    /**
    各種ソーシャルアカウントへのアクセスを要求する
    
    :param: id         ソーシャルアカウントのID
    :param: completion ユーザが返答した際のコールバック
    */
    public func requestAccessWithAccountTypeIdentifier(id: NSString, completion: RequestAccessCompletionHandler) {
        let accountType = _store.accountTypeWithAccountTypeIdentifier(id)
        var options: [NSObject : AnyObject]?
        
        if id.isEqualToString(ACAccountTypeIdentifierFacebook) {
           let permissions = ["email", "user_about_me", "user_likes", "user_photos"]
            options = [ACFacebookAppIdKey: _fbAppID,
                ACFacebookPermissionsKey: permissions,
                ACFacebookAudienceKey: ACFacebookAudienceFriends]
        } else {
            let error = NSError(domain: Error.errorDomain, code: Error.Code.notSupportedType, userInfo: nil)
            completion(nil, error)
        }
        
        _store.requestAccessToAccountsWithType(accountType, options: options) { (granted: Bool, error:
            NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if error != nil {
                    completion(nil, error)
                    return
                } else if granted == false {
                    let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("errorNotGranted", comment: "")]
                    let grantError = NSError(domain: Error.errorDomain, code: Error.Code.userNotGranted, userInfo: userInfo)
                    completion(nil, grantError)
                } else {
                    let accounts = self._store.accountsWithAccountType(accountType)
                    self._fbAccount = accounts?[0] as? ACAccount
                    completion(accounts, nil)
                }
            })
        }
    }
    
    public func requestAboutMeWithCompletion(completion: RequestAboutUserCompletionHandler) {
        let url = NSURL(string: GraphAPIEndPoint.me)
        let params = ["fields": "cover,picture.type(large),name",
                      "locale": "ja_JP"]
        let request = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, URL: url, parameters: params)
        request.account = _fbAccount
        request.performRequestWithHandler { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error != nil {
                    completion(nil, error)
                } else {
                    var jsonError: NSError?
                    if let result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as? [String: AnyObject] {
                        
                        var userModel = FBUserModel(response: result)
                        completion(userModel, nil)
                    } else {
                        completion(nil, jsonError)
                    }
                }
            })
        }
    }
}