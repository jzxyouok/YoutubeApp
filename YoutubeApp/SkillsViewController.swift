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
    
    var initialArray: [NSString] = ["philosophy","biology","chemistry","physics","history","mathematics","geography","technology"]
    var imageArray: [String] = ["philosophy.jpg","biology.jpg","chemistry.jpg","physics.jpg","history.jpg","maths.jpg","geography.jpg","technology.jpg"]
    var selectedData = [0,0,0,0,0,0,0,0]
    var interestSelectionArray = [NSString]()
    var skillSelectionArray = [NSString]()
    var numbersArray = [Int]()
    var numbersArray2 = [Int]()
    var counter: Int = 0
    var model = VideoModel()
    
    @IBAction func nextButtonClicked(_ sender: AnyObject) {
        
        self.skillSelectionArray = []
        for (index, element) in selectedData.enumerated() {
            if element == Int(1) {
                //skillSelectionArray.append(initialArray[index])
            } else if element == Int(2) {
                self.skillSelectionArray.append(initialArray[index])
            } else if element == Int(3) {
                self.skillSelectionArray.append(initialArray[index])
            } else {
            }
        }
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "KeywordsArray") as? [NSString] == nil {
            //userDefaults.set(self.skillSelectionArray, forKey: "SkillsArray")
            self.performSegue(withIdentifier: "showKeywords", sender: self)
        } else {
            print(userDefaults.object(forKey: "KeywordsArray") as! [NSString])
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tbc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).model.service=self.model.service
            let interests = userDefaults.object(forKey: "InterestsArray") as! [NSString]
            ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).interestSelectionArray = interests
            userDefaults.set(self.skillSelectionArray as [NSString], forKey: "SkillsArray")
            ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).skillSelectionArray=self.skillSelectionArray
            ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).model=self.model
            self.present(tbc, animated: true, completion: nil)
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
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        //self.tableView.backgroundColor=UIColor.blackColor()
        
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.tintColor=UIColor.white
        navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName : UIColor.white]
        navigationController!.navigationBar.isOpaque=true
        self.navigationController!.navigationBar.barStyle = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "InterestsArray") as? [NSString] != nil {
            self.navigationItem.hidesBackButton=true
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let string = initialArray[section]
        let title = string.capitalized
        
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! TableSectionHeader
        header.titleLabel.text = title
        header.image.image = UIImage(named: imageArray[section])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //cell.textLabel?.textColor=UIColor.whiteColor()
        //cell.backgroundColor=UIColor.blackColor()
        
        if (indexPath as NSIndexPath).row % 3 == 0 {
            cell.textLabel!.text = "Beginner"
        } else if (indexPath as NSIndexPath).row % 3 == 1 {
            cell.textLabel!.text = "Intermediate"
        } else {
            cell.textLabel!.text = "Expert"
        }
        
        if selectedData[(indexPath as NSIndexPath).section] == (indexPath as NSIndexPath).row+1 {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedData[(indexPath as NSIndexPath).section] != (indexPath as NSIndexPath).row+1 {
            selectedData[(indexPath as NSIndexPath).section] = (indexPath as NSIndexPath).row+1
        } else {
            selectedData[(indexPath as NSIndexPath).section] = 0
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showKeywords" {
            let destViewController: KeywordVC = segue.destination as! KeywordVC
            destViewController.interestSelectionArray = self.interestSelectionArray
            destViewController.skillSelectionArray=self.skillSelectionArray
            destViewController.model=self.model
        }
    }
}
