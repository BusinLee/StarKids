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
    override func viewDidLoad() {
        super.viewDidLoad()

        tblListMenu.dataSource = self
        tblListMenu.delegate = self
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
        if (indexPath.row == 5)
        {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                gotoScreen(idScreen: "scrLogIn")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
}
