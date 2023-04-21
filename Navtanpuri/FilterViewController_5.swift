//
//  FilterViewController_5.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 04/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol DataSentDelegateFor5s {
    func userDidEnterDataFor5s(country : String, state : String, district : String, accommodation : String, food : String)
}

class FilterViewController_5: UIViewController,UITextFieldDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var districtTxt: UITextField!
    let vc = MandirDirectoryController()
    @IBOutlet weak var districtPickup: UIPickerView!
    @IBOutlet weak var statePickup: UIPickerView!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var india_btn: UIButton!
    @IBOutlet weak var all_btn: UIButton!
    @IBOutlet weak var other_btn: UIButton!
    
    @IBOutlet weak var acc_na: UIButton!
    @IBOutlet weak var acc_no: UIButton!
    @IBOutlet weak var aco_yes: UIButton!
    
    @IBOutlet weak var food_na: UIButton!
    @IBOutlet weak var food_no: UIButton!
    @IBOutlet weak var food_yes: UIButton!
    
    var country : String?
    var accommodation : String?
    var food : String?
    var state : String?
    var district : String?
    var states = [String]()
    var districtData = [String]()
    var stateData = [String]()
    var delegate : DataSentDelegateFor5s? = nil
    
    var age = ["10-20","30-40","10-20"]
    var gender = ["male","female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        state = "Gujarat"
        //        district = "Rajkot"
        country = "india"
        accommodation = "NA"
        food = "NA"
        openService(string: Connection.stateIndia, country: country!)
        vc.test = "Test"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelCliked(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func radioClick(sender : UIButton) {
        
        if sender.tag == 1 {
            country = "india"
            print("india")
            india_btn.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
            other_btn.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            all_btn.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            openService(string: Connection.stateIndia, country: country!)
            
        } else if sender.tag == 2 {
            country = "uk"
            print("Other")
            india_btn.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            other_btn.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
            all_btn.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            openService(string: Connection.stateUk, country: country!)
        }else {
            country = "all"
            print("All")
            india_btn.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            other_btn.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            all_btn.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
            openService(string: Connection.stateOther, country: country!)
        }
    }
    @IBAction func acco_radioClick(sender : UIButton) {
        
        if sender.tag == 1 {
            print("india")
            accommodation = "yes"
            aco_yes.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
            acc_no.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            acc_na.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
        } else if sender.tag == 2 {
            print("Other")
            accommodation = "no"
            aco_yes.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            acc_no.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
            acc_na.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
        }else {
            print("All")
            accommodation = "NA"
            aco_yes.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            acc_no.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            acc_na.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
        }
    }
    @IBAction func food_radioClick(sender : UIButton) {
        
        if sender.tag == 1 {
            print("india")
            food = "yes"
            food_yes.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
            food_no.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            food_na.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
        } else if sender.tag == 2 {
            print("Other")
            food = "no"
            food_yes.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            food_no.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
            food_na.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
        }else {
            print("All")
            food = "NA"
            food_yes.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            food_no.setBackgroundImage(UIImage(named: "radiobox-blank(1)"), for: .normal)
            food_na.setBackgroundImage(UIImage(named: "radiobox-marked"), for: .normal)
        }
    }
    @IBAction func applyClicked (){
        
        if delegate != nil {
            delegate?.userDidEnterDataFor5s(country: country!, state: state!, district: district!, accommodation: accommodation!, food: food!)
            dismiss(animated: true, completion: nil)
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows : Int = self.stateData.count
        if pickerView == self.districtPickup {
            countRows =  self.districtData.count
        }
        return countRows
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.statePickup {
            let titleRow = self.self.stateData[row]
            return titleRow
        }
        else if pickerView == self.districtPickup {
            let titleRow = self.districtData[row]
            return titleRow
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == statePickup {
            stateTxt.text = self.stateData[row]
            districtTxt.text = "District"
            statePickup.isHidden = true
            openServiceDistrict(string: self.stateData[row])
            state = self.stateData[row]
            print("State : \(self.stateData[row])")
        }
        else if pickerView == districtPickup {
            districtTxt.text = districtData[row]
            districtPickup.isHidden = true
            district = self.districtData[row]
            print("District : \(self.districtData[row])")
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == stateTxt {
            statePickup.isHidden = false
            textField.endEditing(true)
            //            print("\(self.stateTxt.text)")
        }
        else if textField == districtTxt {
            districtPickup.isHidden = false
            textField.endEditing(true)
            //            print("\(self.districtTxt.text)")
        }
        
        
    }
    func openService(string : String, country : String) {
        
        self.stateData = []
        
        Alamofire.request(Connection.open.mandirDirectory, method: .post, parameters: [:], encoding: string, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                do {
                    let json = try JSON(data: response.data!)
                    
                    print(json["States"])
                    for i in 0...json["date"]["States"].arrayValue.count{
                        let districtStr = json["date"]["States"][i].stringValue
                        
                        if country == "india"{
                            self.stateData.append(districtStr)
                        } else if country == "uk"{
                            self.stateData.append(districtStr)
                        }else {
                            self.stateData.append(districtStr)
                        }
                    }
                    self.stateData.removeLast()
                    print(self.stateData)
                    
                    self.statePickup.reloadAllComponents()
                }
                catch {
                    
                }
            }
        }
    }
    func openServiceDistrict(string : String) {
        
        self.districtData = []
        
        Alamofire.request(Connection.open.mandirDirectory, method: .post, parameters: [:], encoding: "op=changeFilterCountry&doFor=District&vSearchQuery=\(string)", headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                do {
                    let json = try JSON(data: response.data!)
                
                for i in 0...json["date"]["District"].arrayValue.count{
                    
                    let districtStr = json["date"]["District"][i].stringValue
                    self.districtData.append(districtStr)
                }
                self.districtData.removeLast()
                print(self.districtData)
                self.districtPickup.reloadAllComponents()
                }
                catch {
                    
                }
            }
        }
    }
    
    
}
