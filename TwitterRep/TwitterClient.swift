//
//  TwitterClient.swift
//  TwitterRep
//
//  Created by Joe Plumitallo on 2/22/16.
//  Copyright © 2016 Joe Plumitallo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "VjgsoaTBOq2hfN1TBhGBMmlcW", consumerSecret: "XYILiX9ryvnAgnGSwyH1BVU4FjX4pcYMpQPV9JTtg8G1v790yX")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "TwitterRep://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure
                })
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
               failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    
    func retweetWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/retweet/\(params!["id"] as! Int).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            //print("This is the retweetCount: \(tweet.retweetCount)")
            //print("This is the favCount: \(tweet.favCount)")
            
            //  print(tweet)
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        }
    }
    
    func tweetWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/update.json?status=\(params!["status"] as! String)", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        }
    }
    
    func userTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        
        GET("1.1/statuses/user_timeline.json", parameters: params,
            
            success: {
                (
                operation: NSURLSessionDataTask,
                response: AnyObject?) -> Void in
                //print("home_timeline: \(response!)")
                
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                completion(tweets: tweets, error:nil)
                
            },
            failure: { (
                operation: NSURLSessionDataTask?,
                error: NSError!) -> Void in
                print("error getting current user")
                User.currentUser?.logout()
                completion(tweets: nil , error: error)
                
                
                
        })
        
        
    }

}
