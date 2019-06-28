//
//  DetailMenuViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/25/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class DetailMenuViewController: UIViewController {

    @IBOutlet weak var lblMain1: UILabel!
    @IBOutlet weak var lblMain2: UILabel!
    @IBOutlet weak var lblFry: UILabel!
    @IBOutlet weak var lblSoup: UILabel!
    @IBOutlet weak var imgMain1: UIImageView!
    @IBOutlet weak var imgMain2: UIImageView!
    @IBOutlet weak var imgFry: UIImageView!
    @IBOutlet weak var imgSoup: UIImageView!
    
    var titleScr:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMain1.text = selectedMenu.main1
        lblMain2.text = selectedMenu.main2
        lblFry.text = selectedMenu.fry
        lblSoup.text = selectedMenu.soup
        
        setImage(img: imgMain1, nameImg: selectedMenu.imgMain1!)
        setImage(img: imgMain2, nameImg: selectedMenu.imgMain2!)
        setImage(img: imgFry, nameImg: selectedMenu.imgFry!)
        setImage(img: imgSoup, nameImg: selectedMenu.imgSoup!)
        
        switch(selectedMenu.day) {
        case "Monday":
            titleScr = "Thứ 2"
            break
        case "Tuesday":
            titleScr = "Thứ 3"
            break
        case "Wednesday":
            titleScr = "Thứ 4"
            break
        case "Thusday":
            titleScr = "Thứ 5"
            break
        default:
            titleScr = "Thứ 6"
            break
        }
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = titleScr
    }
    
    func setImage (img:UIImageView, nameImg:String) {
        print("menus/\(selectedMenu.id!)/\(selectedMenu.day!)/\(nameImg)")
        let pictureRef = storageRef.child("menus/\(selectedMenu.id!)/\(selectedMenu.day!)/\(nameImg).jpg")
        pictureRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Không load được hình menu")
            } else {
                img.image = UIImage(data: data!)
                print("Vao collectionpost")
            }
        }
    }
}
