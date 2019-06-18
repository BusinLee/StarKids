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
    let nameuserPost:String!
    let linkAvatarPost:String!
    let date:String!
    let time:String!
    let content:String!
    var likes:Int!
    var comment:Int!
    var isLike:String!
    var pictures:String!
    
    init() {
        id = ""
        userPost = ""
        nameuserPost = ""
        linkAvatarPost = ""
        date = ""
        time = ""
        content = ""
        likes = 0
        comment = 0
        isLike = ""
        pictures = ""
    }
    
    init(id:String, userPost:String,nameuserPost:String, linkAvatarPost:String, date:String, time:String, content:String, likes:Int, comment:Int, isLike:String, pictures:String)
    {
        self.id = id
        self.userPost = userPost
        self.nameuserPost = nameuserPost
        self.linkAvatarPost = linkAvatarPost
        self.date = date
        self.time = time
        self.content = content
        self.likes = likes
        self.isLike = isLike
        self.comment = comment
        self.pictures = pictures
    }
}
