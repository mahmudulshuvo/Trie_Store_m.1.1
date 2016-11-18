//
//  Tier.swift
//  Tier_list_m.1
//
//  Created by SHUVO on 6/21/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import UIKit

class Trie {
    
    var root:TrieNode = TrieNode()
    
    func addWord(_ item: String)
    {
        guard item.length > 0 else {
            return
        }
        
        var keyword:String = ""
        var weight:String = ""
//        keyword = item
//        weight = value
        
        var fullWordArr = item.characters.split{$0 == " "}.map(String.init)
        keyword = fullWordArr[0]
        weight = fullWordArr[1]
        
        var current: TrieNode = root
        while (keyword.characters.count != current.level) {
            var childToUse: TrieNode!
            let searchKey: String = keyword.substringToIndex(current.level + 1)
            for child in current.children {
                if (child.key == searchKey) {
                    childToUse = child
                    break
                }
            }
            if (childToUse == nil) {
                childToUse = TrieNode()
                childToUse.key = searchKey
                childToUse.level = current.level + 1
                childToUse.weight = 0
                current.children.append(childToUse)
            }
            current = childToUse
        }
        if (keyword.characters.count == current.level) {
            current.isFinal = true
            current.weight = Int(weight)!
         //   print("end of word reached!")
            return
        }
    }
    
    func findWord(_ keyword: String) -> [Item] {
        
        guard keyword.length > 0 else {
            return []
        }
        
        var current: TrieNode = root
       // var wordList: [String] = [String]()
        var newWordList = [Item]()
        
        while (keyword.length != current.level) {
            var childToUse: TrieNode!
            let searchKey: String = keyword.substringToIndex(current.level + 1)
            for child in current.children {
                if (child.key == searchKey) {
                    childToUse = child
                    current = childToUse
                    break
                }
            }
            
            if childToUse == nil {
                return []
            }
        }
        
        if ((current.key == keyword) && (current.isFinal)) {
        //    wordList.append(current.key+" "+String(current.weight))
            newWordList.append(Item(value:current.key, weight:current.weight))
        }

        
        //Iterating trie
        
        var currentChild : [TrieNode?] =  [TrieNode!]()
      //  var wordTrieArr:[TrieNode] = []
        
        for  child in current.children {
            currentChild.append(child)
        }
        
        while (!currentChild.isEmpty) {
            var tempCurrent : [TrieNode?] = [TrieNode!]()
            
            for item in currentChild {
                if (item?.isFinal)! {
                 //   wordList.append((item?.key)!+" "+String(describing: item?.weight))
                    newWordList.append(Item(value:(item?.key)!, weight:(item?.weight)!))
                  //  wordTrieArr.append(item!)
                }
                if (!(item?.children.isEmpty)!) {
                    for values in (item?.children)! {
                        tempCurrent.append(values)
                    }
                }
            }
            currentChild = [TrieNode!]()
            currentChild = tempCurrent
        }
        
        //return wordList
        return newWordList
      //  return wordTrieArr
    }
    
    
    func weightIncrease(_ keyword: String) -> Int {
        
        var current: TrieNode = root
        
        while (keyword.length != current.level) {
            var childToUse: TrieNode!
            let searchKey: String = keyword.substringToIndex(current.level + 1)
            for child in current.children {
                if (child.key == searchKey) {
                    childToUse = child
                    current = childToUse
                    break
                }
            }
            if childToUse == nil {
                return 0
            }
        }
        if ((current.key == keyword) && (current.isFinal)) {
            current.weight += 1
        }
        return current.weight
       // print("child \(current.key) weight \(current.weight)")
    }
    
}



//extend the native String class
extension String {
    //compute the length
    var length: Int { return self.characters.count }
    //returns characters up to a specified index
    func substringToIndex(_ to: Int) -> String {
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: to))
    }
}
