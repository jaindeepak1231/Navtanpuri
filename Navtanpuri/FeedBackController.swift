//
//  FeedBackController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 12/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FeedBackController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Controller Changes
        self.title = Constants.navigationTitle.feedback
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        
    }
    @IBAction func feedBackSubmit() {
        
        let strings = NSString(format:"op=addfeedback&ar_name=%@&mobile=%@&email=%@&msg=%@",nameField.text!,mobileField.text!,emailField.text!,commentField.text!)
        
        Alamofire.request(Connection.open.feedback, method: .post, parameters: [:], encoding: "\(strings)", headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
    
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                do {
                    let json = try JSON(data: response.data!)
                    let status = json["status"].numberValue
                    
                    if status == 0 {
                        let message = json["message"].stringValue
                        self.showMessage(title : "Error", message: message)
                    } else {
                        self.showMessage(title: "Success", message: "Your feedback has been successfully submited")
                    }
                }
                catch{
                }
                
            }
        }
    }
    func showMessage (title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
}
