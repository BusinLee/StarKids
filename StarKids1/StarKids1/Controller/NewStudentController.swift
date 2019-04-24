//
//  NewStudentController.swift
//  StarKids1
//
//  Created by Thanh Lê on 4/7/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit
import Firebase


let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://starkids1-fda2a.appspot.com")

class NewStudentController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var lbValid: UILabel!
    @IBOutlet weak var txtBirthYear: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnAddStudent: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var pickerBirthDay: UIPickerView!
    
    var arrDate = [[Int]]()
    var date:String = ""
    var day:String = "01"
    var month:String = "01"
    var imgData:Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerBirthDay.delegate = self
        pickerBirthDay.dataSource = self
        imgData = UIImage(named: "camera")!.pngData()
        for i in 0...1 {
            var row = [Int]()
            for j in 0...30 {
                row.append(j+1)
                if (i==1 && j==11) {
                    break
                }
            }
            arrDate.append(row)
        }
        txtBirthYear.text = String(Calendar.current.component(.year, from: Date()) - 5)
        btnAddStudent.layer.cornerRadius = 5
        lbValid.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func tap_Avata(_ sender: UITapGestureRecognizer) {
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
    @IBAction func btn_AddStudent(_ sender: Any) {
        
        let alertActivity:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame = CGRect(x: view.frame.size.width/2-20, y: 25, width: 0, height: 0)
        activity.color = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        alertActivity.view.addSubview(activity)
        activity.startAnimating()
        self.present(alertActivity, animated: true, completion: nil)
        
        if ((month == "04" || month == "06" || month == "09" || month == "11") && day == "31") {
            lbValid.isHidden = false
        } else {
            if (month == "02" && (day == "30" || day == "31")) {
                lbValid.isHidden = false
            } else {
                if (month == "02" && day == "29" && (Int(txtBirthYear.text!)! % 4) != 0) {
                    lbValid.isHidden = false
                } else {
                    date = day + month + txtBirthYear.text!
                    lbValid.isHidden = true
                }
            }
        }
        let email:String = txtEmail.text!
        let password:String = date
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if (error == nil)
            {
                Auth.auth().signIn(withEmail: email, password: password) { user, error in
                    if (error == nil)
                    {
                        print("Đăng nhập thành công")
                    }
                }
                
                let avatarRef = storageRef.child("avatars/\(email).jpg")
                let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { metadata, error in
                    guard let metadata = metadata else {
                        print("Lỗi up avatar")
                        return
                    }
                    let size = metadata.size
                    avatarRef.downloadURL { (url, error) in
                        
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.txtFullName.text!
                        changeRequest?.photoURL = url
                        changeRequest?.commitChanges { (error) in
                            if (error == nil){
                                activity.stopAnimating()
                                alertActivity.dismiss(animated: true, completion: nil)
                                self.gotoScreenWithBack(idScreen: "scrListChat")
                            } else {
                                print("Lỗi update profile")
                            }
                        }
                    }
                }
                uploadTask.resume()
            }
            else
            {
                print("Lỗi đăng ký!")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return arrDate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrDate[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arrDate[component][row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (component == 0) {
            if (arrDate[component][row] < 10) {
                day = "0" + String(arrDate[component][row])
            } else {
                day = String(arrDate[component][row])
            }
        }
        else {
            if (arrDate[component][row] < 10) {
                month = "0" + String(arrDate[component][row])
            } else {
                month = String(arrDate[component][row])
            }
        }
    }
}
extension NewStudentController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
            self.imgAvatar.image = UIImage(data:imgData)
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
                self.imgAvatar.image = UIImage(data:imgData)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
