//
//  SkillsViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 22/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class SkillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var initialArray: [String] = ["philosophy","biology","chemistry","physics","history","mathematics","geography","technology"]
    var imageArray: [String] = ["philosophy.jpg","biology.jpg","chemistry.jpg","physics.jpg","history.jpg","maths.jpg","geography.jpg","technology.jpg"]
    var selectedData = [0,0,0,0,0,0,0,0]
    var interestSelectionArray = [String]()
    var skillSelectionArray = [String]()
    var numbersArray = [Int]()
    var numbersArray2 = [Int]()
    var counter: Int = 0
    var model = VideoModel()
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        
        self.skillSelectionArray = []
        for (index, element) in selectedData.enumerate() {
            if element == Int(1) {
                //skillSelectionArray.append(initialArray[index])
            } else if element == Int(2) {
                self.skillSelectionArray.append(initialArray[index])
            } else if element == Int(3) {
                self.skillSelectionArray.append(initialArray[index])
            } else {
            }
        }
        
        /*
         let alert = UIAlertController(title: "Keyword Entry", message: "Please enter keywords related to your interests and skills. Keywords should be all lowercase, and separated only by spaces with no other characters!", preferredStyle: .Alert)
         
         alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
         textField.placeholder = "Your keywords..."
         }
         
         alert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action: UIAlertAction) in
         let textField = alert.textFields?.first
         
         if textField?.text != "" {
         var myStringArr = textField?.text!.componentsSeparatedByString(" ")
         let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let nvc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
         (nvc.viewControllers.first as! ViewController).interestSelectionArray=self.interestSelectionArray+myStringArr!
         (nvc.viewControllers.first as! ViewController).skillSelectionArray=self.skillSelectionArray
         self.presentViewController(nvc, animated: true, completion: nil)
         }
         
         }))
         
         alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
         
         self.presentViewController(alert, animated: true, completion: nil)
         */
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let string = initialArray[section]
        let title = string.capitalizedString
        
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader
        header.titleLabel.text = title
        header.image.image = UIImage(named: imageArray[section])
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if indexPath.row % 3 == 0 {
            cell.textLabel!.text = "Beginner"
        } else if indexPath.row % 3 == 1 {
            cell.textLabel!.text = "Intermediate"
        } else {
            cell.textLabel!.text = "Expert"
        }
        
        if selectedData[indexPath.section] == indexPath.row+1 {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedData[indexPath.section] != indexPath.row+1 {
            selectedData[indexPath.section] = indexPath.row+1
        } else {
            selectedData[indexPath.section] = 0
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destViewController: KeywordVC = segue.destinationViewController as! KeywordVC
        destViewController.interestSelectionArray = self.interestSelectionArray
        destViewController.skillSelectionArray=self.skillSelectionArray
        destViewController.model=self.model
    }
}
