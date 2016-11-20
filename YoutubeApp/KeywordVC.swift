//
//  KeywordVC.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 30/07/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Foundation
import PEGKit

class KeywordVC: UIViewController, UITextViewDelegate {
    
    var interestSelectionArray = [NSString]()
    var skillSelectionArray = [NSString]()
    var keywords = [NSString]()
    var model = VideoModel()
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func nextButtonClicked(_ sender: UIBarButtonItem) {
        
        let start =  textView.text.startIndex
        let end = textView.text.endIndex
        print(start)
        print(end)
        textView.text=textView.text.lowercased()
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 ")
        keywords=((textView.text).components(separatedBy: characterset.inverted) as [NSString])
        print(keywords)
        /*
        let t : PKTokenizer = PKTokenizer(string: textView.text)
        let eof : PKToken = PKToken.eof()
        var tok : PKToken? = nil
        while (eof != (tok = (t.nextToken()))) {
            if (tok?.isQuotedString)! || (tok?.isWord)! || (tok?.isNumber)! || (tok?.isDelimitedString)! {
                keywords.append((tok?.stringValue)!)
            }
        }
         */
        /*
        var range: Range<String.Index> = Range<String.Index>(start..<end)
        while range.lowerBound != end {
            keywords.append(textView.text.collectWord(&range))
            while textView.text.skipWhitespace(&range) {
            }
        }
        */
        
        if keywords.isEmpty {
            let alert = UIAlertController(title: NSLocalizedString("Please enter some keywords!", comment: ""), message: NSLocalizedString("Type some words in the space below, and separate search terms with special characters!", comment: ""), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok, got it!", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tbc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).model.service=self.model.service
        let userDefaults=UserDefaults.standard
        if userDefaults.object(forKey: "SelectedVideos") as? Data == nil {
            VideoStatus.selectedVideos=[]
            (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).videos=VideoStatus.selectedVideos
            
        }
        userDefaults.set(keywords as [NSString], forKey: "KeywordsArray")
        if self.interestSelectionArray != [] {
            userDefaults.set(self.interestSelectionArray as [NSString], forKey: "InterestsArray")
        }
        if self.skillSelectionArray != [] {
            userDefaults.set(self.skillSelectionArray as [NSString], forKey: "SkillsArray")
        }
        ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).interestSelectionArray=self.interestSelectionArray+keywords
        ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).skillSelectionArray=self.skillSelectionArray
        ((tbc.viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController).model=self.model
        self.present(tbc, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(interestSelectionArray)
        print(skillSelectionArray)
        let userDefaults=UserDefaults.standard
        if userDefaults.object(forKey: "SkillsArray") as? [NSString] != nil {
            self.navigationItem.hidesBackButton=true
        }
        textView.text = NSLocalizedString("Please enter some keywords!", comment: "")
        textView.textColor = UIColor.lightGray
        textView.delegate=self
        
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.tintColor=UIColor.white
        navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName : UIColor.white]
        navigationController!.navigationBar.isOpaque=true
        self.navigationController!.navigationBar.barStyle = .black
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "SkillsArray") as? [NSString] != nil {
            self.navigationItem.hidesBackButton=true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: NSLocalizedString("Keyword Entry", comment: ""), message: NSLocalizedString("Please enter some keywords which relate to your interests and skills. Please separate phrases or individual keywords by a comma or any other special character!", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Got it!", comment: ""), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Please enter some keywords!", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
    
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

/*
public extension Character {
    /// Determine if the character is a space, tab or newline
    public func isSpace() -> Bool {
        return self == " " || self == "\t" || self == "\n" || self == "\r"
    }
    
    /// Conver the character to a UTF16 code unit
    public var utf16: UInt16 {
        get {
            let s = String(self).utf16
            return s[s.startIndex]
        }
    }
    
    /// Convert the character to lowercase
    public var lowercaseCharacter: Character {
        get {
            let s = String(self).lowercased()
            return s[s.startIndex]
        }
    }
    
    /// Convert the character to uppercase
    public var uppercaseCharacter: Character {
        get {
            let s = String(self).uppercased()
            return s[s.startIndex]
        }
    }
    
    /// If the character is a decimal digit return its integer value, otherwise return nil
    internal func decimalDigitValue() -> Int? {
        let zero = 0x30
        let nine = 0x39
        
        let value = Int(self.utf16)
        switch (value) {
        case zero...nine:
            return value - zero
        default:
            return nil
        }
    }
    
    /// If the character is a hexadecimal digit return its integer value, otherwise return nil
    internal func hexadecimalDigitValue() -> Int? {
        let zero = 0x30
        let nine = 0x39
        let lowerA = 0x61
        let lowerF = 0x66
        let upperA = 0x41
        let upperF = 0x46
        
        let value = Int(self.utf16)
        switch (value) {
        case zero...nine:
            return value - zero
        case lowerA...lowerF:
            return value - lowerA + 10
        case upperA...upperF:
            return value - upperA + 10
        default:
            return nil
        }
    }
}

public extension String {
    /**
     Skip whitespace characters. Updates the range and returns true is characters were skipped.
     */
    public func skipWhitespace( range: inout Range<Index>) -> Bool {
        var skipped = false
        while range.lowerBound != range.upperBound {
            if !self[range.lowerBound].isSpace() {
                return skipped
            }
            
            skipped = true
            range.startIndex = range.startIndex.successor()
            range=range.lowerBound.index(range, offset: 1)..<range.upperBound
            range.clamped(to: Range<Index>(uncheckedBounds: range.lowerBound.advancedBy(1), range.upperBound))
            range=Range<String.Index>.init(uncheckedBounds: range.lowerBound, range.upperBound)
        }
        return skipped
    }
    
    /**
     Skip a particular character. Updates the range and returns true if the character was found.
     */
    public func skipCharacter( range: inout Range<Index>, skip: Character) -> Bool {
        if range.startIndex != range.endIndex && self[range.startIndex] == skip {
            range.startIndex = range.startIndex.successor()
            return true
        }
        return false
    }
    
    /**
     Skip a particular string. Updates the range and returns true if the string was found.
     */
    public func skipString(inout range: Range<Index>, skip: String) -> Bool {
        let originalRange = range
        
        var skipIndex = skip.startIndex
        while range.startIndex != range.endIndex && skipIndex != skip.endIndex {
            if self[range.startIndex] != skip[skipIndex] {
                range = originalRange
                return false
            }
            range.startIndex = range.startIndex.successor()
            skipIndex = skipIndex.successor()
        }
        
        return true
    }
    
    /**
     Skip a particular string ignoring case. Updates the range and returns true if the string was found.
     */
    public func skipCaseInsensitiveString(inout range: Range<Index>, skip: String) -> Bool {
        let originalRange = range
        
        var skipIndex = skip.startIndex
        while range.startIndex != range.endIndex && skipIndex != skip.endIndex {
            if self[range.startIndex].lowercaseCharacter != skip[skipIndex].lowercaseCharacter {
                range = originalRange
                return false
            }
            range.startIndex = range.startIndex.successor()
            skipIndex = skipIndex.successor()
        }
        
        return true
    }
}

public extension String {
    /**
     Collect characters into a string until a whitespace character is found.
     */
    public func collectWord() -> String {
        var range = startIndex..<endIndex
        return collectWord(&range)
    }
    
    /**
     Collect characters into a string until a whitespace character is found. Updates the range and returns the
     collected string.
     */
    public func collectWord(inout range: Range<Index>) -> String {
        var word = String()
        while range.startIndex != range.endIndex && !self[range.startIndex].isSpace() {
            word.append(self[range.startIndex])
            range.startIndex = range.startIndex.successor()
        }
        
        return word
    }
    
    /**
     Collect characters into a string until a stop character is found or the end of the string is reached.
     */
    public func collect(#stop: Character) -> String {
        var range = startIndex..<endIndex
        return collect(&range, stop: stop)
    }
    
    /**
     Collect characters into a string until a stop character is found or the end of the range is reached. Updates the
     range and returns the collected string.
     */
    public func collect(inout range: Range<Index>, stop: Character) -> String {
        var word = String()
        while range.startIndex != range.endIndex && self[range.startIndex] != stop {
            word.append(self[range.startIndex])
            range.startIndex = range.startIndex.successor()
        }
        
        return word
    }
    
    /**
     Collect characters into a string until an of the stop characters is found.
     */
    public func collect(#stop: [Character]) -> String {
        var range = startIndex..<endIndex
        return collect(&range, stop: stop)
    }
    
    /**
     Collect characters into a string until any of the stop characters is found. Updates the range and returns the
     collected string.
     */
    public func collect(inout range: Range<Index>, stop: [Character]) -> String {
        var word = String()
        while range.startIndex != range.endIndex && !contains(stop, self[range.startIndex]) {
            word.append(self[range.startIndex])
            range.startIndex = range.startIndex.successor()
        }
        
        return word
    }
}

public extension String {
    /// Parse an integer value
    public func parseInteger() -> Int? {
        var range = startIndex..<endIndex
        return parseInteger(&range)
    }
    
    /**
     Parse an integer value. Return the index of the first character that is not part of the integer or `end`, and the
     parsed value.
     */
    public func parseInteger(inout range: Range<Index>) -> Int? {
        let originalRange = range
        
        let sign = parseSign(&range)
        let result = parseDigits(&range)
        if let result = result {
            return sign * result
        }
        
        range = originalRange
        return nil
    }
    
    internal func parseSign(inout range: Range<Index>) -> Int {
        if skipCharacter(&range, skip: "-") {
            return -1;
        }
        
        skipCharacter(&range, skip: "+")
        return 1;
    }
    
    internal func parseDigits(inout range: Range<Index>) -> Int? {
        var result: Int?
        while range.startIndex != range.endIndex {
            if let value = self[range.startIndex].decimalDigitValue() {
                if result == nil {
                    result = value
                } else {
                    result = result! * 10 + value
                }
                range.startIndex = range.startIndex.successor()
            } else {
                break
            }
        }
        
        return result
    }
    
    
    /// Parse an hexadecimal integer value.
    public func parseHexadecimalInteger() -> Int? {
        var range = startIndex..<endIndex
        return parseHexadecimalInteger(&range)
    }
    
    /**
     Parse an hexadecimal integer value. Return the index of the first character that is not part of the integer or
     `end`, and the parsed value.
     
     :start: The start index.
     :end:   The end index.
     */
    public func parseHexadecimalInteger(inout range: Range<Index>) -> Int? {
        var sign = parseSign(&range)
        var result = parseHexadecimalDigits(&range)
        if let result = result {
            return sign * result;
        }
        return nil
    }
    
    internal func parseHexadecimalDigits(inout range: Range<Index>) -> Int? {
        var result: Int?
        while range.startIndex != range.endIndex {
            if let value = self[range.startIndex].hexadecimalDigitValue() {
                if result == nil {
                    result = value
                } else {
                    result = result! * 16 + value
                }
                range.startIndex = range.startIndex.successor()
            } else {
                break
            }
        }
        
        return result
    }
    
    
    /// Parse a floating point value
    public func parseFloat() -> Double? {
        var range = startIndex..<endIndex
        return parseFloat(&range)
    }
    
    /**
     Parse a floating point value. Return the index of the first character that is not part of the floating point
     number or `end`, and the parsed value.
     
     :start: The start index.
     :end:   The end index.
     */
    public func parseFloat(inout range: Range<Index>) -> Double? {
        var sign = parseSign(&range)
        
        let integerPart = parseDigits(&range)
        let hasDecimalPoint = skipCharacter(&range, skip :".")
        
        var decimalPart: Double?
        if hasDecimalPoint {
            decimalPart = parseDecimalDigits(&range)
        }
        
        if integerPart == nil && (!hasDecimalPoint || decimalPart == nil) {
            return nil
        }
        
        var exponent: Int?
        if (skipCharacter(&range, skip :"e") || skipCharacter(&range, skip :"E")) {
            exponent = parseInteger(&range)
            if exponent == nil {
                return nil
            }
        }
        
        var result = 0.0
        if let v = integerPart {
            result += Double(v)
        }
        if let v = decimalPart {
            result += v
        }
        result *= Double(sign)
        if let v = exponent {
            result *= pow(10.0, Double(v))
        }
        
        return result
    }
    
    internal func parseDecimalDigits(inout range: Range<Index>) -> Double? {
        var denominator = 1.0 / 10.0
        var result: Double?
        while range.startIndex != range.endIndex {
            if let value = self[range.startIndex].decimalDigitValue() {
                if result == nil {
                    result = Double(value) * denominator
                } else {
                    result = result! + Double(value) * denominator
                }
                denominator /= 10.0
                range.startIndex = range.startIndex.successor()
            } else {
                break
            }
        }
        
        return result
    }
}
*/
