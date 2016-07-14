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
    var words: Array<String> = Array<String>()
    
    func addWord(keyword: String)
    {
        guard keyword.length > 0 else {
            return
        }
        
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
            print("end of word reached!")
            return
        }
    }
    
    func findWord(keyword: String) -> Array<String>! {
        
        guard keyword.length > 0 else {
            return nil
        }
        
        var current: TrieNode = root
        var wordList: Array<String> = Array<String>()
        
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
                return nil
            }
        }
        
        if ((current.key == keyword) && (current.isFinal)) {
            wordList.append(current.key)
        }

        
        //Iterating trie
        
        var currentChild : [TrieNode!] =  [TrieNode!]()
        
        for  child in current.children {
            currentChild.append(child)
        }
        
        while (!currentChild.isEmpty) {
            var tempCurrent : [TrieNode!] = [TrieNode!]()
         //   let existingLevel:Int = currentChild[0].level
            
            for item in currentChild {
                if (item.isFinal) {
                    wordList.append(item.key)
                }
                if (!item.children.isEmpty) {
                    for values in item.children {
                        tempCurrent.append(values)
                    }
                }
            }
            currentChild = [TrieNode!]()
            currentChild = tempCurrent
            
//            if (!tempCurrent.isEmpty) {
//                if (existingLevel < tempCurrent[0].level) {
//                    currentChild = tempCurrent
//                }
//            }
        }
        
        return wordList
    }
    
    
    func weightIncrease(keyword: String) {
        
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
                return
            }
        }
        if ((current.key == keyword) && (current.isFinal)) {
            current.weight += 1
        }
        
        print("child \(current.key) weight \(current.weight)")
    }
}




//extend the native String class
extension String {
    //compute the length
    var length: Int { return self.characters.count }
    //returns characters up to a specified index
    func substringToIndex(to: Int) -> String {
        return self.substringToIndex(self.startIndex.advancedBy(to))
    }
}