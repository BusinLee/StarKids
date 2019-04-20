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
            
        }
    }
    
    
    @IBAction func btn_Temp(_ sender: Any) {
        self.gotoScreen(idScreen: "scrListFriend")
    }

}
