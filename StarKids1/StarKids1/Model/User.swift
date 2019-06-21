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
    let phone:String!
    let role:String!
    
    init() {
        id = ""
        email = ""
        fullName = ""
        linkAvatar = ""
        avatar = UIImage(named: "user")
        phone = ""
        role = ""
    }
    
    init(id:String, email:String, fullName:String, linkAvatar:String, phone:String,  role:String)
    {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.linkAvatar = linkAvatar
        self.avatar = UIImage(named: "user")
        self.phone = phone
        self.role = role
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
