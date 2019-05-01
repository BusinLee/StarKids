//
//  MoreController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase

class MoreController: UIViewController {
    let arrIcon:Array<String> = ["contact","tuition","form","menu","student","logout"]
    let arrMenu:Array<String> = ["Liên lạc khác","Học phí","Đơn xin nghỉ học","Thực đơn","Thêm học sinh","Đăng xuất"]
    @IBOutlet weak var tblListMenu: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblListMenu.dataSource = self
        tblListMenu.delegate = self
        tblListMenu.alwaysBounceVertical = false
        
        lblName.text = currentUser.fullName
        imgAvatar.image = currentUser.avatar
    }

}

extension MoreController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrIcon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScreenMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScreenMoreTableViewCell
        cell.imgIcon.image = UIImage(named: arrIcon[indexPath.row])
        cell.lblMenu.text = arrMenu[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.gotoScreenWithBack(idScreen: "scrListFriend")
            break
        case 4:
            self.gotoScreenWithBack(idScreen: "scrAddStudent")
        default:
            let alert = UIAlertController(title: "Xác nhận", message: "Bạn muốn đăng xuất?", preferredStyle: .alert)
            let btnCancel:UIAlertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
            let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    self.gotoScreen(idScreen: "scrLogin")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
            alert.addAction(btnOk)
            alert.addAction(btnCancel)
            present(alert, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
