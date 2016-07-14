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
    var Dic: [String: AnyObject] = [String:AnyObject]()
    var trieLoad:TrieLoad = TrieLoad(dic: [:])
    
    
    let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myTableView.hidden = true;
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
        if launchedBefore  {
            print("Not first launch.")
            Dic = arch.unarchive()
            trieLoad = TrieLoad(dic: Dic)
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
            Dic = trieLoad.updateDic(inputField.text!)
            if !Dic.isEmpty {
                trieLoad.trieLoadAddword(inputField.text!)
                inputField.text = ""
                arch.archive(Dic)
            }
        }
        else{
            print("already exist")
            inputField.text = ""
        }
        
    }
    
    @IBAction func findAction(sender: AnyObject) {
        

        if !(findField.text!.isEmpty) {
            if trieLoad.trieLoadFindWord(findField.text!) != nil {
                itemArray = trieLoad.trieLoadFindWord(findField.text!)
                findField.text = ""
                updateTable()
                myTableView.hidden = false
            }
            else {
                findField.text = ""
                itemArray = [String]()
                updateTable()
            }
        }
    }
    
    
    @IBAction func itemAction(sender: AnyObject) {
        
        if itemArray.count > 0 {
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
        print(itemArray[indexPath.row])
        myCell.textLabel?.text = itemArray[indexPath.row];
        myCell.imageView?.image = UIImage(named: itemArray[indexPath.row]);
        
        return myCell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell:UITableViewCell = myTableView.cellForRowAtIndexPath(indexPath)!
        self.itemBtn.setTitle(cell.textLabel?.text, forState: UIControlState.Normal)
        myTableView.hidden = true
        trieLoad.trieLoadWeighIncrease((cell.textLabel?.text)!)
    }
    
    func updateTable() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.myTableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

