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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with:coordinator)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if (indexPath as NSIndexPath).section == 0 {
            if ((indexPath as NSIndexPath).row == 0) {
                cell.textLabel!.text = "Reselect Interests, Skills and Keywords"
            }
            if ((indexPath as NSIndexPath).row == 1){
                cell.textLabel!.text = "Reselect Interests only"
            }
            if ((indexPath as NSIndexPath).row == 2){
                cell.textLabel!.text = "Reselect Skills only"
            }
            if ((indexPath as NSIndexPath).row == 3){
                cell.textLabel!.text = "Reselect Keywords only"
            }
            if ((indexPath as NSIndexPath).row == 4) {
                cell.textLabel!.text = "Reset saved videos"
            }
            if ((indexPath as NSIndexPath).row == 5) {
                cell.textLabel!.text = "Sign In With Google"
            }
            return cell
        } else if (indexPath as NSIndexPath).section==1 {
            if ((indexPath as NSIndexPath).row == 0){
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")!
                cell2.textLabel!.text = "Rate us on the App Store!"
                cell2.accessoryType = .disclosureIndicator
                return cell2
            }
            if ((indexPath as NSIndexPath).row == 1){
                let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3")!
                cell3.textLabel!.text = "Share this app on Facebook!"
                let shareButton = FBSDKShareButton()
                shareButton.translatesAutoresizingMaskIntoConstraints = false
                let shareCont = FBSDKShareLinkContent()
                shareCont.contentURL=URL(string:"https://itunes.apple.com/us/app/discovr-youtube-video-discovery/id1154077470")
                shareCont.contentTitle="Check out this awesome app!"
                shareButton.shareContent = shareCont
                cell3.addSubview(shareButton)
                cell3.addConstraint(NSLayoutConstraint(item: cell3, attribute: .trailing, relatedBy: .equal, toItem: shareButton, attribute: .trailing, multiplier: 1.0, constant: 30))
                cell3.addConstraint(NSLayoutConstraint(item: shareButton, attribute: .centerY, relatedBy: .equal, toItem: cell3, attribute: .centerY, multiplier: 1.0, constant: 0))
                return cell3
                /*
                 let loginButton = FBSDKLoginButton()
                 loginButton.center = (cell.center)
                 cell.addSubview(loginButton)
                 */
                //cell.accessoryType = .DisclosureIndicator
            }
            if ((indexPath as NSIndexPath).row==2) {
                let cell4 = tableView.dequeueReusableCell(withIdentifier: "Cell4")!
                cell4.textLabel!.text = "Share this app on Twitter!"
                cell4.accessoryType = .disclosureIndicator
                return cell4
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0 {
            return "General"
        } else {
            return "About"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 6
        } else {
            return 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDefaults = UserDefaults.standard
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tableView.deselectRow(at: indexPath, animated: false)
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                userDefaults.set(nil, forKey: "InterestsArray")
                userDefaults.set(nil, forKey: "SkillsArray")
                userDefaults.set(nil, forKey: "KeywordsArray")
                let nvc = storyboard.instantiateViewController(withIdentifier: "NavigationController2") as! UINavigationController
                (nvc.viewControllers[0] as! InterestsViewController).model.service=self.model.service
                self.present(nvc, animated: true, completion: nil)
            } else if (indexPath as NSIndexPath).row == 1 {
                userDefaults.set(nil, forKey: "InterestsArray")
                let nvc = storyboard.instantiateViewController(withIdentifier: "NavigationController2") as! UINavigationController
                (nvc.viewControllers[0] as! InterestsViewController).model.service=self.model.service
                self.present(nvc, animated: true, completion: nil)
            } else if (indexPath as NSIndexPath).row == 2 {
                userDefaults.set(nil, forKey: "SkillsArray")
                let nvc = storyboard.instantiateViewController(withIdentifier: "NavigationController2") as! UINavigationController
                let skvc = storyboard.instantiateViewController(withIdentifier: "SkillsViewController") as! SkillsViewController
                skvc.model.service=self.model.service
                nvc.pushViewController(skvc, animated: false)
                self.present(nvc, animated: true, completion: nil)
            } else if (indexPath as NSIndexPath).row == 3 {
                let nvc = storyboard.instantiateViewController(withIdentifier: "NavigationController2") as! UINavigationController
                let kvc = storyboard.instantiateViewController(withIdentifier: "KeywordsViewController") as! KeywordVC
                kvc.model.service=self.model.service
                nvc.pushViewController(kvc, animated: false)
                self.present(nvc, animated: true, completion: nil)
            } else if (indexPath as NSIndexPath).row == 4 {
                let alert = UIAlertController(title: "Are you sure?", message: "You are about to reset your saved videos. This action cannot be undone.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in
                    VideoStatus.selectedVideos=[]
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if (indexPath as NSIndexPath).row == 5 {
                if ((self.model.service.authorizer?.canAuthorize) == true) {
                    let alert = UIAlertController(title: "Error", message: "You are already signed in! If you wish to sign in with a different account, please sign out and sign in with different credentials.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Got it!", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let nvc = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
                    let sivc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    sivc.checked=1
                    nvc.pushViewController(sivc, animated: false)
                    self.present(nvc, animated: true, completion: nil)
                }
            }
            
        } else if (indexPath as NSIndexPath).section==1 {
            if (indexPath as NSIndexPath).row==0 {
                UIApplication.shared.openURL(URL(string : "itms-apps://itunes.apple.com/app//id1154077470")!)
            } else if (indexPath as NSIndexPath).row==1 {
                
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
            } else if (indexPath as NSIndexPath).row==2 {
                let composer = TWTRComposer()
                
                composer.setText("Check out this cool new app!")
                composer.setURL(URL(string: "https://itunes.apple.com/us/app/discovr-youtube-video-discovery/id1154077470"))
                
                // Called from a UIViewController
                composer.show(from: self) { result in
                    if (result == TWTRComposerResult.cancelled) {
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
