//
//  TrieLoad.swift
//  Tier_list_m.1
//
//  Created by SHUVO on 6/28/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import Foundation

class TrieLoad {
    
    var Dic: [String: AnyObject] = [String:AnyObject]()
    var trie:Trie = Trie()
    let arch:Archive = Archive()
    
    init(dic : Dictionary<String,AnyObject>) {
        Dic = dic
    }
    
    func loadTrie() {
     //   print("Dic to load\(Dic)")
        var items: [AnyObject]
        for keys in Dic.keys {
            items = Dic[keys]! as! [AnyObject]
            for item in items
            {
                trie.addWord((item as? String)!)
            }
        }
    }
    
    func isExist(value: String) -> Bool {
        var items: [AnyObject]
        var justWord:String = ""
       // var weight:String = ""
        var fullWord:String = ""
        
        for keys in Dic.keys {
            items = Dic[keys]! as! [AnyObject]
            for item in items
            {
                fullWord = (item as? String)!
                var fullWordArr = fullWord.characters.split{$0 == " "}.map(String.init)
                justWord = fullWordArr[0]
        //        weight = fullWordArr[1]
                
                if(justWord == value)  {
                    return true
                }
            }
        }
        return false
    }
    
    func updateDic(value : String) -> Dictionary<String,AnyObject> {
        if Dic.isEmpty {
            Dic = [String(value[value.startIndex.advancedBy(0)]) :[value]]
            return Dic
        }
            
        else {
            var exist:Bool = true
            var items: [AnyObject]
            for keys in Dic.keys {
                if keys == String(value[value.startIndex.advancedBy(0)]) {
                    items = Dic[keys]! as! [AnyObject]
                    items.append(value)
                    Dic[keys] = items
                    return Dic
                }
                else {
                    exist = false
                }
            }
            
            if !exist {
                Dic[String(value[value.startIndex.advancedBy(0)])] = [value]
                return Dic
            }
            return [:]
            
        }
    }
    
    func updateWeightInDic(key : String) -> Bool {
        var items: [AnyObject]
        var justWord:String = ""
        var weight:String = ""
        var fullWord:String = ""
        var flag:Bool = false
        
        for keys in Dic.keys {
            
            if keys == String(key[key.startIndex.advancedBy(0)]) {
                items = Dic[keys]! as! [AnyObject]
                var index:Int = 0
                
                
                for item in items {
                    fullWord = (item as? String)!
                    var fullWordArr = fullWord.characters.split{$0 == " "}.map(String.init)
                    justWord = fullWordArr[0]
                    weight = fullWordArr[1]
                    if (justWord == key && flag == false) {
                        flag = true
                        var mass:Int = Int(weight)!
                        mass += 1
                        weight = String(mass)
                        let newItem:AnyObject = justWord+" "+weight
                        items.removeAtIndex(index)
                        items.append(newItem)
                        Dic[keys] = items
                     //   print("items.......................... \(items)")
                        arch.archive(Dic)
                        return true
                        
                    }
                    index += 1
                }
            }

        }
        return false
    }
    
    func trieLoadAddword(item : String){
        trie.addWord(item)
    }
    
    func trieLoadFindWord(key : String) -> Array<String>!{
        var list: Array<String> = Array<String>()
        if trie.findWord(key) != nil {
            list = trie.findWord(key)
            return list
        }
        return []
    }
    
    func trieLoadWeighIncrease(key : String) -> Int {
        var  weight:Int = 0
        
        let check: Bool = updateWeightInDic(key)
        if (check) {
           weight = trie.weightIncrease(key)
        }
        return weight
    }
    
}