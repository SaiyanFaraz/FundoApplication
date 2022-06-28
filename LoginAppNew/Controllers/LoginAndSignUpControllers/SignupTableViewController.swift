//
//  SignupTableViewController.swift
//  LoginAppNew
//
//  Created by Shabuddin on 12/05/22.
//

import UIKit

class SignupTableViewController: UITableViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer: )))
//        imgProfile.isUserInteractionEnabled = true // This step can be done through Story board as well
        imgProfile.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        openGallery()
    }

   
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        validationCode()
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.height
//    }
}

extension SignupTableViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            imgProfile.image = img
        }
        dismiss(animated: true)
    }
}

extension SignupTableViewController {
    fileprivate func validationCode() {
        let imgSystem = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        
        if imgProfile.image?.pngData() != imgSystem?.pngData(){
            if let email = txtEmail.text, let password = txtPassword.text, let username = txtUsername.text, let conPassword = txtConPassword.text{
                if !email.validateEmailId(){
                    print("Email not valid")
                    openAlert(title: "Alert", message: "Email Address Not valid", actionTitles: ["Okay"], actionStyle: [.default], actions: [{_ in print("OK Clicked") }], vc: self)
                } else if !password.validatePassword(){
                    print("password not valid")
                    openAlert(title: "Alert", message: "Password Not valid", actionTitles: ["Okay"], actionStyle: [.default], actions: [{_ in print("OK Clicked") }], vc: self)
                } else if username == ""{
                  print("Please enter user name")
                    openAlert(title: "Alert", message: "Please enter a user name", actionTitles: ["Okay"], actionStyle: [.default], actions: [{_ in print("OK Clicked") }], vc: self)
                } else{
                    if password == conPassword {
                        // Auth statement
                        AuthService.shared.createUser(email: txtEmail.text!, password: txtPassword.text!) { result, error in
                            guard let user = result, error == nil else{
                                print("Error\(String(describing: error?.localizedDescription))")
                                
                                return
                            }
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        print("Password does not match")
                        openAlert(title: "Alert", message: "Make sure that the Password matches", actionTitles: ["Okay"], actionStyle: [.default], actions: [{_ in print("OK Clicked") }], vc: self)
                    }
                }
                
            } else {
                print("Please check the details entered")
                openAlert(title: "Alert", message: "Please enter complete details", actionTitles: ["Okay"], actionStyle: [.default], actions: [{_ in print("OK Clicked") }], vc: self)
            }
        } else {
            openAlert(title: "Alert", message: "Please select a Profile picture", actionTitles: ["Okay"], actionStyle: [.default], actions: [{_ in print("OK Clicked") }], vc: self)
        }

    }
}

