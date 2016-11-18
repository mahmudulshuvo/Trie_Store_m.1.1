//
//  ViewController.swift
//  Trie_Store_m.1
//
//  Created by SHUVO on 7/13/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import UIKit
import Foundation

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var findField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var itemBtn: UIButton! 
    @IBOutlet weak var countLabel: UILabel!
    
    let arch:Archive = Archive()
    var wordList = [Item]()
    var itemArr = [Item]()
    var trieLoad:TrieLoad = TrieLoad(dic: [:])
    var highestWeight:Int? = 0
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myTableView.isHidden = true;
        myTableView.dataSource = self
        myTableView.delegate = self
        findField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        if launchedBefore  {
            print("Not first launch.")
            let captureStart = (Date().timeIntervalSince1970) * 1000
            appDelegate.Dic = arch.unarchive()
            trieLoad = TrieLoad(dic: appDelegate.Dic)
            trieLoad.loadTrie()
            let captureEnd = (Date().timeIntervalSince1970) * 1000
            let executionTime = captureEnd - captureStart
            print("execution time for not first launch :\(executionTime)")
        }
            
        else {
            print("First launch, setting NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let captureStart = (Date().timeIntervalSince1970) * 1000
            let words = readFile()
            for word in words {
                trieLoad.trieLoadAddword(word+" "+"0")
            }
            let captureEnd = (Date().timeIntervalSince1970) * 1000
            let executionTime = captureEnd - captureStart
            print("execution time for the first launch :\(executionTime)")
            updateMainDic(wordArray: words)
            totalWords()
        }
        
    }

    //Update Dictionary 
    func updateMainDic(wordArray : Array<String> ) {
        for words in wordArray {
            appDelegate.Dic = trieLoad.updateDic(words+" "+"0")
        }
    }
    
    //For Item Button Actions
    @IBAction func insertAction(_ sender: Any) {
        
        if !trieLoad.isExist(inputField.text!) {
            appDelegate.Dic = trieLoad.updateDic(inputField.text!+" "+"0")
            if !appDelegate.Dic.isEmpty {
                trieLoad.trieLoadAddword(inputField.text!+" "+"0")
                inputField.text = ""
            }
        }
        else{
            print("already exist")
            inputField.text = ""
        }
        
    }
    

    func textFieldDidChange(_ textField: UITextField) {

        self.itemBtn.setTitle("Items", for: UIControlState())
        if !(findField.text!.isEmpty) {
            wordList = trieLoad.trieLoadFindWord(findField.text!)
            if  (!wordList.isEmpty) {
                itemArr = sortList(items: wordList)
                updateTable()
                myTableView.isHidden = false
            }
                
            else {
                itemArr = [Item]()
                updateTable()
            }
        }
        else {
            itemArr = [Item]()
            updateTable()
        }
    }
    
    func sortList(items : [Item]) -> [Item] {
        
        let captureStart = (Date().timeIntervalSince1970) * 1000
        var sortedArray = [Item]()
        sortedArray = items.sorted{$0.weight > $1.weight}
        let captureEnd = (Date().timeIntervalSince1970) * 1000
        let executionTime = captureEnd - captureStart
        print("Total words :\(sortedArray.count) and execution time for sorting :\(executionTime)")
        return sortedArray
    }
    
    
    @IBAction func itemAction(_ sender: Any) {
        
        if itemArr.count > 0 {
            wordList =  trieLoad.trieLoadFindWord(findField.text!)
            itemArr = sortList(items: wordList)
            updateTable()
            self.highestWeight = Int(countLabel.text!)!

            if myTableView.isHidden == true {
                myTableView.isHidden = false
            }
                
            else
            {
                myTableView.isHidden = true
            }
        }
    }
    
    
    //For table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell:UITableViewCell = myTableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath)
        myCell.textLabel?.text = itemArr[indexPath.row].value
        return myCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell:UITableViewCell = myTableView.cellForRow(at: indexPath)!
        self.itemBtn.setTitle(cell.textLabel?.text, for: UIControlState())
        myTableView.isHidden = true
        countLabel.text = String(trieLoad.trieLoadWeighIncrease((cell.textLabel?.text)!))
    }
    
    func updateTable() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.myTableView.reloadData()
            if (self.itemArr.isEmpty) {
                print("array is empty")
                self.myTableView.isHidden = true
            }
        })
    }
    
    
    //Word count
    func totalWords() {
        var counter:Int = 0
        
        for (_, values) in appDelegate.Dic {
            for _ in values as! [String] {
                counter += 1
            }
        }
        
        print("Total Words: \(counter)")
    }
    
    //Read words from file
    func readFile() -> Array<String> {
        
        do {
            let pathNew = Bundle.main.path(forResource: "WordFile", ofType: "txt")
            let contests:NSString = try NSString(contentsOfFile: pathNew!, encoding: String.Encoding.ascii.rawValue)
            let trimmed:String = contests.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let words:Array<String> =  NSString(string: trimmed).components(separatedBy: .whitespacesAndNewlines)
            return words
        } catch {
            print("Unable to read file");
            return [String]()
        }
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


