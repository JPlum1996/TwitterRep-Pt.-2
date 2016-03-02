//
//  User.swift
//  TwitterRep
//
//  Created by Joe Plumitallo on 2/22/16.
//  Copyright © 2016 Joe Plumitallo. All rights reserved.
//

import UIKit

let userDidLoginNotification = "userDidLoginNotification"
let userDidTweetNotification = "userDidTweetNotification"

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var profileBannerURL: NSURL?
    var profileBannerString: String?
    
    var userTweetCount: Int?
    var userFollowersCount: Int?
    var userFollowingCount: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
        } else {
            profileUrl = nil
        }
        
        tagline = dictionary["description"] as? String
        
        profileBannerString = dictionary["profile_banner_url"] as? String
        
        userTweetCount = dictionary["statuses_count"] as? Int
        userFollowingCount = dictionary["friends_count"] as? Int
        userFollowersCount = dictionary["followers_count"] as? Int
        
        
        if profileBannerString != nil {
            profileBannerURL = NSURL(string: profileBannerString!)!
        }
        else {
            profileBannerURL = nil
        }

    }
    
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    let udln = userDidLogoutNotification
    
    static var _currentUser: User?
    
    func logout() {
        
        User.currentUser = nil
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(udln, object: nil)
    }

    
    func tweeted() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidTweetNotification, object: nil)
    }
    
    class var currentUser: User?{
        get {
            if _currentUser == nil{
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let userData = defaults.objectForKey("currentUserData") as? NSData
        
            if let userData = userData {
                let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                _currentUser = User(dictionary: dictionary)
                }
        
            }
            
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    
        
    }
    
}