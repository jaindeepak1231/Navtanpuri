//
//  SideMenuVC.swift
//  SideMenuSwiftDemo
//
//  Created by Kiran Patel on 1/2/16.
//  Copyright © 2016  SOTSYS175. All rights reserved.
//

import Foundation
import UIKit
class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var aData = NSArray()
    var aImageData = NSArray()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var imgBusinessLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("willApear")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SetUserNameEmailAndSideMenuOptionsArray), name: NSNotification.Name(rawValue: "SIDEMENURELOAD"), object: nil)
        self.SetUserNameEmailAndSideMenuOptionsArray()
        
    }
    
    
    @objc func SetUserNameEmailAndSideMenuOptionsArray() {
        if _userDefault.string(forKey: "email") != nil {
            lblEmail.text = _userDefault.string(forKey: "email")
        }
        else {
            lblEmail.text = ""
        }
        
        if _userDefault.string(forKey: "user_name") != nil {
            lblName.text = _userDefault.string(forKey: "user_name")
        }
        else {
            lblName.text = ""
        }
        
        let Business_Logo = ""
        if Business_Logo == "" {
            imgBusinessLogo.image = #imageLiteral(resourceName: "user")
        }
        
        if _userDefault.bool(forKey: "login_flag") == true {
            imgBusinessLogo.isHidden = false
            aData = ["Home","My Profile", "Change Password", "Notifications","Log Out"]
            aImageData = ["home", "profile", "profile", "logout"]
        }
        else {
            aData = ["Home", "Notifications","Login"]
            aImageData = ["home", "login"]
            imgBusinessLogo.isHidden = true
        }
        
        
        self.tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(
            withIdentifier: "kCell", for: indexPath)
        let aLabel : UILabel = aCell.viewWithTag(10) as! UILabel
        aLabel.text = aData[indexPath.row] as? String
        
        let aImage : UIImageView = aCell.viewWithTag(20) as! UIImageView
        if aLabel.text == "Home" {
            aImage.image = #imageLiteral(resourceName: "home")
        }
        else if aLabel.text == "My Profile" {
            aImage.image = #imageLiteral(resourceName: "profile")
        }
        else if aLabel.text == "Change Password" {
            aImage.image = #imageLiteral(resourceName: "profile")
        }
        else if aLabel.text == "Log Out" {
            aImage.image = #imageLiteral(resourceName: "logout")
        }
        else if aLabel.text == "Notifications" {
            aImage.image = #imageLiteral(resourceName: "notification")
        }
        else if aLabel.text == "Login" {
            aImage.image = #imageLiteral(resourceName: "login")
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            kConstantObj.SetIntialMainViewController("MainViewController") // firstVC is storyboard ID
        }else if indexPath.row == 1 {
            if _userDefault.bool(forKey: "login_flag") == true {
                kConstantObj.SetIntialMainViewController("MyProfileVC")
            }
            else {
                kConstantObj.SetIntialMainViewController("NotificationVC")
            }
        }
        else if indexPath.row == 2 {
            if _userDefault.bool(forKey: "login_flag") == true {
                kConstantObj.SetIntialMainViewController("MainViewController")
                NotificationCenter.default.post(name: Notification.Name("ChangePassword"), object: nil)
            }
            else {
                kConstantObj.SetIntialMainViewController("LoginVC")
            }
        }else if indexPath.row == 3 {
            kConstantObj.SetIntialMainViewController("NotificationVC")
        }
        else if indexPath.row == 4 {
            _userDefault.set(false, forKey: "login_flag")
            kConstantObj.SetIntialMainViewController("MainViewController")
            //kConstantObj.SetMainViewController("LoginVC")
        }
    }
    
    
    
    @IBAction func BtnProfileClk(_ sender: UIButton) {
        kConstantObj.SetIntialMainViewController("MyProfileVC")
    }
}
