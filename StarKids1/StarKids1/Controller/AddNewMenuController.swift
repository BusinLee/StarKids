//
//  AddNewMenuController.swift
//  StarKids1
//
//  Created by Chau Nguyen on 5/23/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase

class AddNewMenuController: UIViewController {
    var imageViews: [UIImageView] = []
    var strDate = ""
    var urlArr: [String] = []
    var imageview: UIImageView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var dtpDate: UIDatePicker!
    @IBAction func datePickerChanged(_ sender: Any) {
        self.formatDate(date: dtpDate.date)
    }
    @IBOutlet weak var txtMainDish1: UITextField!
    @IBOutlet weak var txtMainDish2: UITextField!
    @IBOutlet weak var txtSauteDish: UITextField!
    @IBOutlet weak var txtSoup: UITextField!
    @IBOutlet weak var imgDish1: UIImageView!
    @IBOutlet weak var imgDish2: UIImageView!
    @IBOutlet weak var imgSauteDish: UIImageView!
    @IBOutlet weak var imgSoup: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func btn_Confirm(_ sender: Any) {
        SaveNewMenu()
    }
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btn_Cancel(_ sender: Any) {
        let CancelAlert = UIAlertController(title: "Xác Nhận", message: "Bạn có muốn huỷ thực đơn không?", preferredStyle: UIAlertController.Style.alert)
        CancelAlert.addAction(UIAlertAction(title: "Có", style: UIAlertAction.Style.default, handler: {action in self.Reset()}))
        CancelAlert.addAction(UIAlertAction(title: "Không", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(CancelAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnConfirm.layer.cornerRadius = 20
        btnCancel.layer.cornerRadius = 20
        imageViews = [imgDish1, imgDish2, imgSauteDish, imgSoup]
        let tapGestureDish1 = UITapGestureRecognizer(target: self, action: #selector(AddNewMenuController.openGalleryClick(tapGesture:)))
        imgDish1.isUserInteractionEnabled = true
        imgDish1.tag = 1
        imgDish1.addGestureRecognizer(tapGestureDish1)
        let tapGestureDish2 = UITapGestureRecognizer(target: self, action: #selector(AddNewMenuController.openGalleryClick(tapGesture:)))
        imgDish2.isUserInteractionEnabled = true
        imgDish2.tag = 2
        imgDish2.addGestureRecognizer(tapGestureDish2)
        let tapGestureSaute = UITapGestureRecognizer(target: self, action: #selector(AddNewMenuController.openGalleryClick(tapGesture:)))
        imgSauteDish.isUserInteractionEnabled = true
        imgSauteDish.tag = 3
        imgSauteDish.addGestureRecognizer(tapGestureSaute)
        let tapGestureSoup = UITapGestureRecognizer(target: self, action: #selector(AddNewMenuController.openGalleryClick(tapGesture:)))
        imgSoup.isUserInteractionEnabled = true
        imgSoup.tag = 4
        imgSoup.addGestureRecognizer(tapGestureSoup)
       
        
    }
    @objc func openGalleryClick(tapGesture: UITapGestureRecognizer){
        self.setupImagePicker()
        if (tapGesture.view!.tag == 1)
        {
            imageview = imgDish1
        }
        if (tapGesture.view!.tag == 2)
        {
            imageview = imgDish2
        }
        if (tapGesture.view!.tag == 3)
        {
            imageview = imgSauteDish
        }
        if (tapGesture.view!.tag == 4)
        {
            imageview = imgSoup
        }
    }
    
    func formatDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        strDate =  dateFormatter.string(from: date)
    }
    func Reset() {
        txtMainDish1.text = ""
        txtMainDish2.text = ""
        txtSauteDish.text = ""
        txtSoup.text = ""
        let img : UIImage = UIImage(named:"camera.png")!
        imgDish1.image = img
        imgDish2.image = img
        imgSoup.image = img
        imgSauteDish.image = img
        dtpDate.setDate(Date(), animated: false)
    }
    //completion: @escaping ((_ url: URL?) -> ())
    func UploadImage() {
    
        for imgView in imageViews
        {
            let imageName = NSUUID().uuidString
            let storeImage = storageRef.child("Food_Images").child(imageName)
            let imgData = imgView.image?.pngData()
            //let metaData = StorageMetadata()
            //metaData.contentType = "image/png"
            storeImage.putData(imgData!, metadata: nil) { (metadata, error) in
                if error == nil{
                    storeImage.downloadURL(completion: { (url, error) in
                        if url == nil
                        {
                            self.urlArr.append("not get download url")
                        }
                        else
                        {
                            self.urlArr.append((url?.absoluteString)!)
                        }
                        
                       
                    })
                }else{
                    print("error in save image")
                    
                }
                
            }
        }
    }

    func SaveNewMenu() {
        UploadImage()
        let Menu = ["Date": strDate,
                    "MainDish1": txtMainDish1.text! as String,
                    "MainDish2": txtMainDish2.text! as String,
                    "SauteDish": txtSauteDish.text! as String,
                    "Soup": txtSoup.text! as String,
                    "imgDish1": urlArr[0],
                    "imgDish2": urlArr[1],
                    "imgSaute": urlArr[2],
                    "imgSoup": urlArr[3]
            ] as [String : Any]
        ref.child("Menu").childByAutoId().setValue(Menu)
        let SuccessAlert = UIAlertController(title: "Xác Nhận", message: "Tạo thực đơn thành công.", preferredStyle: UIAlertController.Style.alert)
        SuccessAlert.addAction(UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(SuccessAlert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddNewMenuController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func setupImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageview.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
