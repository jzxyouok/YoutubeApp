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

class InterestsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var initialArray: [String] = ["philosophy","biology","chemistry","physics","history","mathematics","geography","technology"]
    var interestSelectionArray = [String]()
    var model = VideoModel()
    var switchArray: [Int] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = nil
        //collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destViewController: SkillsViewController = segue.destinationViewController as! SkillsViewController
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(indexPath.row), forIndexPath: indexPath) as! InterestView
        cell.swich.addTarget(self, action: #selector(InterestsViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return cell
    }
    
    func switchChanged(swich: UISwitch) {
        
        if swich.on && switchArray.contains(swich.tag){
            
        } else if swich.on {
            switchArray.append(swich.tag)
        } else if !swich.on && switchArray.contains(swich.tag) {
            switchArray = switchArray.filter{$0 != swich.tag}
        } else {
            
        }
        print(switchArray)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = CGRectGetWidth(collectionView.frame)
        var number = CGFloat(2.0)
        if width > 561 {
            number = 3.0
        }
        return CGSize(width: ((width-(number-1)*(collectionViewFlowLayout.minimumInteritemSpacing))/number), height: ((width-(number-1)*(collectionViewFlowLayout.minimumInteritemSpacing))/number))
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator:coordinator)
        self.collectionView.reloadData()
    }
    
}
