//
//  Archive.swift
//  Tier_list_m.1
//
//  Created by SHUVO on 6/28/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import Foundation

class Archive {
    
    var counter:Int = 0
    var Dic: [String: AnyObject] = [String:AnyObject]()
    
    
    func archive(Dic: Dictionary<String,AnyObject>) {
        let personObj = Data(dictionary: Dic)
        NSKeyedArchiver.archiveRootObject(personObj, toFile: path())
    }
    
    func unarchive() -> Dictionary<String,AnyObject>  {
        
        counter = 0
        let responseObject = NSKeyedUnarchiver.unarchiveObjectWithFile(path()) as? Data
        if responseObject != nil {
            let keyArr = responseObject!.key
            let valueArr = responseObject!.value
            var Dict: Dictionary<String, AnyObject> = [:]
            for keys in keyArr
            {
                if (counter <= valueArr.count-1 ) {
                    Dict[keys] =  valueArr[counter]
                    counter += 1
                }
            }
            counter = 0
          //  print("My Dictionary\(Dict)")
            Dic = Dict
            return Dic
        }
        return [:]
    }
    
    
    func path() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        let path = documentsPath?.stringByAppendingString("/Data")
        return path!
    }
}