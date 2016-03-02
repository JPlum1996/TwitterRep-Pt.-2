//
//  userProfileViewController.swift
//  TwitterRep
//
//  Created by Joe Plumitallo on 3/1/16.
//  Copyright © 2016 Joe Plumitallo. All rights reserved.
//

import UIKit


class userProfileViewController: UIViewController {
    
    var tweet: Tweet?
    
    var backgroundImage: UIImage!

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profilePic.setImageWithURL((tweet!.user?.profileUrl)!)
        
        screenName.text = tweet?.user?.name as? String
        
        userName.text = "@\((tweet!.user?.screenname)!)"
        
        
        
        let data = NSData(contentsOfURL: (tweet?.user?.profileBannerURL)!)
        backgroundImage = UIImage(data: data!)
        
        
        coverImageView.image = backgroundImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
