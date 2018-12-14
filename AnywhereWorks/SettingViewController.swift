//
//  SettingViewController.swift
//  AnywhereWorks
//
//  Created by user on 5/25/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingViewController: UIViewController {

    
    var userProfile = ""
    let userDefaults = UserDefaults()
    var firstName:String = ""
    var lastName: String = ""
    var mailID: String = ""
    
    
    
    @IBOutlet weak var displayUserInformation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.title = "Setting"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let accessToken = userDefaults.string(forKey: "AccessToken")  else {
            return
        }
        
        
        let headers = ["Authorization" : "Bearer \(accessToken)"]
        
        
        Alamofire.request("", method: .get, headers: headers)
            .responseJSON { (response) in
                
                
                switch(response.result) {
                    
                case .success(_):
                    
                    if let userData = response.result.value{
                        
                        print("THE SUCCESS \(userData)")
                        
                        let json = JSON(userData)
                        print("JSON format is \(json)")
                        
                        

                        
                        if let data = userData as? [String: Any] {
                            
                            if let user = data["data"] as? [String : Any] {
                                
                                if let userValue = user["user"] as? [String : Any] {
                                    
                                    print("The Login  is \(String(describing: userValue["login"]))")
                                    print("The FirstName is \(String(describing: userValue["firstName"]))")
                                    self.mailID = userValue["login"] as! String
                                    print (self.mailID)
                                    
                                }
                            }
                        }
                        
                        
                        //let accid = json["data"]["user"]["accountId"].stringValue
                        
                        
                        
                        //user["firstName"]
                        //user["id"]
                        
                        
        
                      /*  let firstNamePath = ["data","user","firstName"]
                        let lastNamePath = ["data","user","lastName"]
                        let emailIDPath = ["data","user","login"]
                        
                        self.firstName = json[firstNamePath ].stringValue
                        self.lastName = json[lastNamePath].stringValue
                        self.mailID = json[emailIDPath].stringValue
                    
                        print(" First Name: \(self.firstName)\n Last Name: \(self.lastName)\n Mail ID: \(self.mailID)")  */
                        
                    
                       self.displayUserInformation.text = "UserID : \(self.mailID)"
                        
                       self.userDefaults.set(self.mailID, forKey: "MailID")
                        
                    }
                    break
                    
                case .failure(_):
                    
                    print(response.result.error!)
                    break
                }
        }
    }
}
