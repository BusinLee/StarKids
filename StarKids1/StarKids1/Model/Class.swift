//
//  Class.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/20/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import Foundation
import UIKit

struct Class {
    var idClass: String!
    var className: String!
    var teacherName: String!
    
    init() {
        idClass = ""
        className = ""
        teacherName = ""
    }
    
    init(idClass:String, className:String, teacherName:String) {
        self.idClass = idClass
        self.className = className
        self.teacherName = teacherName
    }


}
