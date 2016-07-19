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
    
    var initialArray: [String] = ["philosophy","biology","chemistry","physics","mathematics","history","geography","technology"]
    var interestSelectionArray = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        
        if (interestSelectionArray == []){
            
            for row in 0...(self.collectionView.numberOfItemsInSection(0)-1) {
                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: row, inSection: 0))
                    if (cell as! InterestView).swich.on {
                    interestSelectionArray.append(initialArray[cell!.tag])
                }
            }
        } else {
            interestSelectionArray = []
            for row in 0...self.collectionView.numberOfItemsInSection(0) {
                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: row, inSection: 0))
                if (cell as! InterestView).swich.on {
                    interestSelectionArray.append(initialArray[cell!.tag])
                }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(indexPath.row), forIndexPath: indexPath)
        
        return cell
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
