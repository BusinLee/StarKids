//
//  Notice.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/18/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import Foundation
import UIKit

struct Notice {
    var idNotice:String!
    var postId:String!
    var userCmt:String!
    var nameUserComment:String!
    var linkAvaCmt:String!
    var seen:Bool!
    var day:String!
    var time:String!
    var content:String!
    var userSeen:String!
    var idContent:String!
    
    init() {
        idNotice = ""
        postId = ""
        userCmt = ""
        nameUserComment = ""
        linkAvaCmt = ""
        seen = false
        day = ""
        time = ""
        content = ""
        userSeen = ""
        idContent = ""
    }
    
    init(idNotice:String, postId:String, userCmt:String, nameUserComment:String, linkAvaCmt:String,  seen:Bool,day:String, time:String, content:String, userSeen: String, idContent: String)
    {
        self.idNotice = idNotice
        self.postId = postId
        self.userCmt = userCmt
        self.nameUserComment = nameUserComment
        self.linkAvaCmt = linkAvaCmt
        self.seen = seen
        self.day = day
        self.time = time
        self.content = content
        self.userSeen = userSeen
        self.idContent = idContent
    }
}
