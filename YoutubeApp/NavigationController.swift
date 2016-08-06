//
//  NavigationController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 30/07/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /*
     override func shouldAutorotate() -> Bool {
     let currentViewController = self.topViewController
     
     if (currentViewController!.isKindOfClass(ViewController)) {
     return false
     }
     return true
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
