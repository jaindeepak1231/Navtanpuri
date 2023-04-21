//
//  ForgotPasswordVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 20/12/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordVC: UIViewController, UITextFieldDelegate, ServerCallDelegate {

    @IBOutlet var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet var btnSubmit: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TextField Placeholder
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email or Mobile", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //===============================================================================================//
    //===========================API Call Method=====================================================//
    //===============================================================================================//
   
    // MARK: - Forgot Password Api Call Method
    func CallApiForForgotPassword() {
        // init paramters Dictionary
        let myUrl = kBasePath + kForgotPass
        
        let param = ["op"    : "forgotPass",
                     "user"  : txtEmail.text!]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameForgotPass)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameForgotPass {
            
            if ((dicData["status"]) != nil) {
                app_Delegate.stopLoadingView()
                // Create the alert controller
                let strResponse = TO_BOOL(dicData["status"]);
                let strMsg = TO_STRING(dicData["message"]);
                
                if strResponse {
                    app_Delegate.stopLoadingView()
                    
                    let alertController = UIAlertController(title: "", message: strMsg, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.navigationController!.popViewController(animated: false)
                        NSLog("OK Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // Mark: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Validation function
    func isValidData() -> Bool{
        if !(txtEmail?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message: kEntetEmailMobile)
            return false;
        }
        return true
    }
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if isValidData() == false {
            return
        }
        else{
            self.view.endEditing(true)
            //Call Api For Login
            app_Delegate.startLoadingview("")
            self.CallApiForForgotPassword()
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
        
}


