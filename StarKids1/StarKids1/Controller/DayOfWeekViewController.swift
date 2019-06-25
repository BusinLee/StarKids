//
//  DayOfWeekViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/25/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

var selectedMenu:Menu!

class DayOfWeekViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Ngày"
    }

    @IBAction func tap_Monday(_ sender: Any) {
        getMenu(day: "Monday")
    }
    
    @IBAction func tap_Tuesday(_ sender: Any) {
        getMenu(day: "Tuesday")
    }
    
    @IBAction func tap_Wednesday(_ sender: Any) {
        getMenu(day: "Wednesday")
    }
    
    @IBAction func tap_Thusday(_ sender: Any) {
        getMenu(day: "Thusday")
    }
    
    @IBAction func tap_Friday(_ sender: Any) {
        getMenu(day: "Friday")
    }
    
    func getMenu(day:String) {
        let tableName = ref.child("Menus").child(selectedDayMenu!).child(day)
        tableName.observe(.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String: Any]
            if (postDict != nil) {
                let main1 = (postDict?["main1"]) as! String
                let main2 = (postDict?["main2"]) as! String
                let fry = (postDict?["fry"]) as! String
                let soup = (postDict?["soup"]) as! String
                let linkMain1 = (postDict?["linkMain1"]) as! String
                let linkMain2 = (postDict?["linkMain2"]) as! String
                let linkFry = (postDict?["linkFry"]) as! String
                let linkSoup = (postDict?["linkSoup"]) as! String
                
                selectedMenu = Menu(id: selectedDayMenu, day: day, main1: main1, main2: main2, fry: fry, soup: soup, imgMain1: linkMain1, imgMain2: linkMain2, imgFry: linkFry, imgSoup: linkSoup)
                self.gotoScreenWithBack(idScreen: "scrDetailMenu")
            }
        })
    }
}
