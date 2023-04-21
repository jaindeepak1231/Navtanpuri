//
//  EGurukulamVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 06/12/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class EGurukulamVC: UIViewController {

    @IBOutlet var viewFirst: UIView!
    @IBOutlet var viewSecond: UIView!
    @IBOutlet var lblEvents: UILabel!
    @IBOutlet var lblVideos: UILabel!
    @IBOutlet var btnEvents: UIButton!
    @IBOutlet var btnVideos: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Navigation Controller Changes
        self.title = "E-Gurukulam"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
    }

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
    
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }

    // MARK: - Button Action Event
    @IBAction func btnEventsTapped(_ sender: UIButton) {
        let objLive = self.storyboard?.instantiateViewController(withIdentifier: "LiveEventVC") as! LiveEventVC
        objLive.strScreenFrom = "LiveTalim"
        self.navigationController?.pushViewController(objLive, animated: true)
    }
    
    
    @IBAction func btnVideosTapped(_ sender: UIButton) {
        let objVideos = self.storyboard?.instantiateViewController(withIdentifier: "TalimVideosVC") as! TalimVideosVC
        self.navigationController?.pushViewController(objVideos, animated: true)
    }
}
