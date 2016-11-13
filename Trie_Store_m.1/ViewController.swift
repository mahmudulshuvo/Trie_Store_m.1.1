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
    var itemArray = [String]()
    var wordList = [String]()
 //   var Dic: [String: Any] = [String:Any]()
    var trieLoad:TrieLoad = TrieLoad(dic: [:])
    var highestWeight:Int = 0
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
        view.addGestureRecognizer(tap)
        
        
        if launchedBefore  {
            print("Not first launch.")
            appDelegate.Dic = arch.unarchive()
            trieLoad = TrieLoad(dic: appDelegate.Dic)
            trieLoad.loadTrie()
        }
        else {
            print("First launch, setting NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let words = readFile()
            print("Read \(words.count) words from file: \(words)")
            
            let captureStart = (Date().timeIntervalSince1970) * 1000
            // do something
            for word in words {
                trieLoad.trieLoadAddword(word+" "+"0")
            }
            //
            let captureEnd = (Date().timeIntervalSince1970) * 1000
            let executionTime = captureEnd - captureStart
            print("execution time :\(executionTime)")
            updateMainDic(wordArray: words)
        }
    }

    
    //For Performance Check
    func readFile() -> Array<String> {
        
        do {
            let pathNew = Bundle.main.path(forResource: "Paragraph", ofType: "txt")
            let contests:NSString = try NSString(contentsOfFile: pathNew!, encoding: String.Encoding.ascii.rawValue)
            let trimmed:String = contests.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let words:Array<String> =  NSString(string: trimmed).components(separatedBy: .whitespacesAndNewlines)
            return words
        } catch {
            print("Unable to read file");
            return [String]()
        }
    }
    
    
    //Update Dictionary 
    func updateMainDic(wordArray : Array<String> ) {
        for words in wordArray {
            appDelegate.Dic = trieLoad.updateDic(words+" "+"0")
        }
    }
    
    //For Button Actions
    @IBAction func insertAction(_ sender: Any) {
        
        if !trieLoad.isExist(inputField.text!) {
            appDelegate.Dic = trieLoad.updateDic(inputField.text!+" "+"0")
            if !appDelegate.Dic.isEmpty {
                trieLoad.trieLoadAddword(inputField.text!+" "+"0")
                inputField.text = ""
               // arch.archive(appDelegate.Dic)
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
                wordList = sortList(wordList)
                justItems(wordList)
                updateTable()
                myTableView.isHidden = false
            }
                
            else {
                itemArray = [String]()
                updateTable()
            }
        }
        else {
            itemArray = [String]()
            updateTable()
        }
    }
    
    
    func sortList(_ wordList: [String]) -> [String] {
        var temp:String = ""
        var wordArray = [String]()
        wordArray = wordList
        
        for _ in 0 ..< wordArray.count {
            for j in 0 ..< wordArray.count-1 {
                var prev = wordArray[j].characters.split{$0 == " "}.map(String.init)
                var next = wordArray[j+1].characters.split{$0 == " "}.map(String.init)
                if (Int(next[1]) > Int(prev[1])) {
                    temp = wordArray[j]
                    wordArray[j] = wordArray[j+1]
                    wordArray[j+1] = temp
                }
            }
        }
//        var takeWeight = wordArray[0].characters.split{$0 == " "}.map(String.init)
//        self.highestWeight = Int(takeWeight[1])!
        return wordArray
    }
    
    
    func justItems(_ wordList: [String])  {
        
        itemArray = [String]()
        for items in wordList {
            var fullWordArr = items.characters.split{$0 == " "}.map(String.init)
            itemArray.append(fullWordArr[0])
        }
    }
    
    
    @IBAction func itemAction(_ sender: Any) {
        
        if itemArray.count > 0 {
            
            if (self.highestWeight < Int(countLabel.text!)) {
                wordList = trieLoad.trieLoadFindWord(findField.text!)
                wordList = sortList(wordList)
                justItems(wordList)
                updateTable()
                self.highestWeight = Int(countLabel.text!)!
            }

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
        return itemArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell:UITableViewCell = myTableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath)
       // print(itemArray[indexPath.row])
        myCell.textLabel?.text = itemArray[indexPath.row];
        myCell.imageView?.image = UIImage(named: itemArray[indexPath.row]);
        
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
            if (self.itemArray.isEmpty) {
                self.myTableView.isHidden = true
            }
        })
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


