//
//  InterestsViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 12/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}

class InterestsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var initialArray: [NSString] = ["philosophy","biology","chemistry","physics","history","mathematics","geography","technology"]
    var interestSelectionArray = [NSString]()
    var model = VideoModel()
    var switchArray: [Int] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBAction func nextButtonClicked(_ sender: AnyObject) {
        
        if (interestSelectionArray == []){
            for index in switchArray {
                interestSelectionArray.append(initialArray[index])
            }
        } else {
            interestSelectionArray = []
            for index in switchArray {
                interestSelectionArray.append(initialArray[index])
            }
        }
        let userDefaults=UserDefaults.standard
        
        if userDefaults.object(forKey: "SkillsArray") as? [NSString] != nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tbc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            if userDefaults.object(forKey: "InterestsArray") as? [NSString] == nil {
                userDefaults.set(self.interestSelectionArray as [NSString], forKey: "InterestsArray")
            }
            (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).model.service=self.model.service
            ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).skillSelectionArray=(userDefaults.object(forKey: "SkillsArray") as? [NSString])!
            if userDefaults.object(forKey: "SelectedVideos") as? Data == nil {
                VideoStatus.selectedVideos=[]
                (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).videos=VideoStatus.selectedVideos
                
            }
            let keywords=userDefaults.object(forKey: "KeywordsArray") as? [NSString]
            print(keywords)
            if keywords != nil {
                ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).interestSelectionArray=self.interestSelectionArray+keywords!
            } else {
                ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).interestSelectionArray=self.interestSelectionArray
            }
            ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).model=self.model
            self.present(tbc, animated: true, completion: nil)
        } else {
            //userDefaults.set(self.interestSelectionArray as [NSString], forKey: "InterestsArray")
            self.performSegue(withIdentifier: "showSkills", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = nil
        //collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.tintColor=UIColor.white
        navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName : UIColor.white]
        navigationController!.navigationBar.isOpaque=true
        self.navigationController!.navigationBar.barStyle = .black
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController: SkillsViewController = segue.destination as! SkillsViewController
        destViewController.interestSelectionArray = interestSelectionArray
        destViewController.model=self.model
        print(interestSelectionArray)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String((indexPath as NSIndexPath).row), for: indexPath) as! InterestView
        cell.swich.addTarget(self, action: #selector(InterestsViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        return cell
    }
    
    
    func switchChanged(_ swich: UISwitch) {
        
        if swich.isOn && switchArray.contains(swich.tag){
            
        } else if swich.isOn {
            switchArray.append(swich.tag)
        } else if !swich.isOn && switchArray.contains(swich.tag) {
            switchArray = switchArray.filter{$0 != swich.tag}
        } else {
            
        }
        print(switchArray)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        var number = CGFloat(2.0)
        if width > 561 {
            number = 3.0
        }
        return CGSize(width: ((width-(number-1)*(collectionViewFlowLayout.minimumInteritemSpacing))/number), height: ((width-(number-1)*(collectionViewFlowLayout.minimumInteritemSpacing))/number))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with:coordinator)
        self.collectionView.reloadData()
    }
    
}
