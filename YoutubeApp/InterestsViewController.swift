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

class InterestsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    var initialArray: [NSString] = ["philosophy","biology","chemistry","physics","history","mathematics","geography","technology","film and animation", "sports","music","animals","comedy","action","gaming","vlogging","travel and events","social"]
    var interestSelectionArray = [NSString]()
    var model = VideoModel()
    var switchArray: [Int] = []
    let customInteractionAnimator = CustomInteractionAnimator()
    
    @IBOutlet weak var nextButtonCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: CustomViewFlowLayout!
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        
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
        
        if interestSelectionArray.isEmpty {
            
            UIButton.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubic], animations: {
                UIButton.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                    self.nextButtonCenterXConstraint.constant += 50
                    self.view.layoutIfNeeded()
                })
                
                UIButton.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4, animations: {
                    self.nextButtonCenterXConstraint.constant -= 100
                    self.view.layoutIfNeeded()
                })
                
                UIButton.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                    self.nextButtonCenterXConstraint.constant += 50
                    self.view.layoutIfNeeded()
                })
            }, completion: nil)
            
            
            let alert = UIAlertController(title: NSLocalizedString("Please select some interests!", comment: ""), message: NSLocalizedString("Tap an image to select an interest", comment: ""), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok, got it!", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
        
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
            print(keywords as AnyObject)
            if keywords != nil {
                ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).interestSelectionArray=self.interestSelectionArray
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
        self.navigationController!.navigationBar.backgroundColor=UIColor.clear
        let gesture = UITapGestureRecognizer(target: self, action: #selector(InterestsViewController.cellTapped(_:)))
        self.collectionView.addGestureRecognizer(gesture)
        
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let customNavigationAnimator = CustomNavigationAnimator()
        
        if operation == .push {
            customNavigationAnimator.pushing = true
            customInteractionAnimator.addToViewController(viewController: toVC)
        }
        
        return customNavigationAnimator
    }
    
    private func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionAnimator.transitionInProgress ? customInteractionAnimator : nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "InterestsNavBar.png")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        navigationController?.delegate = self
        self.nextButton.alpha=0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UIDevice.current.model.contains("iPad")) {
            self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        } else {
            self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
        }
        UIButton.animate(withDuration:1) {
            self.nextButton.alpha=1
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        //cell.swich.addTarget(self, action: #selector(InterestsViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6
        return cell
    }
    
    func cellTapped(_ gesture: UITapGestureRecognizer) {
        let pointInCollectionView: CGPoint = gesture.location(in: self.collectionView)
        let selectedIndexPath: IndexPath = self.collectionView.indexPathForItem(at: pointInCollectionView)!
        let selectedCell: UICollectionViewCell = self.collectionView.cellForItem(at: selectedIndexPath)!
        (selectedCell as! InterestView).checkmark.checked = !((selectedCell as! InterestView).checkmark.checked)
        let checked = (selectedCell as! InterestView).checkmark.checked
        if checked && switchArray.contains(selectedCell.tag){
            
        } else if checked {
            switchArray.append(selectedCell.tag)
        } else if !checked && switchArray.contains(selectedCell.tag) {
            switchArray = switchArray.filter{$0 != selectedCell.tag}
        } else {
            
        }
    }
    
    /*
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
    */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        var number = CGFloat(2.0)
        if width > 561 {
            number = 3.0
        }
        return CGSize(width: ((width-(number-1)*(10))/number), height: ((width-(number-1)*(10))/number))
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with:coordinator)
        self.collectionView.reloadData()
    }
    
}
