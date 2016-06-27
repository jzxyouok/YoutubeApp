//
//  InterestsViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 12/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}

class InterestsViewController: UIViewController {
    
    var initialArray: [String] = ["philosophy","biology","chemistry","physics","mathematics","history","geography","technology"]
    var interestSelectionArray = [String]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var switchCollection: [UISwitch]!

    @IBAction func nextButtonClicked(sender: AnyObject) {
        if (interestSelectionArray == []){
            for swich in self.switchCollection {
                if swich.on {
                interestSelectionArray.append(initialArray[swich.tag])
                }
            }
        } else {
            interestSelectionArray = []
            for swich in self.switchCollection {
                if swich.on {
                    interestSelectionArray.append(initialArray[swich.tag])
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destViewController: SkillsViewController = segue.destinationViewController as! SkillsViewController
        destViewController.interestSelectionArray = interestSelectionArray
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
