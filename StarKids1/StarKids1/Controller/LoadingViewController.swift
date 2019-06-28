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
    
    var tableName:DatabaseReference!
    
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
            self.imgLogo.frame.origin.y += 70
        })
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.1, options: [.autoreverse, .repeat], animations: {
            self.imgLogo.frame.origin.y -= 70
        })
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil)
            {
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    let uid = user.uid
                    self.tableName = ref.child("Students")
                    self.tableName.observe(.childAdded, with: { (snapshot) -> Void in
                        let postDict = snapshot.value as? [String:AnyObject]
                        if (postDict != nil)
                        {
                            if (snapshot.key == uid) {
                                let email:String = (postDict?["email"])! as! String
                                let fullName:String = (postDict?["fullName"])! as! String
                                let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                                
                                currentUser = User(id: uid, email: email ?? "nil", fullName: fullName ?? "nil", linkAvatar: linkAvatar ?? "nil", phone: "", role: "student")
                                let url:URL = URL(string: currentUser.linkAvatar)!
                                do
                                {
                                    let data:Data = try Data(contentsOf: url)
                                    currentUser.avatar = UIImage(data: data)
                                    activity.stopAnimating()
                                    self.gotoScreen(idScreen: "mainTabBarController")
                                }
                                catch
                                {
                                    print("lỗi gán avatar current user")
                                }
                                
                            }
                            else {
                                self.tableName = ref.child("Teachers")
                                self.tableName.observe(.childAdded, with: { (snapshot1) -> Void in
                                    let postDict1 = snapshot1.value as? [String:AnyObject]
                                    if (postDict1 != nil)
                                    {
                                        if (snapshot1.key == uid) {
                                            let email:String = (postDict1?["email"])! as! String
                                            let fullName:String = (postDict1?["fullName"])! as! String
                                            let linkAvatar:String = (postDict1?["linkAvatar"])! as! String
                                            
                                            if (email == "businlee@gmail.com")
                                            {
                                                currentUser = User(id: uid, email: email ?? "nil", fullName: fullName ?? "nil", linkAvatar: linkAvatar ?? "nil", phone: "", role: "admin")
                                            }
                                            else
                                            {
                                                currentUser = User(id: uid, email: email ?? "nil", fullName: fullName ?? "nil", linkAvatar: linkAvatar ?? "nil", phone: "", role: "teacher")
                                            }
                                            let url:URL = URL(string: currentUser.linkAvatar)!
                                            do
                                            {
                                                let data:Data = try Data(contentsOf: url)
                                                currentUser.avatar = UIImage(data: data)
                                                activity.stopAnimating()
                                                self.gotoScreen(idScreen: "mainTabBarController")
                                            }
                                            catch
                                            {
                                                print("lỗi gán avatar current user")
                                            }
                                            
                                        }
                                        
                                    }
                                    else {
                                        print("Nil rồi")
                                    }
                                })
                            }
                            
                        }
                        else {
                            print("Nil rồi")
                        }
                    })
                }
            } else {
                activity.stopAnimating()
                self.gotoScreen(idScreen: "scrLogin")
            }
        }
    }
    
}
