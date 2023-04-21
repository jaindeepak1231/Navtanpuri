//
//  LiveEventVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 02/09/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

class LiveEventVC: UIViewController, UIWebViewDelegate {

    var strScreenFrom = ""
    var strLiveURL = ""
    @IBOutlet var webView: UIWebView!
    @IBOutlet var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Navigation Controller Changes
        self.title = "Live Event"
        self.navigationItem.hidesBackButton = false;
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = Constant.themeColor()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -80.0), for: .default)
        
        
        if strScreenFrom == "LiveTalim" {
            self.title = "Live Taalim"
        }
        
        print(strLiveURL)
        strLiveURL = app_Delegate.videoURL

        
        var url: URL?
        if self.verifyUrl(urlString: strLiveURL) {
            url = URL.init(string: strLiveURL + "?app=desktop")!
        }
        else
        {
            if self.strLiveURL.contains("www.")
            {
                url = URL.init(string: "http://\(self.strLiveURL)")
            }
            else
            {
                url = URL.init(string: "http://www.\(self.strLiveURL)")
            }
        }
        var req = URLRequest.init(url: url!)
        req.timeoutInterval = 300
        self.webView.delegate = self
        
        DispatchQueue.main.async {
            self.webView.loadRequest(req)
        }
        
        
        
        
        
        
        
        
        
        
        
        
//        webView.delegate = self
//        
//        
//        ActivityIndicator.isHidden = false
//        ActivityIndicator.startAnimating()
//        
//        if strLiveURL == "" {
//        }
//        else {
//            let request = URLRequest(url: URL(string: strLiveURL)!)
//            webView.loadRequest(request)
//        }
        
        

        
        //        //==================For Video Play In Post Detail===========================================//
//        let videoURL = URL(string: strLiveURL)!
//        
//        let playerVC = MobilePlayerViewController(contentURL: videoURL as URL)
//        playerVC.title = ""
//        playerVC.activityItems = [videoURL]
//            
//        self.present(playerVC, animated: true) {
//            playerVC.play()
//        }
        
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        ActivityIndicator.isHidden = false
        ActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ActivityIndicator.isHidden = true
        ActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ActivityIndicator.isHidden = true
        ActivityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
