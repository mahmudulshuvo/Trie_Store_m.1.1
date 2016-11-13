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
    var Dic: [String: Any] = [String:Any]()
    
    
    func archive(_ Dic: Dictionary<String,Any>) {
        let personObj = Data(dictionary: Dic)
        NSKeyedArchiver.archiveRootObject(personObj, toFile: path())
    }
    
    func unarchive() -> Dictionary<String,Any>  {
        
        counter = 0
        let responseObject = NSKeyedUnarchiver.unarchiveObject(withFile: path()) as? Data
        if responseObject != nil {
            let keyArr = responseObject!.key
            let valueArr:Any = responseObject!.value
            var Dict: Dictionary<String, Any> = [:]
            for keys in keyArr
            {
                if (counter <= (valueArr as AnyObject).count-1 ) {
                    Dict[keys] =  (valueArr as AnyObject)[counter]
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
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = (documentsPath)! + "/Data"
        return path
    }
}
