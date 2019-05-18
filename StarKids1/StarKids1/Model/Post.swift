//
//  Post.swift
//  StarKids1
//
//  Created by Thanh Lê on 5/18/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    let id:String!
    let userPost:String!
    let date:String!
    let time:String!
    let content:String!
    var likes:Array<String> = Array<String>()
    var comments:Array<String> = Array<String>()
    var userComments:Array<String> = Array<String>()
    var pictures:Array<String> = Array<String>()
    
    init() {
        id = ""
        userPost = ""
        date = ""
        time = ""
        content = ""
        likes = [""]
        comments = [""]
        userComments = [""]
        pictures = [""]
    }
    
    init(id:String, userPost:String, date:String, time:String, content:String, likes:Array<String>, comments:Array<String>, userComments:Array<String>, pictures:Array<String>)
    {
        self.id = id
        self.userPost = userPost
        self.date = date
        self.time = time
        self.content = content
        self.likes = likes
        self.comments = comments
        self.userComments = userComments
        self.pictures = pictures
    }
}
