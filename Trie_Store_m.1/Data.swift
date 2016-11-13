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
    var value: Any = []
    
    init(dictionary: [String : Any]) {
        
        key = Array(dictionary.keys)
        value = Array(dictionary.values) as Any
    }
    
    func encode(with archiver: NSCoder) {
        archiver.encode(key, forKey: Keys.Key)
        archiver.encode(value, forKey: Keys.Value)
    }
    
    required init(coder unarchiver: NSCoder) {
        
        if let keyList = unarchiver.decodeObject(forKey: Keys.Key) as? [String] {
            key = keyList
        }
        if let wordList = unarchiver.decodeObject(forKey: Keys.Value) as? [Any] {
            value = wordList as Any
        }
        super.init()
    }
}
