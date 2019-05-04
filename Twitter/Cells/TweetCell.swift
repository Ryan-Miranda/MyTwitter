//
//  TweetCell.swift
//  Twitter
//
//  Created by Ryan M on 4/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var favorited:Bool = false
    var tweetID:Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFavorite(_ isFave: Bool) {
        favorited = isFave
        if (favorited) {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFaved = !favorited
        
        if (toBeFaved){
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(true)
        
            }, failure: { (error) in
                print("Failed to favorite tweet: \(error)")
                
                let alertController = UIAlertController(title: "Error", message: "Could not favorite tweet.", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in}
                alertController.addAction(action1)
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            })
        }
        else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(false)
                
            }, failure: { (error) in
                print("Failed to unfavorite tweet: \(error)")
                
                let alertController = UIAlertController(title: "Error", message: "Could not unfavorite tweet.", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in}
                alertController.addAction(action1)
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
    }
    
}
