//
//  DetailInfoController.swift
//  StarKids1
//
//  Created by Thanh Lê on 5/4/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class DetailInfoController: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var txtNickName: UITextField!
    @IBOutlet weak var pickerBirthDay: UIPickerView!
    @IBOutlet weak var txtBirthYear: UITextField!
    @IBOutlet weak var lblFlash: UILabel!
    @IBOutlet weak var pickerClass: UIPickerView!
    @IBOutlet weak var txtTeacherName: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var txtFatherName: UITextField!
    @IBOutlet weak var txtFatherPhone: UITextField!
    @IBOutlet weak var txtMotherName: UITextField!
    @IBOutlet weak var txtMotherPhone: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtIllness: UITextField!
    @IBOutlet weak var txtLeaveDay: UITextField!
    @IBOutlet weak var txtEvaluation: UITextField!
    @IBOutlet weak var txtHobby: UITextField!
    @IBOutlet weak var txtAbility: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lblTeacher: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblFatherName: UILabel!
    @IBOutlet weak var lblFatherPhone: UILabel!
    @IBOutlet weak var lblMotherName: UILabel!
    @IBOutlet weak var lblMotherPhone: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblIllness: UILabel!
    @IBOutlet weak var lblDayLeave: UILabel!
    @IBOutlet weak var lblEvaluation: UILabel!
    @IBOutlet weak var lblHobby: UILabel!
    @IBOutlet weak var lblAbility: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var btnEditBasic: UIButton!
    @IBOutlet weak var btnDoneBasic: UIButton!
    @IBOutlet weak var btnEditHeath: UIButton!
    @IBOutlet weak var btnDoneHeath: UIButton!
    @IBOutlet weak var btnEditStudy: UIButton!
    @IBOutlet weak var btnDoneStudy: UIButton!
    @IBOutlet weak var btnEditMore: UIButton!
    @IBOutlet weak var btnDoneMore: UIButton!
    
    var gender:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgAvatar.layer.cornerRadius = 0.5 * imgAvatar.bounds.size.width
        imgAvatar.clipsToBounds = true
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.borderColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0).cgColor
        
        btnMale.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnMale.clipsToBounds = true
        
        btnFemale.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnFemale.clipsToBounds = true
        
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
        
        hideGroupBasicTxt(hide: true)
        hideGroupHeathTxt(hide: true)
        hideGroupStudyTxt(hide: true)
        hideGroupMoreTxt(hide: true)
        
        imgAvatar.image = currentUser.avatar
        lblNickName.text = currentUser.nickName
        lblBirthday.text = currentUser.birthDay
        lblClass.text = currentUser.className
        lblTeacher.text = currentUser.teacherName
        lblGender.text = currentUser.gender
        lblFatherName.text = currentUser.fatherName
        lblFatherPhone.text = currentUser.fatherPhone
        lblMotherName.text = currentUser.motherName
        lblMotherPhone.text = currentUser.motherPhone
        lblWeight.text = String(currentUser.weight)
        lblHeight.text = String(currentUser.height)
        lblIllness.text = currentUser.illness
        lblDayLeave.text = String(currentUser.dayLeave)
        lblEvaluation.text = currentUser.evaluation
        lblHobby.text = currentUser.hobby
        lblAbility.text = currentUser.ability
        lblNote.text = currentUser.note
        
        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = currentUser.fullName
    }
    
    @IBAction func btn_Male(_ sender: Any) {
        gender = "nam"
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
    }
    
    @IBAction func btn_Female(_ sender: Any) {
        gender = "nữ"
        changeColorOfRadioButton(btnYellow: btnFemale, btnWhite: btnMale)
    }
    
    @IBAction func tap_lblMale(_ sender: Any) {
        gender = "nam"
        changeColorOfRadioButton(btnYellow: btnMale, btnWhite: btnFemale)
    }
    
    @IBAction func tap_lblFemale(_ sender: Any) {
        gender = "nữ"
        changeColorOfRadioButton(btnYellow: btnFemale, btnWhite: btnMale)
    }
    
    @IBAction func btn_EditBasic(_ sender: Any) {
        hideGroupBasicTxt(hide: false)
        hideGroupBasicLbl(hide: true)
    }
    
    @IBAction func btn_DoneBasic(_ sender: Any) {
        hideGroupBasicTxt(hide: true)
        hideGroupBasicLbl(hide: false)
    }
    
    @IBAction func btn_EditHeath(_ sender: Any) {
        hideGroupHeathTxt(hide: false)
        hideGroupHeathLbl(hide: true)
    }
    
    @IBAction func btn_DoneHeath(_ sender: Any) {
        hideGroupHeathTxt(hide: true)
        hideGroupHeathLbl(hide: false)
    }
    
    @IBAction func btn_EditStudy(_ sender: Any) {
        hideGroupStudyTxt(hide: false)
        hideGroupStudyLbl(hide: true)
    }
    
    @IBAction func btn_DoneStudy(_ sender: Any) {
        hideGroupStudyTxt(hide: true)
        hideGroupStudyLbl(hide: false)
    }
    
    @IBAction func btn_EditMore(_ sender: Any) {
        hideGroupMoreTxt(hide: false)
        hideGroupMoreLbl(hide: true)
    }
    
    @IBAction func btn_DoneMore(_ sender: Any) {
        hideGroupMoreTxt(hide: true)
        hideGroupMoreLbl(hide: false)
    }
    
    func hideGroupBasicTxt(hide:Bool) {
        btnDoneBasic.isHidden = hide
        txtNickName.isHidden = hide
        pickerBirthDay.isHidden = hide
        lblFlash.isHidden = hide
        txtBirthYear.isHidden = hide
        pickerClass.isHidden = hide
        txtTeacherName.isHidden = hide
        btnMale.isHidden = hide
        lblMale.isHidden = hide
        btnFemale.isHidden = hide
        lblFemale.isHidden = hide
        txtFatherName.isHidden = hide
        txtFatherPhone.isHidden = hide
        txtMotherName.isHidden = hide
        txtMotherPhone.isHidden = hide
    }
    
    func hideGroupHeathTxt(hide:Bool) {
        btnDoneHeath.isHidden = hide
        txtWeight.isHidden = hide
        txtHeight.isHidden = hide
        txtIllness.isHidden = hide
    }
    
    func hideGroupStudyTxt(hide:Bool) {
        btnDoneStudy.isHidden = hide
        txtLeaveDay.isHidden = hide
        txtEvaluation.isHidden = hide
    }
    
    func hideGroupMoreTxt(hide:Bool) {
        btnDoneMore.isHidden = hide
        txtHobby.isHidden = hide
        txtAbility.isHidden = hide
        txtNote.isHidden = hide
    }
    
    func hideGroupBasicLbl(hide:Bool) {
        btnEditBasic.isHidden = hide
        lblNickName.isHidden = hide
        lblBirthday.isHidden = hide
        lblClass.isHidden = hide
        lblTeacher.isHidden = hide
        lblGender.isHidden = hide
        lblFatherName.isHidden = hide
        lblFatherPhone.isHidden = hide
        lblMotherName.isHidden = hide
        lblMotherPhone.isHidden = hide
    }
    
    func hideGroupHeathLbl(hide:Bool) {
        btnEditHeath.isHidden = hide
        lblWeight.isHidden = hide
        lblHeight.isHidden = hide
        lblIllness.isHidden = hide
    }
    
    func hideGroupStudyLbl(hide:Bool) {
        btnEditStudy.isHidden = hide
        lblDayLeave.isHidden = hide
        lblEvaluation.isHidden = hide
    }
    
    func hideGroupMoreLbl(hide:Bool) {
        btnEditMore.isHidden = hide
        lblHobby.isHidden = hide
        lblAbility.isHidden = hide
        lblNote.isHidden = hide
    }
    
    func changeColorOfRadioButton (btnYellow:UIButton, btnWhite:UIButton) {
        btnYellow.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnYellow.clipsToBounds = true
        btnYellow.backgroundColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0)
        
        btnWhite.layer.cornerRadius = 0.5 * btnMale.bounds.size.width
        btnWhite.clipsToBounds = true
        btnWhite.backgroundColor = UIColor.white
        btnWhite.layer.borderWidth = 0.5
        btnWhite.layer.borderColor = UIColor.init(displayP3Red: CGFloat(254)/255, green: CGFloat(227)/255, blue: CGFloat(78)/255, alpha: 1.0).cgColor
    }
}
