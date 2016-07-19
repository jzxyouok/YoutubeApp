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
    
    var initialArray: [String] = ["Philosophy","Biology","Chemistry","Physics","History","Mathematics","Geography","Technology"]
    var imageArray: [String] = ["philosophy.jpg","biology.jpg","chemistry.jpg","physics.jpg","history.jpg","maths.jpg","geography.jpg","technology.jpg"]
    var selectedData = [0,0,0,0,0,0,0,0]
    var interestSelectionArray = [String]()
    var skillSelectionArray = [String]()
    var numbersArray = [Int]()
    var numbersArray2 = [Int]()
    var counter: Int = 0
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        /*
         numbersArray = []
         numbersArray2 = []
         skillSelectionArray = []
         
         for swich in self.switchCollection2 {
         if swich.on {
         numbersArray.append(swich.tag % 8)
         numbersArray2.append(swich.tag)
         }
         }
         
         for element in numbersArray2 {
         let index = element % 8
         if ((element - (element % 8))/8==0) {
         skillSelectionArray.append(initialArray[index]+"-Beginner")
         counter += 1
         }
         if ((element - (element % 8))/8==1) {
         skillSelectionArray.append(initialArray[index]+"-Intermediate")
         counter += 1
         }
         if ((element - (element % 8))/8==2) {
         skillSelectionArray.append(initialArray[index]+"-Expert")
         counter += 1
         }
         }
         //print(skillSelectionArray)
        
         */
        
        for(index, element) in selectedData.enumerate() {
            if element == 1 {
                skillSelectionArray.append(initialArray[index]+"-Beginner")
            } else if element == 2 {
                skillSelectionArray.append(initialArray[index]+"-Intermediate")
            } else if element == 3 {
                skillSelectionArray.append(initialArray[index]+"-Expert")
            }
        }
        print(skillSelectionArray)
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
        
        let title = initialArray[section]
        
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
        let destViewController: ViewController = segue.destinationViewController as! ViewController
        destViewController.interestSelectionArray = interestSelectionArray
    }
}
