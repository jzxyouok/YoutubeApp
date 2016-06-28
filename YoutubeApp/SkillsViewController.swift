//
//  SkillsViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 22/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class SkillsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var switchCollection2: [UISwitch]!
    
    var initialArray: [String] = ["Philosophy","Biology","Chemistry","Physics","History","Mathematics","Geography","Technology"]
    var interestSelectionArray = [String]()
    var skillSelectionArray = [String]()
    var numbersArray = [Int]()
    var numbersArray2 = [Int]()
    var test: Int = 0
    var counter: Int = 0
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        
        test=0
        numbersArray = []
        numbersArray2 = []
        skillSelectionArray = []
        
        for swich in self.switchCollection2 {
            if swich.on {
                numbersArray.append(swich.tag % 8)
                numbersArray2.append(swich.tag)
            }
        }
        
        let duplicates = Array(Set(numbersArray.filter({ (i: Int) in numbersArray.filter({ $0 == i }).count > 1})))
        
        if (duplicates != []){
            print("Please don't choose multiple skill levels for a skill!")
            let alertController = UIAlertController(title: "Alert!", message:
                "You can't select more than one skill level for a given skill!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        if (duplicates == []) {
            
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
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
