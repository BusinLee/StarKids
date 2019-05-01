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
    var avatar:UIImage!
    let nickName:String!
    let className:String!
    let teacherName:String!
    let birthDay:String!
    let gender:String!
    let hobby:String!
    let fatherName:String!
    let fatherPhone:String!
    let motherName:String!
    let motherPhone:String!
    let weight:Int!
    let height:Int!
    let illness:String!
    let dayLeave:Int!
    let evaluation:String!
    let note:String!
    let ability:String!
    
    init() {
        id = ""
        email = ""
        fullName = ""
        linkAvatar = ""
        avatar = UIImage(named: "user")
        nickName = ""
        className = ""
        teacherName = ""
        birthDay = ""
        gender = ""
        hobby = ""
        fatherName = ""
        fatherPhone = ""
        motherName = ""
        motherPhone = ""
        weight = 0
        height = 0
        illness = ""
        dayLeave = 0
        evaluation = ""
        note = ""
        ability = ""
    }
    
    init(id:String, email:String, fullName:String, linkAvatar:String, nickName:String, className:String, teacherName:String, birthDay:String, gender:String, hobby:String, fatherName:String, fatherPhone:String, motherName:String, motherPhone:String, weight:Int, height:Int, illness:String, dayLeave:Int, evaluation:String, note:String, ability:String)
    {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.linkAvatar = linkAvatar
        self.avatar = UIImage(named: "user")
        self.nickName = nickName
        self.className = className
        self.teacherName = teacherName
        self.birthDay = birthDay
        self.gender = gender
        self.hobby = hobby
        self.fatherName = fatherName
        self.fatherPhone = fatherPhone
        self.motherName = motherName
        self.motherPhone = motherPhone
        self.weight = weight
        self.height = height
        self.illness = illness
        self.dayLeave = dayLeave
        self.evaluation = evaluation
        self.note = note
        self.ability = ability
    }
}
extension UIImageView
{
    func loadAvatar(link:String)
    {
        let queue:DispatchQueue = DispatchQueue(label: "LoadImages", attributes: .concurrent, target: nil)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activity.frame = CGRect(x: self.frame.size.width/2+5, y: self.frame.size.height/2+5, width: 0, height: 0)
        activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(229)/255, blue: CGFloat(139)/255, alpha: 1.0)
        self.addSubview(activity)
        activity.startAnimating()
        
        queue.async {
            let url:URL = URL(string: link)!
            do
            {
                let data:Data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    activity.stopAnimating()
                    self.image = UIImage(data: data)
                }
            }
            catch
            {
                activity.stopAnimating()
                print("Lỗi load hình avatar")
            }
        }
    }
}
