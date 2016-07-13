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
    
    init(dic : Dictionary<String,AnyObject>) {
        Dic = dic
    }
    
    func loadTrie() {
        print("Dic to load\(Dic)")
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
        for keys in Dic.keys {
            items = Dic[keys]! as! [AnyObject]
            for item in items
            {
                if(item as? String)! == value  {
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
    
    func trieLoadWeighIncrease(key : String) {
        trie.weightIncrease(key)
    }
    
}