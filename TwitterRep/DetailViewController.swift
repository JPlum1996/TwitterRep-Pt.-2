//
//  DetailViewController.swift
//  TwitterRep
//
//  Created by Joe Plumitallo on 3/1/16.
//  Copyright © 2016 Joe Plumitallo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var more: UIImageView!
    @IBOutlet weak var like: UIImageView!
    @IBOutlet weak var retweet: UIImageView!
    @IBOutlet weak var reply: UIImageView!
    @IBOutlet weak var bird: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var sName: UILabel!
    @IBOutlet weak var uName: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
    
    var tweeet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.setImageWithURL((tweeet!.user?.profileUrl)!)
        sName.text = tweeet?.user?.name as? String
        uName.text = "@\((tweeet!.user?.screenname)!)"
        tweet.text = tweeet?.text as? String
        more.image = UIImage(named: "iconmonstr-share-2-240")
        like.image = UIImage(named: "iconmonstr-favorite-8-240")
        retweet.image = UIImage(named: "iconmonstr-retweet-1-240")
        reply.image = UIImage(named: "iconmonstr-undo-4-240")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    
    let _userProfileViewController = segue.destinationViewController as!
        userProfileViewController
        
        _userProfileViewController.tweet = tweeet
    
    }


}
