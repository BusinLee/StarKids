//
//  AddMenuViewController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/24/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class AddMenuViewController: UIViewController{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMonMain1: UITextField!
    @IBOutlet weak var lblMonMain2: UITextField!
    @IBOutlet weak var lblMonFry: UITextField!
    @IBOutlet weak var lblMonSoup: UITextField!
    @IBOutlet weak var lblTueMain1: UITextField!
    @IBOutlet weak var lblTueMain2: UITextField!
    @IBOutlet weak var lblTueFry: UITextField!
    @IBOutlet weak var lblTueSoup: UITextField!
    @IBOutlet weak var lblWedMain1: UITextField!
    @IBOutlet weak var lblWedMain2: UITextField!
    @IBOutlet weak var lblWedFry: UITextField!
    @IBOutlet weak var lblWedSoup: UITextField!
    @IBOutlet weak var lblThuMain1: UITextField!
    @IBOutlet weak var lblThuMain2: UITextField!
    @IBOutlet weak var lblThuFry: UITextField!
    @IBOutlet weak var lblThuSoup: UITextField!
    @IBOutlet weak var lblFriMain1: UITextField!
    @IBOutlet weak var lblFriMain2: UITextField!
    @IBOutlet weak var lblFriFry: UITextField!
    @IBOutlet weak var lblFriSoup: UITextField!
    
    @IBOutlet weak var imgMonMain1: UIImageView!
    
    var monday:Date = Date()
    var friday:Date = Date()
    var imgData:Data!
    var currentImageView: UIImageView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        
        let now = Date()
        print(df.string(from: now))
        
        monday = getMonday(myDate: now)
        friday = Calendar.current.date(byAdding: .day, value: 4, to: monday)!
        lblTitle.text = "Thực đơn " + df.string(from: monday) + "-" + df.string(from: friday)
    }
    
    @IBAction func tap_MonMain1(_ sender: Any) {
        currentImageView = imgMonMain1
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tap_MonMain2(_ sender: Any) {
    }
    
    @IBAction func tap_MonFry(_ sender: Any) {
    }
    
    @IBAction func tap_MonSoup(_ sender: Any) {
    }
    
    @IBAction func tap_TueMain1(_ sender: Any) {
    }
    
    @IBAction func tap_TueMain2(_ sender: Any) {
    }
    
    @IBAction func tap_TueFry(_ sender: Any) {
    }
    
    @IBAction func tap_TueSoup(_ sender: Any) {
    }
    
    @IBAction func tap_WedMain1(_ sender: Any) {
    }
    
    @IBAction func tap_WedMain2(_ sender: Any) {
    }
    
    @IBAction func tap_WebFry(_ sender: Any) {
    }
    
    @IBAction func tap_WedSoup(_ sender: Any) {
    }
    
    @IBAction func tap_ThuMain1(_ sender: Any) {
    }
    
    @IBAction func tap_ThuMain2(_ sender: Any) {
    }
    
    @IBAction func tap_ThuFry(_ sender: Any) {
    }
    
    @IBAction func tap_ThuSoup(_ sender: Any) {
    }
    
    @IBAction func tap_FriMain1(_ sender: Any) {
    }
    
    @IBAction func tap_FriMain2(_ sender: Any) {
    }
    
    @IBAction func tap_FriFry(_ sender: Any) {
    }
    
    @IBAction func tap_FriSoup(_ sender: Any) {
    }
    
    func chooseImg() {
        let alert:UIAlertController = UIAlertController(title: "Thông báo", message: "Chọn", preferredStyle: .alert)
        let btnPhoto:UIAlertAction = UIAlertAction(title: "Photo", style: .default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        let btnCamera:UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerController.SourceType.camera
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getMonday(myDate: Date) -> Date {
        let cal = Calendar.current
        //let cal = Calendar.current.date(byAdding: .day, value: 7, to: myDate)
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
        comps.weekday = 2 // Monday
        let mondayInWeek = cal.date(from: comps)!
        let mondayNextWeek = Calendar.current.date(byAdding: .day, value: 7, to: mondayInWeek)
        return mondayNextWeek!
    }
}
extension AddMenuViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            let imgValue = max(image.size.width, image.size.height)
            if (imgValue > 3000) {
                imgData = image.jpegData(compressionQuality: 0.1)
            } else
                if (imgValue > 2000) {
                    imgData = image.jpegData(compressionQuality: 0.3)
                } else {
                    imgData = image.pngData()
            }
            
            let image = info[UIImagePickerController.InfoKey.originalImage]
            currentImageView?.image = image as! UIImage
            
            //self.imgAvatar.image = UIImage(data:imgData)
        }
        else
            if let image = info[.editedImage] as? UIImage {
                let imgValue = max(image.size.width, image.size.height)
                if (imgValue > 3000) {
                    imgData = image.jpegData(compressionQuality: 0.1)
                } else
                    if (imgValue > 2000) {
                        imgData = image.jpegData(compressionQuality: 0.3)
                    } else {
                        imgData = image.pngData()
                }
                let image = info[UIImagePickerController.InfoKey.originalImage]
                currentImageView?.image = image as! UIImage
                //self.imgAvatar.image = UIImage(data:imgData)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
