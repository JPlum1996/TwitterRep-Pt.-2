//
//  Tweet.swift
//  TwitterRep
//
//  Created by Joe Plumitallo on 2/22/16.
//  Copyright © 2016 Joe Plumitallo. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var user: User?
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var createdAtString: String?
    var createdAt: NSDate?
    var timeAgo: String?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    class func tweetAsDictionary(dict: NSDictionary) -> Tweet {
        
        // print(dict)
        
        let tweet = Tweet(dictionary: dict)
        
        return tweet
    }
}
