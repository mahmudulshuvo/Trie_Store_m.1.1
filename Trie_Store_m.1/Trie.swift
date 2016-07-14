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
    
//        for child in current.children {
//            
//            if (child.isFinal == true) {
//                wordList.append(child.key)
//                if !child.children.isEmpty {
//                    for value in child.children {
//                        if (value.isFinal) {
//                            wordList.append(value.key)
//                        }
//                    }
//                }
//            }
//                
//                // for extended search
//            else
//            {
//              //  print("not implemented yet")
//                if !child.children.isEmpty {
//                    for value in child.children {
//                        if (value.isFinal) {
//                            wordList.append(value.key)
//                        }
//                    }
//                }
//            }
//            
//        }
        

//        while (!current.children.isEmpty)  {
//            
//            var childToUse: TrieNode!
//            var childs : [TrieNode!] =  [TrieNode!]()
//            var  x:Int = 0
//            
//            for child in current.children {
//                    childs.append(child)
//         //       print("value \(childs[0].level)")
//
//            }
//     //       x = 0
//            
//            for value in childs {
//                var temp : TrieNode!
//                temp = value
//                
//                if value.isFinal {
//                    wordList.append(value.key)
//                    print("item \(value.key) level \(value.level)")
//                }
//                
//                for child in temp.children {
//                    if (child.isFinal == true) {
//                        wordList.append(child.key)
//                        print("item \(child.key) level \(child.level)")
//                    }
//                    if !child.children.isEmpty {
//                        for item in child.children {
//                            if (item.isFinal) {
//                                wordList.append(item.key)
//                                print("item \(item.key) level \(item.level)")
//                            }
//                    }
//                    childToUse = child
//                    temp = childToUse
//                    }
//                }
//                x = 1
//                
//            }
//            
//            if  x == 1 {
//                break
//            }
//        }

        
        //Iterating trie
        
        var currentChild : [TrieNode!] =  [TrieNode!]()
        
        for  child in current.children {
            currentChild.append(child)
        }
        
        while (!currentChild.isEmpty) {
            var tempCurrent : [TrieNode!] = [TrieNode!]()
         //   var  check:Int = 0
            let existingLevel:Int = currentChild[0].level
            
            for item in currentChild {
                if (item.isFinal) {
                    wordList.append(item.key)
                }
                if (!item.children.isEmpty) {
                    print("1")
                    for values in item.children {
                        tempCurrent.append(values)
                    }
                }
            }
            currentChild = [TrieNode!]()
            
            if (!tempCurrent.isEmpty) {
                if (existingLevel < tempCurrent[0].level) {
                    currentChild = tempCurrent
                }
            }
            
//            for temp in tempCurrent {
//                if (existingLevel < temp.level) {
//                    check = 1
//                    break
//                }
//            }
//            if (check == 1) {
//                currentChild = tempCurrent
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