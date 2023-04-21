//
//  ShreeTartamSagarVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 10/09/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class ShreeTartamSagarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var arrGanth = NSMutableArray()
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Navigation Controller Changes
        self.title = "Shree Tartam Sagar"
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

        
        arrGanth.removeAllObjects()
        
        let dic1 = ["name" : "Shri Raas",
                    "pdf"  : "http://www.shritartamsagar.org/new_pdf/hindi/1_Raas.pdf"]
        arrGanth.add(dic1)
        
        let dic2 = ["name" : "Shri Prakash",
                    "pdf"  : "http://www.shritartamsagar.org/new_pdf/hindi/2_PrakashGujarati.pdf"]
        arrGanth.add(dic2)
        
       let dic3 = ["name" : "Shri Shatritu",
                   "pdf"  :  "http://www.shritartamsagar.org/new_pdf/hindi/3_Shatritu.pdf"]
        arrGanth.add(dic3)
        
       let dic4 = ["name" : "Shri Kalash",
                   "pdf"  :  "http://www.shritartamsagar.org/new_pdf/hindi/4_Kalash_Guj.pdf"]
        arrGanth.add(dic4)
        
       let dic5 = ["name" : "Shri Prakash-Hindi" ,
                   "pdf"  :  "http://www.shritartamsagar.org/new_pdf/hindi/5_Prakash Hindi.pdf"]
        arrGanth.add(dic5)
        
       let dic6 = ["name" : "Shri Kalash-Hindi",
                   "pdf"  :  "http://www.shritartamsagar.org/new_pdf/hindi/6_Kalash Hindi.pdf"]
        arrGanth.add(dic6)
        
       let dic7 = ["name" : "Shri Sanandh",
                   "pdf"  :  "http://www.shritartamsagar.org/new_pdf/hindi/7_Sanand.pdf"]
        arrGanth.add(dic7)
        
       let dic8 = ["name" : "Shri Kirantan",
                   "pdf"  : "http://www.shritartamsagar.org/new_pdf/hindi/8_Kirantan.pdf"]
        arrGanth.add(dic8)
        
       let dic9 = ["name" : "Shri Khulasa",
                   "pdf"  :  "http://www.shritartamsagar.org/new_pdf/hindi/9_Khulasa.pdf"]
        arrGanth.add(dic9)
        
       let dic10 = ["name" : "Shri Khilvat",
                    "pdf"  : "http://www.shritartamsagar.org/new_pdf/hindi/10_Khilwat.pdf"]
        arrGanth.add(dic10)
        
       let dic11 = ["name" : "Shri Prarikrama",
                    "pdf" : "http://www.shritartamsagar.org/new_pdf/hindi/11_Parikrama.pdf"]
        arrGanth.add(dic11)
        
       let dic12 = ["name" : "Shri Sagar",
                    "pdf" : "http://www.shritartamsagar.org/new_pdf/hindi/12_Sagar.pdf"]
        arrGanth.add(dic12)
        
       let dic13 = ["name" : "Shri Singar",
                    "pdf" : "http://www.shritartamsagar.org/new_pdf/hindi/13_Singar.pdf"]
        arrGanth.add(dic13)
        
       let dic14 = ["name" : "Shri Sindhi",
                    "pdf" : "http://www.shritartamsagar.org/new_pdf/hindi/14_Sindhi.pdf"]
        arrGanth.add(dic14)
        
       let dic15 = ["name" : "Shri Maarfat Sagar",
                    "pdf" : "http://www.shritartamsagar.org/new_pdf/hindi/15_Marfat.pdf"]
        arrGanth.add(dic15)
        
       let dic16 = ["name" : "Shri Kayamat Nama-Chhota",
                    "pdf" : "http://www.shritartamsagar.org/new_pdf/hindi/16_Kyamat_Chhota.pdf"]
        arrGanth.add(dic16)
        
       let dic17 = ["name" : "Shri Kayamat Nama-Bada",
                    "pdf" :  "http://www.shritartamsagar.org/new_pdf/hindi/17_Kyamat_Bada.pdf"]
        arrGanth.add(dic17)
        
        tblView.reloadData()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Shree Tartam Sagar"
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
        return arrGanth.count
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
        dict = arrGanth.object(at:indexPath.row) as! NSDictionary
        
        let strUserName = dict["name"] as! String
        cell.lblGranthName.text = strUserName
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // return UITableViewAutomaticDimension
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict: NSDictionary = [:]
        dict = arrGanth.object(at:indexPath.row) as! NSDictionary
        
        self.title = ""
        let strTite = dict["name"] as! String
        let strpdfLink = dict["pdf"] as! String
        let objShowPdf = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewerVC") as! PDFViewerVC
        objShowPdf.strTitle = strTite
        objShowPdf.strLink = strpdfLink
        self.navigationController?.pushViewController(objShowPdf, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    
}


