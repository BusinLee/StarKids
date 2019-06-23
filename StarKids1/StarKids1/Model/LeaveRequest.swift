//
//  LeaveRequest.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import Foundation
import UIKit
struct LeaveRequest {
    let id:String!
    let currentDay:String!
    let fromDay:String!
    let toDay:String!
    let reason:String!
    let fullName:String!
    let parent:String!
    let linkAvatar:String!
    let className:String!
    
    init() {
        id = ""
        currentDay = ""
        fromDay = ""
        toDay = ""
        reason = ""
        fullName = ""
        parent = ""
        linkAvatar = ""
        className = ""
    }
    
    init(id:String, currentDay:String, fromDay:String, toDay:String, reason:String, fullName:String, parent:String, linkAvatar:String, className:String) {
        self.id = id
        self.currentDay = currentDay
        self.fromDay = fromDay
        self.toDay = toDay
        self.reason = reason
        self.fullName = fullName
        self.parent = parent
        self.linkAvatar = linkAvatar
        self.className = className
    }
}
