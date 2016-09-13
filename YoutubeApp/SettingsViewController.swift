//
//  SettingsViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 06/09/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Social
import FBSDKLoginKit
import FBSDKShareKit
import TwitterCore
import TwitterKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var model = VideoModel()
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets=false
        print(self.model.service.authorizer?.canAuthorize)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator:coordinator)
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        if indexPath.section == 0 {
            if (indexPath.row == 0) {
                cell.textLabel!.text = "Reselect Interests, Skills and Keywords"
            }
            if (indexPath.row == 1){
                cell.textLabel!.text = "Reselect Interests only"
            }
            if (indexPath.row == 2){
                cell.textLabel!.text = "Reselect Skills only"
            }
            if (indexPath.row == 3){
                cell.textLabel!.text = "Reselect Keywords only"
            }
            if (indexPath.row == 4) {
                cell.textLabel!.text = "Reset saved videos"
            }
            if (indexPath.row == 5) {
                cell.textLabel!.text = "Sign In With Google"
            }
            return cell
        } else if indexPath.section==1 {
            if (indexPath.row == 0){
                let cell2 = tableView.dequeueReusableCellWithIdentifier("Cell2")!
                cell2.textLabel!.text = "Rate us on the App Store!"
                cell2.accessoryType = .DisclosureIndicator
                return cell2
            }
            if (indexPath.row == 1){
                let cell3 = tableView.dequeueReusableCellWithIdentifier("Cell3")!
                cell3.textLabel!.text = "Share this app on Facebook!"
                let shareButton = FBSDKShareButton()
                shareButton.translatesAutoresizingMaskIntoConstraints = false
                let shareCont = FBSDKShareLinkContent()
                shareCont.contentURL=NSURL(string:"https://itunes.apple.com/us/app/discovr-youtube-video-discovery/id1154077470")
                shareCont.contentTitle="Check out this awesome app!"
                shareButton.shareContent = shareCont
                cell3.addSubview(shareButton)
                cell3.addConstraint(NSLayoutConstraint(item: cell3, attribute: .Trailing, relatedBy: .Equal, toItem: shareButton, attribute: .Trailing, multiplier: 1.0, constant: 30))
                cell3.addConstraint(NSLayoutConstraint(item: shareButton, attribute: .CenterY, relatedBy: .Equal, toItem: cell3, attribute: .CenterY, multiplier: 1.0, constant: 0))
                return cell3
                /*
                 let loginButton = FBSDKLoginButton()
                 loginButton.center = (cell.center)
                 cell.addSubview(loginButton)
                 */
                //cell.accessoryType = .DisclosureIndicator
            }
            if (indexPath.row==2) {
                let cell4 = tableView.dequeueReusableCellWithIdentifier("Cell4")!
                cell4.textLabel!.text = "Share this app on Twitter!"
                cell4.accessoryType = .DisclosureIndicator
                return cell4
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0 {
            return "General"
        } else {
            return "About"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 6
        } else {
            return 3
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                userDefaults.setObject(nil, forKey: "InterestsArray")
                userDefaults.setObject(nil, forKey: "SkillsArray")
                userDefaults.setObject(nil, forKey: "KeywordsArray")
                let nvc = storyboard.instantiateViewControllerWithIdentifier("NavigationController2") as! UINavigationController
                (nvc.viewControllers[0] as! InterestsViewController).model.service=self.model.service
                self.presentViewController(nvc, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                userDefaults.setObject(nil, forKey: "InterestsArray")
                let nvc = storyboard.instantiateViewControllerWithIdentifier("NavigationController2") as! UINavigationController
                (nvc.viewControllers[0] as! InterestsViewController).model.service=self.model.service
                self.presentViewController(nvc, animated: true, completion: nil)
            } else if indexPath.row == 2 {
                userDefaults.setObject(nil, forKey: "SkillsArray")
                let nvc = storyboard.instantiateViewControllerWithIdentifier("NavigationController2") as! UINavigationController
                let skvc = storyboard.instantiateViewControllerWithIdentifier("SkillsViewController") as! SkillsViewController
                skvc.model.service=self.model.service
                nvc.pushViewController(skvc, animated: false)
                self.presentViewController(nvc, animated: true, completion: nil)
            } else if indexPath.row == 3 {
                let nvc = storyboard.instantiateViewControllerWithIdentifier("NavigationController2") as! UINavigationController
                let kvc = storyboard.instantiateViewControllerWithIdentifier("KeywordsViewController") as! KeywordVC
                kvc.model.service=self.model.service
                nvc.pushViewController(kvc, animated: false)
                self.presentViewController(nvc, animated: true, completion: nil)
            } else if indexPath.row == 4 {
                VideoStatus.selectedVideos=[]
            } else if indexPath.row == 5 {
                if ((self.model.service.authorizer?.canAuthorize) == true) {
                    let alert = UIAlertController(title: "Error", message: "You are already signed in! If you wish to sign in with a different account, please sign out and sign in with different credentials.", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Got it!", style: .Cancel, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let sivc = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
                    sivc.checked=1
                    self.presentViewController(sivc, animated: true, completion: nil)
                }
            }
            
        } else if indexPath.section==1 {
            if indexPath.row==1 {
                
                /*
                 if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                 let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                 fbShare.setInitialText("Check out this awesome app!")
                 fbShare.addURL(NSURL(string: "https://itunes.apple.com/us/app/discovr-youtube-video-discovery/id1154077470"))
                 self.presentViewController(fbShare, animated: true, completion: nil)
                 
                 } else {
                 let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                 
                 alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                 self.presentViewController(alert, animated: true, completion: nil)
                 }
                 */
            } else if indexPath.row==2 {
                let composer = TWTRComposer()
                
                composer.setText("Check out this cool new app!")
                composer.setURL(NSURL(string: "https://itunes.apple.com/us/app/discovr-youtube-video-discovery/id1154077470"))
                
                // Called from a UIViewController
                composer.showFromViewController(self) { result in
                    if (result == TWTRComposerResult.Cancelled) {
                        print("Tweet composition cancelled")
                    }
                    else {
                        print("Sending tweet!")
                    }
                }
                /*
                 if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                 
                 let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                 tweetShare.setInitialText("Check out this awesome app!")
                 tweetShare.addURL(NSURL(string: "https://itunes.apple.com/us/app/discovr-youtube-video-discovery/id1154077470"))
                 self.presentViewController(tweetShare, animated: true, completion: nil)
                 
                 } else {
                 
                 let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
                 
                 alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                 
                 self.presentViewController(alert, animated: true, completion: nil)
                 }
                 */
            }
        }
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
