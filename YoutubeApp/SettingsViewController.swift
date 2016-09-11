//
//  SettingsViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 06/09/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model = VideoModel()
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets=false
        print(self.model.service.authorizer?.canAuthorize)
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
        } else if indexPath.section==1 {
            if (indexPath.row == 0){
                cell.textLabel!.text = "Rate us on the App Store!"
                cell.accessoryType = .DisclosureIndicator
            }
            if (indexPath.row == 1){
                cell.textLabel!.text = "Share this app on Facebook!"
                cell.accessoryType = .DisclosureIndicator
            }
            if (indexPath.row==2) {
                cell.textLabel!.text = "Share this app on Twitter!"
                cell.accessoryType = .DisclosureIndicator
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
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
