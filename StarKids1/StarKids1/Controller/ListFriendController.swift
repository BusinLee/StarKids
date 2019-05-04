//
//  ListFriendController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/20/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

var visitor:User!

class ListFriendController: UIViewController {

    var listFriend:Array<User> = Array<User>()

    @IBOutlet weak var tblListFriend: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblListFriend.dataSource = self
        tblListFriend.delegate = self
        
        let tableName = ref.child("Students")
        tableName.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if (postDict != nil) {
                print("++++++++ \(postDict)")
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
                let user:User = User(id: snapshot.key, email: email, fullName: fullName, linkAvatar: linkAvatar, nickName: nickName, className: className, teacherName: teacherName, birthDay: birthDay, gender: gender, hobby: hobby, fatherName: fatherName, fatherPhone: fatherPhone, motherName: motherName, motherPhone: motherPhone, weight: weight, height: height, illness: illness, dayLeave: dayLeave, evaluation: evaluation, note: note, ability: ability)
                if (user.id != currentUser.id)
                {
                    self.listFriend.append(user)
                }
                self.tblListFriend.reloadData()
            }
            else {
                print("Không có user")
            }
        })
    }
    
}

extension ListFriendController : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScreenListFriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenListFriendTableViewCell
        cell.lblName.text = listFriend[indexPath.row].fullName
        cell.imageAvatar.loadAvatar(link: listFriend[indexPath.row].linkAvatar)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        visitor = listFriend[indexPath.row]
        let url:URL = URL(string: visitor.linkAvatar)!
        do
        {
            let data:Data = try Data(contentsOf: url)
            visitor.avatar = UIImage(data: data)
            gotoScreenWithBack(idScreen: "scrChatView")
            tableView.deselectRow(at: indexPath, animated: true)
        }
        catch
        {
                print("Lỗi load avatar vistior")
        }
    }
}
