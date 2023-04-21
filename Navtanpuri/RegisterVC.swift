//
//  RegisterVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 20/12/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ServerCallDelegate {
    
    var strAddress = ""
    var sreScreenFrom = ""
    var arrMain = [String]()
    var dictRegDetail: NSDictionary = [:]
    @IBOutlet var tblView: UITableView!
    @IBOutlet var txtFullName: SkyFloatingLabelTextField!
    @IBOutlet var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtCity: SkyFloatingLabelTextField!
    @IBOutlet var txtState: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet var txtConfirmPassword: SkyFloatingLabelTextField!
    @IBOutlet var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraint_ViewBottomHeight: NSLayoutConstraint!
    @IBOutlet var constraint_bottom_Constant: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TextField Placeholder
        txtFullName.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtMobile.attributedPlaceholder = NSAttributedString(string: "Mobile", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtCity.attributedPlaceholder = NSAttributedString(string: "City", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtState.attributedPlaceholder = NSAttributedString(string: "State", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //============================================================================================//
        // Add a bottomBorder.
        tblView.layer.masksToBounds = false
        tblView.layer.shadowColor = UIColor.black.cgColor
        tblView.layer.shadowOpacity = 2.5
        tblView.layer.shadowOffset = CGSize(width: -1, height: 1)
        tblView.layer.shadowRadius = 2
        //============================================================================================//
        
        tblView.isHidden = true
        
        //For Search
        txtCity.delegate = self
        txtCity.addTarget(self, action: #selector(self.txtSearchCityData), for: .editingChanged)
        
        txtState.delegate = self
        txtState.addTarget(self, action: #selector(self.txtSearchStateData), for: .editingChanged)
        
        tblView.register(UINib(nibName: "CityStateTableCell", bundle: nil), forCellReuseIdentifier: "CityStateTableCell")
        
        tblView.estimatedRowHeight = 60.0
        tblView.rowHeight = UITableView.automaticDimension
    }
    
    
    @objc func txtSearchCityData() {
        if (txtCity.text == "") {
            tblView.isHidden = true
        }
        else {
            constraint_bottom_Constant.constant = 0
            let str: String = txtCity.text!
            methodSearch(str)
        }
    }
    
    func methodSearch(_ searchText: String) {
        arrMain.removeAll()
        strAddress = "City"
        let Predicate = NSPredicate(format: "SELF contains[c] %@", searchText)
        print("\(Predicate)")
        for i in 0..<app_Delegate.arrCity.count {
            let strCity = app_Delegate.arrCity[i]
            if (strCity as NSString).range(of: txtCity.text!, options: .caseInsensitive).location != NSNotFound {
                arrMain.append(strCity)
                tblView.isHidden = false
                tblView.reloadData()
            }
        }
    }
    
    //===============STATE======================================//
    @objc func txtSearchStateData() {
        if (txtState.text == "") {
            tblView.isHidden = true
        }
        else {
            constraint_bottom_Constant.constant = 60
            let str: String = txtState.text!
            methodStateSearch(str)
        }
    }
    
    func methodStateSearch(_ searchText: String) {
        arrMain.removeAll()
        strAddress = "State"
        let Predicate = NSPredicate(format: "SELF contains[c] %@", searchText)
        print("\(Predicate)")
        for i in 0..<app_Delegate.arrState.count {
            let strState = app_Delegate.arrState[i]
            if (strState as NSString).range(of: txtState.text!, options: .caseInsensitive).location != NSNotFound {
                arrMain.append(strState)
                tblView.isHidden = false
                tblView.reloadData()
            }
        }
    }
    //====================================================================//
    //====================================================================//
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - WebView Delegate Method
    func webViewDidFinishLoad(_ webView: UIWebView) {
        app_Delegate.stopLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //=====================================================================================//
    //=====================================================================================//
    //=====================================================================================//
    // MARK: - Register Api Call Method
    func CallApiForRegisterUser() {
        
        // init paramters Dictionary
        let myUrl = kBasePath + kRegister
        
        let param = ["op"         : "register",
                     "uname"      : txtFullName.text!,
                     "upassword"  : txtPassword.text!,
                     "mobile"     : txtMobile.text!,
                     "email"      : txtEmail.text!,
                     "city"       : txtCity.text!,
                     "state"      : txtState.text!]
        
        print(myUrl, param)
        
        ServerCall.sharedInstance.requestWithUrlAndParameters(.POST, urlString: myUrl, parameters: param as [String : AnyObject], delegate: self, name: .serverCallNameRegister)
    }
    
    
    // MARK: - Server Call Delegate
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        print(resposeObject)
        var dicData = resposeObject as! [AnyHashable : Any]
        
        if name == ServerCallName.serverCallNameRegister {
            
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
                            objVideo.dictDetail = dictRegDetail
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
    
    
    //=====================================================================================//
    //=====================================================================================//
    //=====================================================================================//
    //=====================================================================================//
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrMain.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityStateTableCell", for: indexPath as IndexPath) as! CityStateTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.lblTitle.text = arrMain[indexPath.row]
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if strAddress == "City" {
            txtCity.text = arrMain[indexPath.row]
        }
        if strAddress == "State" {
            txtState.text = arrMain[indexPath.row]
        }
        tblView.isHidden = true
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == txtMobile{
            return checkEnglishPhoneNumberFormat(string: string, str: str)
        }
        else {
            return true
        }
    }
    
    // Mark: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tblView.isHidden = true
        if textField == txtFullName {
            textField.resignFirstResponder()
            txtEmail.becomeFirstResponder()
            return false
        }
        if textField == txtEmail {
            textField.resignFirstResponder()
            txtMobile.becomeFirstResponder()
            return false
        }
        if textField == txtMobile {
            textField.resignFirstResponder()
            txtCity.becomeFirstResponder()
            return false
        }
        if textField == txtCity {
            textField.resignFirstResponder()
            txtState.becomeFirstResponder()
            return false
        }
        if textField == txtState {
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
            return false
        }
        if textField == txtPassword {
            textField.resignFirstResponder()
            txtConfirmPassword.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tblView.isHidden = true
    }
    
    
    // MARK: - Validation function
    func isValidData() -> Bool{
        if !(txtFullName?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetFullName)
            return false;
        }
        else if !(txtEmail?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetEmail)
            return false;
        }
        else if !(txtEmail?.text!.isEmail())!{
            Constant.showAlert(title: "", message:kEntetValidEmail)
            return false;
        }
        else if !(txtMobile?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetMobile )
            return false;
        }
        else if !((txtMobile?.text?.characters.count)! > 9){
            Constant.showAlert(title: "", message:kEntetValidMobile )
            return false;
        }
        else if !(txtCity?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetCity)
            return false;
        }
        else if !(txtState?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEnterState)
            return false;
        }
        else if !(txtPassword?.text!.isStringWithoutSpace())!{
            Constant.showAlert(title: "", message:kEntetPassword )
            return false;
        }
        else if !((txtPassword?.text?.characters.count)! > 5){
            Constant.showAlert(title: "", message:kEntetMinCharacterPassword )
            return false;
        }
        else if !(txtPassword?.text! == txtConfirmPassword.text!) {
            Constant.showAlert(title: "", message:kCooectConfirmPass )
            return false;
        }
        
        return true
    }
    
    
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        if isValidData() == false {
            return
        }
        else{
            self.view.endEditing(true)
            //Call Api For Login
            app_Delegate.startLoadingview("")
            self.CallApiForRegisterUser()
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            return true
        }
        else if str!.characters.count == 5{
            txtMobile.text = txtMobile.text! + ""
            
        }else if str!.characters.count > 10{
            
            return false
        }
        
        return true
    }
    
    
    
}














