//
//  ViewController.swift
//  Trie_Store_m.1
//
//  Created by SHUVO on 7/13/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var findField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var itemBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    let arch:Archive = Archive()
    var itemArray = [String]()
    var wordList = [String]()
 //   var Dic: [String: AnyObject] = [String:AnyObject]()
    var trieLoad:TrieLoad = TrieLoad(dic: [:])
    var highestWeight:Int = 0
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myTableView.hidden = true;
        myTableView.dataSource = self
        myTableView.delegate = self
        findField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        if launchedBefore  {
            print("Not first launch.")
            appDelegate.Dic = arch.unarchive()
            trieLoad = TrieLoad(dic: appDelegate.Dic)
            trieLoad.loadTrie()
        }
        else {
            print("First launch, setting NSUserDefault.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
        }
    }
    
    

    
    //For Button Actions
    
    @IBAction func insertAction(sender: AnyObject) {
        
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
    

    func textFieldDidChange(textField: UITextField) {

        self.itemBtn.setTitle("Items", forState: UIControlState.Normal)
        
        if !(findField.text!.isEmpty) {
            wordList = trieLoad.trieLoadFindWord(findField.text!)
            if  (!wordList.isEmpty) {
                wordList = sortList(wordList)
                justItems(wordList)
                updateTable()
                myTableView.hidden = false
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
    
    
    func sortList(wordList: [String]) -> [String] {
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
        var takeWeight = wordArray[0].characters.split{$0 == " "}.map(String.init)
        self.highestWeight = Int(takeWeight[1])!
        return wordArray
    }
    
    
    func justItems(wordList: [String])  {
        
        itemArray = [String]()
        for items in wordList {
            var fullWordArr = items.characters.split{$0 == " "}.map(String.init)
            itemArray.append(fullWordArr[0])
        }
    }
    
    
    @IBAction func itemAction(sender: AnyObject) {
        
        if itemArray.count > 0 {
            
            if (self.highestWeight < Int(countLabel.text!)) {
                wordList = trieLoad.trieLoadFindWord(findField.text!)
                wordList = sortList(wordList)
                justItems(wordList)
                updateTable()
                self.highestWeight = Int(countLabel.text!)!
            }

            if myTableView.hidden == true {
                myTableView.hidden = false
            }
            else
            {
                myTableView.hidden = true
            }
        }
    }
    
    
    //For table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell:UITableViewCell = myTableView.dequeueReusableCellWithIdentifier("prototype", forIndexPath: indexPath)
       // print(itemArray[indexPath.row])
        myCell.textLabel?.text = itemArray[indexPath.row];
        myCell.imageView?.image = UIImage(named: itemArray[indexPath.row]);
        
        return myCell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell:UITableViewCell = myTableView.cellForRowAtIndexPath(indexPath)!
        self.itemBtn.setTitle(cell.textLabel?.text, forState: UIControlState.Normal)
        myTableView.hidden = true
        countLabel.text = String(trieLoad.trieLoadWeighIncrease((cell.textLabel?.text)!))

        
    }
    
    func updateTable() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.myTableView.reloadData()
            if (self.itemArray.isEmpty) {
                self.myTableView.hidden = true
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


