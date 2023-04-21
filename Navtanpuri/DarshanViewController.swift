//
//  DarshanViewController.swift
//  Navtanpuri
//
//  Created by Vivek Goswami on 11/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class DarshanViewController: UIViewController {

    @IBOutlet weak var liveWebView : UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Controller Changes
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        self.title = Constants.navigationTitle.darshan
        liveWebView?.isOpaque = false
        liveWebView?.backgroundColor = UIColor.clear
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let url = URL(string: Connection.open.liveDarshan) {
            let request = URLRequest(url: url)
                liveWebView?.loadRequest(request)
            }
    }
    @IBAction func back (){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }

}
