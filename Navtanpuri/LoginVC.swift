//
//  LoginVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 20/12/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
let kConstantObj = kConstant()

class LoginVC: UIViewController, UITextFieldDelegate, ServerCallDelegate {

    var sreScreenFrom = ""
    var dictSecDetail: NSDictionary = [:]
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var txtEmail_Mobile: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    

//==================================================================================================//
//=====================================View DidLoad=================================================//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnLogin.layer.cornerRadius = 3
        btnLogin.layer.masksToBounds = false
        btnLogin.layer.shadowColor = UIColor.black.cgColor
        btnLogin.layer.shadowOpacity = 2.0
        btnLogin.layer.shadowOffset = CGSize(width: -1, height: 1)
        btnLogin.layer.shadowRadius = 2
        
        //Set TextFieldPlaceHolder
        let strMobile = NSAttributedString(string: "Email or Mobile", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtEmail_Mobile.attributedPlaceholder! = strMobile
        
        let strPassword = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtPassword.attributedPlaceholder! = strPassword
        //===================================================================//
    }
    
    //===============================================================================================//
    //===========================API Call Method=====================================================//
    //===============================================================================================//
    // MARK: - Login Api Call Method
    func CallApiForLogin() {
        // init paramters Dictionary
        let myUrl = kBasePath + kLogin
        
        let param = ["op"     : "login",
                     "user"   : txtEmail_Mobile.text!,
                     "upass"  : txtPassword.text!]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameLogin)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameLogin {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    if let resData = resposeObject["data"] as? [[String:Any]], !resData.isEmpty {
                        
                        let UserID = resData[0]["uid"]
                        let strEmail = resData[0]["email"]
                        let StrMobile = resData[0]["mobile"]
                        let StrFullName = resData[0]["uname"]
                        
                        _userDefault.set(strEmail, forKey: "email")
                        _userDefault.set(UserID, forKey: "user_id")
                        _userDefault.set(true, forKey: "login_flag")
                        _userDefault.set(StrMobile, forKey: "mobile")
                        _userDefault.set(StrFullName, forKey: "user_name")
                        
                        
                        if sreScreenFrom == "TalimVideo" {
                            let objVideo = self.storyboard?.instantiateViewController(withIdentifier: "TalimVideosListVC") as! TalimVideosListVC
                            objVideo.dictDetail = dictSecDetail
                            self.navigationController?.pushViewController(objVideo, animated: true)
                        }
                        else {
                            app_Delegate.DisplayViewControllerProcess()
                        }
                        
                    }
                    
                    
                }
                else {
                    Constant.showAlert(title: "", message: strMsg)
                    return
                }
            }
            else {
                let strerrMsg = TO_STRING(dicData["error"])
                Constant.showAlert(title: "", message:strerrMsg)
            }
        }
        app_Delegate.stopLoadingView()
    }
    
    
    // MARK: - Server Failed Delegate
    func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        app_Delegate.stopLoadingView()
        Constant.showAlert(title: "", message:errorObject)
    }
    //===============================================================================================//
    //===============================================================================================//
    //===============================================================================================//
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail_Mobile {
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Validation function
    func isValidData() -> Bool{
        if !(txtEmail_Mobile?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message: kEntetEmailMobile)
            return false;
        }
        else if !(txtPassword?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetPassword )
            return false;
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Buttton Action Method
    @IBAction func btnClkToRegister(_ sender: Any) {
        let objRegister = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        if sreScreenFrom == "TalimVideo" {
            objRegister.sreScreenFrom = "TalimVideo"
            objRegister.dictRegDetail = dictSecDetail
        }
        self.navigationController?.pushViewController(objRegister, animated: true)
    }
    
    @IBAction func btnForgotPassTaped(_ sender: UIButton) {
        let objStoreLogin = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(objStoreLogin, animated: true)
    }
    
    @IBAction func btnClkToLogin(_ sender: Any) {
        if isValidData() == false {
            return
        }
        else{
            self.view.endEditing(true)
            //Call Api For Login
            app_Delegate.startLoadingview("")
            self.CallApiForLogin()
            
        }
    }
    
    @IBAction func btnClkToBack(_ sender: Any) {
        if sreScreenFrom == "TalimVideo" {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            kConstantObj.SetIntialMainViewController("MainViewController")
        }
    }
}




