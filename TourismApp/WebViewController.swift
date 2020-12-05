//
//  WebViewController.swift
//  TourismApp
//
//  Created by ZILAN OUYANG on 2020-12-04.
//  Copyright © 2020 ZILAN OUYANG. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webLink:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let link = self.webLink else {
            print("web link is null")
            return
        }
        let web = link
        let url = NSURL(string: web)
        let request = NSURLRequest(url: url! as URL)// init and load request in webview.
        let webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self as? WKNavigationDelegate
        webView.load(request as URLRequest)
        self.view.addSubview(webView)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
