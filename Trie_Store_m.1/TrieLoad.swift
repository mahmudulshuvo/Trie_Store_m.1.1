//
//  TrieLoad.swift
//  Tier_list_m.1
//
//  Created by SHUVO on 6/28/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import Foundation
import UIKit

class TrieLoad {
    
    var Dic: [String: Any] = [String:Any]()
    var trie:Trie = Trie()
    let arch:Archive = Archive()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(dic : Dictionary<String,Any>) {
        Dic = dic
    }
    
    func loadTrie() {
     //   print("Dic to load\(Dic)")
        var items: [Any]
        for keys in Dic.keys {
            items = Dic[keys]! as! [Any]
            for item in items
            {
                trie.addWord((item as? String)!)
            }
        }
    }
    
    func isExist(_ value: String) -> Bool {
        var items: [Any]
        var justWord:String = ""
        var fullWord:String = ""
        
        for keys in Dic.keys {
            if (keys == String(value[value.characters.index(value.startIndex, offsetBy: 0)])) {
                items = Dic[keys]! as! [Any]
                for item in items
                {
                    fullWord = (item as? String)!
                    var fullWordArr = fullWord.characters.split{$0 == " "}.map(String.init)
                    justWord = fullWordArr[0]
                    
                    if(justWord == value)  {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func updateDic(_ value : String) -> Dictionary<String,Any> {
        
        if Dic.isEmpty {
            Dic = [String(value[value.characters.index(value.startIndex, offsetBy: 0)]) :[value]]
            return Dic
        }
            
        else {
            var exist:Bool = true
            var items: [Any]
            for keys in Dic.keys {
                if keys == String(value[value.characters.index(value.startIndex, offsetBy: 0)]) {
                    items = Dic[keys]! as! [Any]
                    items.append(value as Any)
                    Dic[keys] = items as Any?
                    return Dic
                }
                else {
                    exist = false
                }
            }
            
            if !exist {
                Dic[String(value[value.characters.index(value.startIndex, offsetBy: 0)])] = [value]
                return Dic
            }
            return [:]
            
        }
    }
    
    func updateWeightInDic(_ key : String) -> Bool {
        var items: [Any]
        var justWord:String = ""
        var weight:String = ""
        var fullWord:String = ""
        var flag:Bool = false
        
        for keys in Dic.keys {
            
            if keys == String(key[key.characters.index(key.startIndex, offsetBy: 0)]) {
                items = Dic[keys]! as! [Any]
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
                        let newItem:Any = justWord+" "+weight
                        items.remove(at: index)
                        items.append(newItem)
                        Dic[keys] = items as Any?
                     //   print("items.......................... \(items)")
                     //   arch.archive(Dic)
                        appDelegate.Dic = Dic
                        return true
                        
                    }
                    index += 1
                }
            }

        }
        return false
    }
    
    func trieLoadAddword(_ item : String){
        trie.addWord(item)
    }
    
    func trieLoadFindWord(_ key : String) -> [Item]{
        //var list: [String] = [String]()
        var newList = [Item]()
       // list = trie.findWord(key)
        newList = trie.findWord(key)
        
        if (!newList.isEmpty) {
            return newList
        }
        return []
    }
    
    func trieLoadWeighIncrease(_ key : String) -> Int {
        var  weight:Int = 0
        
        let check: Bool = updateWeightInDic(key)
        if (check) {
           weight = trie.weightIncrease(key)
        }
        return weight
    }
    
}
