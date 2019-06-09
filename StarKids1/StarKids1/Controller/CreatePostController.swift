//
//  CreatePostController.swift
//  StarKids1
//
//  Created by Thanh Lê on 6/9/19.
//  Copyright © 2019 Thanh Le. All rights reserved.
//

import UIKit

class CreatePostController: UIViewController {

    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var btnPicture: UIImageView!
    var rightButton:UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBar = self.navigationController?.visibleViewController?.navigationItem
        navigationBar?.title = "Tạo bài viết mới"
        navigationBar?.rightBarButtonItem = UIBarButtonItem(title: "Đăng", style: .done, target: self, action: #selector(btnDone))
        rightButton = (navigationBar?.rightBarButtonItem)!
        self.navigationItem.rightBarButtonItem = nil;
        
        txtContent.text = "Nội dung bài viết..."
        txtContent.textColor = UIColor.lightGray
        txtContent.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    @IBAction func tap_Picture(_ sender: Any) {
        
    }
    @objc func btnDone(sender: AnyObject) {
    
    }
}
extension CreatePostController:UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            self.navigationItem.rightBarButtonItem = rightButton;
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Nội dung bài viết..."
            textView.textColor = UIColor.lightGray
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}
