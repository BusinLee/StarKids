//
//  Tuition.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import Foundation
import UIKit

struct Tuition {
    let id:String!
    let camp:String!
    let extra:String!
    let study:String!
    var support:String!
    var verhical:String!
    var year:String!
    let month:String!
    let date:String!
    let sum:String!
    
    init() {
        id = ""
        camp = ""
        extra = ""
        study = ""
        support = ""
        verhical = ""
        year = ""
        month = ""
        date = ""
        sum = ""
    }
    
    init(id:String, camp:String, extra:String, study:String, support:String, verhical:String, year:String, month:String, date:String, sum:String)
    {
        self.id = id
        self.camp = camp
        self.extra = extra
        self.study = study
        self.support = support
        self.verhical = verhical
        self.year = year
        self.month = month
        self.date = date
        self.sum = sum
    }
}
