//
//  SettingsViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 06/09/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
        } else if indexPath.section==1 {
            cell.textLabel!.text = "test"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 4
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfSectionsInTableView: Int) -> Int {
        return 2
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
