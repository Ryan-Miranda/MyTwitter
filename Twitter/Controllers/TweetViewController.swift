//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ryan M on 5/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var numCharsLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    let characterLimit = 280
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
        numCharsLabel.text = "\(characterLimit)/\(characterLimit)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        numCharsLabel.text = "\(characterLimit - newText.count)/\(characterLimit)"
        return (newText.count < characterLimit)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Failed to post tweet: \(error)")
                
                let alertController = UIAlertController(title: "Error", message: "Tweet failed to post.", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in}
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
                
                //self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Tweet content is empty.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in}
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
