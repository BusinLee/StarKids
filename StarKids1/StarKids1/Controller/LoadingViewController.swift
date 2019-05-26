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
                    print("\(uid)")
                    self.tableName = ref.child("Users")
                    self.tableName.observe(.childAdded, with: { (snapshot) -> Void in
                        print("vô trong rồi")
                        let postDict = snapshot.value as? [String:AnyObject]
                        if (postDict != nil)
                        {
                            if (snapshot.key == uid) {
                                
                                print("Kiểm tra lại tên attributes")
                                let email:String = (postDict?["email"])! as! String
                                let fullName:String = (postDict?["fullName"])! as! String
                                let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                                let nickName:String = (postDict?["nickName"])! as! String
                                let className:String = (postDict?["className"])! as! String
                                let teacherName:String = (postDict?["teacherName"])! as! String
                                let birthDay:String = (postDict?["birthDay"])! as! String
                                let gender:String = (postDict?["gender"])! as! String
                                let hobby:String = (postDict?["hobby"])! as! String
                                let fatherName:String = (postDict?["fatherName"])! as! String
                                let fatherPhone:String = (postDict?["fatherPhone"])! as! String
                                let motherName:String = (postDict?["motherName"])! as! String
                                let motherPhone:String = (postDict?["motherPhone"])! as! String
                                let weight:Int = (postDict?["weight"])! as! Int
                                let height:Int = (postDict?["height"])! as! Int
                                let illness:String = (postDict?["illness"])! as! String
                                let dayLeave:Int = (postDict?["dayLeave"])! as! Int
                                let evaluation:String = (postDict?["evaluation"])! as! String
                                let note:String = (postDict?["note"])! as! String
                                let ability:String = (postDict?["ability"])! as! String
                                
                                currentUser = User(id: uid, email: email ?? "nil", fullName: fullName ?? "nil", linkAvatar: linkAvatar ?? "nil", nickName: nickName ?? "nil", className: className ?? "nil", teacherName: teacherName ?? "nil", birthDay: birthDay ?? "nil", gender: gender ?? "nil", hobby: hobby ?? "nil", fatherName: fatherName ?? "nil", fatherPhone: fatherPhone ?? "nil", motherName: motherName ?? "nil", motherPhone: motherPhone ?? "nil", weight: weight ?? 0, height: height ?? 0, illness: illness ?? "nil", dayLeave: dayLeave ?? 0, evaluation: evaluation ?? "nil", note: note ?? "nil", ability: ability ?? "nil")
                                print("in\(currentUser)")
                                print("\(currentUser)")
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
            } else {
                activity.stopAnimating()
                print("Chua dang nhap")
                self.gotoScreen(idScreen: "scrLogin")
            }
        }
    }
    
}
//self.tableName = ref.child("Users").child(uid)
//self.tableName.observeSingleEvent(of: .value, with: { (snapshot) in
//    for child in snapshot.children {
//        let snap = child as! DataSnapshot
//        let email:String = snap.value(forKey: "email") as! String
//        let fullName:String = snap.value(forKey: "fullName") as! String
//        let linkAvatar:String = snap.value(forKey: "linkAvatar") as! String
//        let nickName:String = snap.value(forKey: "nickName") as! String
//        let className:String = snap.value(forKey: "className") as! String
//        let teacherName:String = snap.value(forKey: "teacherName") as! String
//        let birthDay:String = snap.value(forKey: "birthDay") as! String
//        let gender:String = snap.value(forKey: "gender") as! String
//        let hobby:String = snap.value(forKey: "hobby") as! String
//        let fatherName:String = snap.value(forKey: "fatherName") as! String
//        let fatherPhone:String = snap.value(forKey: "fatherPhone") as! String
//        let motherName:String = snap.value(forKey: "motherName") as! String
//        let motherPhone:String = snap.value(forKey: "motherPhone") as! String
//        let weight:Int = snap.value(forKey: "weight") as! Int
//        let height:Int = snap.value(forKey: "height") as! Int
//        let illness:String = snap.value(forKey: "illness") as! String
//        let dayLeave:Int = snap.value(forKey: "dayLeave") as! Int
//        let evaluation:String = snap.value(forKey: "evaluation") as! String
//        let note:String = snap.value(forKey: "note") as! String
//        let ability:String = snap.value(forKey: "ability") as! String
//        currentUser = User(id: uid, email: email ?? "nil", fullName: fullName ?? "nil", linkAvatar: linkAvatar ?? "nil", nickName: nickName ?? "nil", className: className ?? "nil", teacherName: teacherName ?? "nil", birthDay: birthDay ?? "nil", gender: gender ?? "nil", hobby: hobby ?? "nil", fatherName: fatherName ?? "nil", fatherPhone: fatherPhone ?? "nil", motherName: motherName ?? "nil", motherPhone: motherPhone ?? "nil", weight: weight ?? 0, height: height ?? 0, illness: illness ?? "nil", dayLeave: dayLeave ?? 0, evaluation: evaluation ?? "nil", note: note ?? "nil", ability: ability ?? "nil")
//        print("in\(currentUser)")
//    }
//})
