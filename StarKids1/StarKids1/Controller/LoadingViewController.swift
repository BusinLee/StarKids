//
//  LoadingViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/27/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase

let ref = Database.database().reference()
var currentUser:User!

class LoadingViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        isLogin();
    }
    
    func isLogin()
    {
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame = CGRect(x: view.frame.size.width/2, y: view.frame.size.height/2, width: 0, height: 0)
        activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        self.view.addSubview(activity)
        activity.startAnimating()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imgLogo.frame.origin.y -= 70
        }){_ in
            UIView.animateKeyframes(withDuration: 0.5, delay: 0.1, options: [.autoreverse, .repeat], animations: {
                self.imgLogo.frame.origin.y += 50
            })
        }
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil)
            {
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL
                    let name = user.displayName
                    
                    currentUser = User(id: uid, email: email!, fullName: name!, linkAvatar: photoURL!.absoluteString)
                    
                    let tableName = ref.child("ListFriend")
                    let userId = tableName.child(currentUser.id)
                    let user:Dictionary<String,String> = ["email":currentUser.email,"fullName":currentUser.fullName,"linkAvatar":currentUser.linkAvatar]
                    userId.setValue(user)
                    let url:URL = URL(string: currentUser.linkAvatar)!
                    do
                    {
                        let data:Data = try Data(contentsOf: url)
                        currentUser.avatar = UIImage(data: data)
                    }
                    catch
                    {
                        print("lỗi gán avatar current user")
                    }
                }
                activity.stopAnimating()
                self.gotoScreen(idScreen: "mainTabBarController")
            } else {
                activity.stopAnimating()
                print("Chua dang nhap")
            }
        }
    }

}
