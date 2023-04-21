//
//  JapViewController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 25/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import AVKit

class JapViewController: UIViewController, UITextFieldDelegate {
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    var strName = ""
    var strMobile = ""
    var strEmail = ""
    @IBOutlet weak var japCounter: UILabel!
    @IBOutlet weak var btnSendJap: UIButton!
    @IBOutlet weak var japImage: UIImageView!
    var counter = Int()
    var viewForSendDetail = ViewSendDetail()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Navigation Controller Changes
        self.title = Constants.navigationTitle.jap
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        
        // Do any additional setup after loading the view.
        let sampleTapGesture = UITapGestureRecognizer(target: self, action: #selector(JapViewController.sampleTapGestureTapped(recognizer:)))
        self.japImage.addGestureRecognizer(sampleTapGesture)
        
        japCounter.layer.cornerRadius = 3
        japCounter.clipsToBounds = true
        btnSendJap.layer.cornerRadius = 5
        btnSendJap.clipsToBounds = true
        
        let counterDefault = UserDefaults.standard.string(forKey: "Counter")
        
        if counterDefault == nil {
            counter = 1
        }else {
            japCounter.text = counterDefault
            counter = Int(counterDefault!)!
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    
    @IBAction func resetCounter() {
        showMessage(title: "Confirm", message: "Are you sure want to reset your Jap?")
    }
    @objc func sampleTapGestureTapped(recognizer: UITapGestureRecognizer) {
        
        counter += 1
        japCounter.text = counter.description
        UserDefaults.standard.set(counter, forKey: "Counter")
        UserDefaults.standard.synchronize();

    }
    func showMessage (title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action -> Void in
            UserDefaults.standard.removeObject(forKey: "Counter")
            self.japCounter.text = "0"
            self.counter = 0
            self.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    
    @IBAction func clkTobtnSendJapAtion(_ sender: UIButton) {
        DisplayViewForSendJap()
    }

    
    //===============================Set View For Send Detail==============================//
    func DisplayViewForSendJap() {
        
        viewForSendDetail = (Bundle.main.loadNibNamed("ViewSendDetail", owner: self, options: nil)?.first as? ViewSendDetail)!
        
        viewForSendDetail.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(screenWidth), height: CGFloat(screenHeight))
        
        viewForSendDetail.viewBG.layer.cornerRadius = 8
        viewForSendDetail.viewBG.layer.borderWidth = 4
        viewForSendDetail.viewBG.layer.borderColor = self.themeColor().cgColor
        
        viewForSendDetail.btnCancel.backgroundColor = self.themeColor()
        viewForSendDetail.btnSubmit.backgroundColor = self.themeColor()
        
        viewForSendDetail.txtName.text = ""
        viewForSendDetail.txtMobile.text = ""
        viewForSendDetail.txtEmail.text = ""
        
        viewForSendDetail.txtName.delegate = self
        viewForSendDetail.txtMobile.delegate = self
        viewForSendDetail.txtEmail.delegate = self
        
        viewForSendDetail.btnRemoveView.addTarget(self, action: #selector(self.clkTobtnRemoveView), for: .touchUpInside)
        
        viewForSendDetail.btnCancel.addTarget(self, action: #selector(self.clkTobtnRemoveView), for: .touchUpInside)
        
        viewForSendDetail.btnSubmit.addTarget(self, action: #selector(self.clkToBtnSubmitAction), for: .touchUpInside)
        
        self.view.addSubview(viewForSendDetail)
        self.view.bringSubviewToFront(viewForSendDetail)
    }
    
    
    
    // MARK: - Validation function
    func isValidData() -> Bool{
        
        if !(viewForSendDetail.txtName?.text!.isStringWithoutSpace())!{
            showAlert(title: "", message: "Please Enter Your Name" )
            return false;
        }
        else if !(viewForSendDetail.txtMobile?.text!.isStringWithoutSpace())!{
            showAlert(title: "", message: "Please Enter Your Mobile Number" )
            return false;
        }
        else if !((viewForSendDetail.txtMobile?.text?.characters.count)! > 9){
            showAlert(title: "", message: "Please Enter Valid Mobile Number" )
            return false;
        }
        else if !(viewForSendDetail.txtEmail?.text! == "") {
            if !(viewForSendDetail.txtEmail?.text!.isEmail())!{
                showAlert(title: "", message: "Please Enter Your Valid Email")
                return false;
            }
        }
        return true
    }
    
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == viewForSendDetail.txtName {
            textField.resignFirstResponder()
            viewForSendDetail.txtMobile.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    // Mark: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == viewForSendDetail.txtMobile {
            return checkEnglishPhoneNumberFormat(string: string, str: str)
        }
        else {
            return true
        }
    }
    
    
    // MARK: - Clk to ViewChangePassword Button Action
    @IBAction func clkTobtnRemoveView(_ sender: UIButton) {
        viewForSendDetail.removeFromSuperview()
    }
    
    @IBAction func clkToBtnSubmitAction(_ sender: UIButton) {
        //Validation
        if isValidData() == false {
            return
        }else{
            self.view.endEditing(true)
            //Call Api For Submit
            strName = viewForSendDetail.txtName.text!
            strMobile = viewForSendDetail.txtMobile.text!
            strEmail = viewForSendDetail.txtEmail.text!
            app_Delegate.startLoadingview("")
            self.CallApiForSendJap()
        }
    }
    
    
    func CallApiForSendJap() {
        
        let strings = "op=addJap&jap_name=" + strName + "&mobile=" + strMobile + "&email=" + strEmail + "&jap_count=" + japCounter.text!
        
        Alamofire.request(Connection.open.AddjapURL, method: .post, parameters: [:], encoding: "\(strings)", headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                do {
                    let json = try JSON(data: response.data!)
                
                let message = json["message"].stringValue
                self.showAlert(title: "", message: message)
                app_Delegate.stopLoadingView()
                self.viewForSendDetail.removeFromSuperview()
                }
                catch {
                    
                }
            }
        }
    }
    //=========================================================================================//
    
    //==================================Set Color============================================//
    func themeColor()->UIColor{
        return UIColor(red:22/255.0, green:24/255.0, blue:81/255.0, alpha: 1.0)
    }
    //=======================================================================================//
    func showAlert(title: NSString, message: String) {
        let obj = UIAlertView(title: title as String, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
        obj.show()
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            return true
        }
        else if str!.characters.count == 5 {
            viewForSendDetail.txtMobile.text = viewForSendDetail.txtMobile.text! + ""
            
        }else if str!.characters.count > 10{
            
            return false
        }
        
        return true
    }
}











