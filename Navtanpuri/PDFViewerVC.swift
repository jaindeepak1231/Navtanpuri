//
//  PDFViewerVC.swift
//  Navtanpuri
//
//  Created by deepak jain on 10/09/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit
import MobileCoreServices

class PDFViewerVC: UIViewController, UIWebViewDelegate {

    var strLink = ""
    var strTitle = ""
    @IBOutlet var webView: UIWebView!
    @IBOutlet var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = strTitle
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        ActivityIndicator.isHidden = false
        ActivityIndicator.startAnimating()
        
        webView.delegate = self
        let webURL = strLink //"http://docs.google.com/viewer?embedded=true&url=" + strLink
        if let escapedString = webURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {

            let request = URLRequest(url: URL(string: escapedString)!)
            webView.loadRequest(request)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ActivityIndicator.isHidden = true
        ActivityIndicator.stopAnimating()
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


    
    
