//
//  Data.swift
//  Tier_list_m.1
//
//  Created by SHUVO on 6/28/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import Foundation

class Data : NSObject, NSCoding {
    
    struct Keys {
        static let Key = "key"
        static let Value = "values"
    }
    
    var key: [String] = []
    var value: AnyObject = []
    
    init(dictionary: [String : AnyObject]) {
        
        key = Array(dictionary.keys)
        value = Array(dictionary.values)
    }
    
    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(key, forKey: Keys.Key)
        archiver.encodeObject(value, forKey: Keys.Value)
    }
    
    required init(coder unarchiver: NSCoder) {
        
        if let keyList = unarchiver.decodeObjectForKey(Keys.Key) as? [String] {
            key = keyList
        }
        if let wordList = unarchiver.decodeObjectForKey(Keys.Value) as? [AnyObject] {
            value = wordList
        }
        super.init()
    }
}