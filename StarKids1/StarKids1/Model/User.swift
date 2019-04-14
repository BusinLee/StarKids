//
//  User.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/14/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id:String!
    let email:String!
    let fullName:String!
    let linkAvatar:String!
    let avatar:UIImage!
    
    init() {
        id = ""
        email = ""
        fullName = ""
        linkAvatar = ""
        avatar = UIImage(named: "user")
    }
    
    init(id:String, email:String, fullName:String, linkAvatar:String)
    {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.linkAvatar = linkAvatar
        self.avatar = UIImage(named: "user")
    }
}
