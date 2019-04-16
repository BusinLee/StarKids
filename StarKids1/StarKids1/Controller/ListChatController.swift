//
//  ListChatController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/14/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase
let ref = Database.database().reference()
var currentUser:User!

class ListChatController: UIViewController {

    var listFriend:Array<User> = Array<User>()
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            tableName.observe(.childAdded, with: { (snapshot) in
                let postDict = snapshot.value as? [String: AnyObject]
                if (postDict != nil) {
                    print("++++++++ \(postDict)")
                    let email:String = (postDict?["email"])! as! String
                    let fullName:String = (postDict?["fullName"])! as! String
                    let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                    
                    let user:User = User(id: snapshot.key, email: email, fullName: fullName, linkAvatar: linkAvatar)
                    self.listFriend.append(user)
                    print("-------- \(self.listFriend)")
                }
            })
        } else {
            print("Không có user")
        }
    }
    

}
