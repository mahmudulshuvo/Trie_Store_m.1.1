//
//  TierNode.swift
//  Tier_list_m.1
//
//  Created by SHUVO on 6/21/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import UIKit

class TrieNode {
    var key: String!
    var children: Array<TrieNode>
    var isFinal: Bool
    var level: Int
    var weight: Int
    init() {
        self.children = Array<TrieNode>()
        self.isFinal = false
        self.level = 0
        self.weight = 0
    }
}