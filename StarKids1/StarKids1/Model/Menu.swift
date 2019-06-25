//
//  Menu.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/25/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import Foundation
import UIKit

struct Menu {
    var id:String!
    var day:String!
    var main1:String!
    var main2:String!
    var fry:String!
    var soup:String!
    var imgMain1:String!
    var imgMain2:String!
    var imgFry:String!
    var imgSoup:String!
    
    init() {
        id = ""
        day = ""
        main1 = ""
        main2 = ""
        fry = ""
        soup = ""
        imgMain1 = ""
        imgMain2 = ""
        imgFry = ""
        imgSoup = ""
    }
    
    init(id:String, day:String, main1:String, main2:String, fry:String, soup:String, imgMain1:String, imgMain2:String, imgFry:String, imgSoup:String) {
        self.id = id
        self.day = day
        self.main1 = main1
        self.main2 = main2
        self.fry = fry
        self.soup = soup
        self.imgMain1 = imgMain1
        self.imgMain2 = imgMain2
        self.imgFry = imgFry
        self.imgSoup = imgSoup
    }
}
