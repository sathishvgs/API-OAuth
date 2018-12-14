//
//  WebViewController.swift
//  AnywhereWorks
//
//  Created by user on 5/24/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var code: String = ""
    var accessToken: String = ""
    let userDefaults = UserDefaults()
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "")
        
        
        let request = URLRequest(url: url!)
        webView.loadRequest(request as URLRequest)
        invokeActivityIndicator()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        setNavigationBar()
        
        
    }
    
    
    
    public func webViewDidStartLoad(_ webView: UIWebView){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView){
        
        //To get the Code alone from the request
        activityIndicator.stopAnimating()
        guard let htmlTitle = webView.stringByEvaluatingJavaScript(from: "document.title") else {
            return
        }
        print(htmlTitle)
        
        if let data = htmlTitle.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
                for (key,value) in json!{
                    
                    print("The key is \(key) and value is \(value)")
                    
                    if key == "code"{
                        code = value as! String
                        print(code)
                    }
                }
                
                requestAccessToken()
                
            } catch {
                print("Something went wrong")
            }
        }
    }
    
    
    func requestAccessToken(){
        
        
        Alamofire.request("", method: .post, parameters: [
            "client_id"    : "",
            "client_secret": "",
            "redirect_uri" : "" ,
            "code" : code ,
            "grant_type": "authorization_code" ], encoding: URLEncoding.httpBody, headers: ["Content_Type":"application/x-www-form-urlencoded"]).responseJSON{ (response) in
                
                switch(response.result) {
                    
                case .success(_):
                    
                    if let data = response.result.value{
                        
                        print("THE SUCCESS \(data)")
                        
                        //Converting JSON into DICTIONARY(Key,Value)
                        let json = JSON(data)
                        
                        //converting JSON into String
                        self.accessToken = json["access_token"].stringValue
                        
                        // storing the accesstoken in userDefaults
                        self.userDefaults.set(self.accessToken, forKey: "AccessToken")
                        
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error!)
                    break
                }
        }
    }
    
    
    
    func setNavigationBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        let navItem = UINavigationItem(title: "AnywhereWorks")
        let closeItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancel))
        navItem.leftBarButtonItem = closeItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    func invokeActivityIndicator(){
        
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = self.view.center;
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func cancel() {
        
        dismiss(animated: true, completion: nil)
    }
    
}
