//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Ryan M on 4/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweets = [NSDictionary]()
    var numOfTweets: Int!
    
    let tweetRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        tweetRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = tweetRefreshControl

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func loadTweets(){
        numOfTweets = 20
        let tweetsUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count":numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsUrl, parameters: params, success: { (tweets: [NSDictionary]) in
            
            self.tweets.removeAll()
            for tweet in tweets{
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
            self.tweetRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("ERROR: Couldnt get tweets.")
        })
    }
    
    func loadMoreTweets(){
        let tweetsUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweets = numOfTweets + 20
        let params = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsUrl, parameters: params, success: { (tweets: [NSDictionary]) in
            
            self.tweets.removeAll()
            for tweet in tweets{
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("ERROR: Couldnt get additional tweets.")
        })
    
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweets[indexPath.row]["user"] as! NSDictionary
        cell.profileNameLabel.text = user["name"] as? String
        cell.contentLabel.text = tweets[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let imageData = try? Data(contentsOf: imageUrl!)
        if let imageData = imageData {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweets.count {
            loadMoreTweets()
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
