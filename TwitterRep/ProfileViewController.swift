//
//  ProfileViewController.swift
//  TwitterRep
//
//  Created by Joe Plumitallo on 3/2/16.
//  Copyright © 2016 Joe Plumitallo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
   
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var myProfileNameLabel: UILabel!
    @IBOutlet weak var myUsernameLabel: UILabel!
    
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var backgroundImage: UIImage!
    
    var tweet: [Tweet]?
    var twoot: Tweet?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        myProfileNameLabel.text = User.currentUser?.name as? String
        myUsernameLabel.text = "@\((User.currentUser?.screenname)!)"
        
        profileImageView.setImageWithURL((User.currentUser?.profileUrl)!)
        coverImageView.image = UIImage(named: "imgres")
        
        
        // Do any additional setup after loading the view.
        
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        TwitterClient.sharedInstance.userTimelineWithParams(nil , completion: { (tweets,error) -> () in
            
            self.tweet = tweets
            self.tableView.reloadData()
            
            
        })
        
        
        numFollowersLabel.text = "\((User.currentUser?.userFollowersCount)!)"
        numFollowing.text = "\((User.currentUser?.userFollowingCount)!)"
        numTweetsLabel.text = "\((User.currentUser?.userTweetCount)!)"
        print(User.currentUser?.userTweetCount)
    
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tweet != nil{
            
            return (tweet?.count)!
            
        }else{
            
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        
        cell.tweet = tweet![indexPath.row]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
    */
    
    
}

