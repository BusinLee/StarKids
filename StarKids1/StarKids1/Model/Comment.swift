//
//  Comment.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/5/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import Foundation
import UIKit

struct Comment {
    var content:String!
    var userId:String!
    var nameUser:String!
    var linkAvatar:String!
    var time:String!
    var day:String!
    
    init() {
        content = ""
        userId = ""
        nameUser = ""
        linkAvatar = ""
        time = ""
        day = ""
    }
    
    init(content:String,userId:String, nameUser:String, linkAvatar:String,day:String, time:String)
    {
        self.content = content
        self.userId = userId
        self.nameUser = nameUser
        self.linkAvatar = linkAvatar
        self.day = day
        self.time = time
    }
}
