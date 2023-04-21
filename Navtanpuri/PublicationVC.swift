//
//  PublicationVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 06/02/2561 BE.
//  Copyright © 2561 BE TriSoft Developers. All rights reserved.
//

import UIKit

class PublicationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrPublicationData = NSMutableArray()
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Navigation Controller Changes
        self.title = "Publication"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        self.tblView.estimatedRowHeight = 60.0
        self.tblView.rowHeight = UITableView.automaticDimension
        
        //Table Cell Register
        tblView.register(UINib(nibName: "GranthTableCell", bundle: nil), forCellReuseIdentifier: "GranthTableCell")
        
        
        arrPublicationData.removeAllObjects()
        
        let dic1 = ["name" : "Krishna Pranami Patrika"]
        arrPublicationData.add(dic1)
        
        tblView.reloadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Publication"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrPublicationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GranthTableCell", for: indexPath as IndexPath) as! GranthTableCell
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.viewBg.layer.cornerRadius = 8
        cell.viewBg.layer.masksToBounds = false
        cell.viewBg.layer.shadowColor = UIColor.black.cgColor
        cell.viewBg.layer.shadowOpacity = 2.0
        cell.viewBg.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.viewBg.layer.shadowRadius = 2
        
        
        var dict: NSDictionary = [:]
        dict = arrPublicationData.object(at:indexPath.row) as! NSDictionary
        
        let strUserName = dict["name"] as! String
        cell.lblGranthName.text = strUserName
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // return UITableViewAutomaticDimension
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objPatrika = self.storyboard?.instantiateViewController(withIdentifier: "PatrikaListVC") as! PatrikaListVC
        self.navigationController?.pushViewController(objPatrika, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

    
}


