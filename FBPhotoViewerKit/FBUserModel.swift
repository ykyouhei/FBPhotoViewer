//
//  FBUserModel.swift
//  FBPhotos
//
//  Created by kyo__hei on 2014/10/05.
//  Copyright (c) 2014年 kyo__hei. All rights reserved.
//

import UIKit

/**
*  Facebookのユーザモデル
*/
public class FBUserModel {
    
    /**************************************************************************/
    // MARK: - Properties
    /**************************************************************************/
    
    public let id: String?
    public let userName: String?
   
    private let _coverURL: NSURL?
    private let _pictureURL: NSURL?
    
    /**************************************************************************/
    // MARK: - Initializer
    /**************************************************************************/
    
    public init(response: [String: AnyObject]) {
        self.id = response["id"] as AnyObject? as? String
        self.userName = response["name"] as AnyObject? as? String
        if let coverURL = response["cover"]?["source"] as AnyObject? as? String {
            self._coverURL = NSURL(string: coverURL)
        }
        if let pictureURL = response["picture"]?["url"] as AnyObject? as? String {
            self._pictureURL = NSURL(string: pictureURL)
        }
    }
    
    /**************************************************************************/
    // MARK: - Public Method
    /**************************************************************************/
    
    public func description() -> String {
        return "id: \(id)\nuserName:\(userName)"
    }
}
