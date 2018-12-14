//
//  DisplayInformationViewController.swift
//  AnywhereWorks
//
//  Created by user on 5/25/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DisplayInformationViewController: UIViewController {
    
    
    let datePick = UIDatePicker()
    
    var startDate: String = ""
    var endDate: String = ""
    var startTimeInterval: Int64?
    var endTimeInterval: Int64?
    //var mailID: String = ""
    //var minutes: String = ""
    var totalMinutes: Int = 0
   

    @IBOutlet weak var datePicker: UITextField!
    
    @IBOutlet weak var endDatePicker: UITextField!
    
    @IBOutlet weak var count: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = "Display Information"
        self.tabBarController?.navigationController?.navigationBar.backgroundColor = UIColor.white
        
       
    
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        createDatePicker()
        DatePicker()
    }

    
    
    
    func createDatePicker(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDateDone))
        toolBar.setItems([doneButton], animated: true)
        
        datePicker.inputAccessoryView = toolBar
        datePicker.inputView = datePick
    }
    
    func DatePicker() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDateDone))
        toolBar.setItems([doneButton], animated: true)
        
        endDatePicker.inputAccessoryView = toolBar
        endDatePicker.inputView = datePick
    }

    
    func startDateDone() {
        
        datePicker.text = "\(datePick.date)"
        self.view.endEditing(true)
        startDate = "\(datePick.date)"
        startTimeInterval = Int64(datePick.date.timeIntervalSince1970 * 1000)
        print("Start \(startDate)")
        print("The start DAte \(startTimeInterval!)")
        checkDatepicker()
    }
    
    
    func endDateDone(){
        
        endDatePicker.text = "\(datePick.date)"
        self.view.endEditing(true)
        endDate =  "\(datePick.date)"
        endTimeInterval = Int64(datePick.date.timeIntervalSince1970 * 1000)
        print("End Date \(endDate)")
        print("The stop Date \(endTimeInterval!)")
        //request()
        checkDatepicker()

    }
    
    
    func checkDatepicker() {
        
        if startTimeInterval != nil && endTimeInterval != nil {
            
            request()
        }
    }
    
    
    
    
    func request() {
        

        guard let mailId = UserDefaults().object(forKey: "MailID") else{
            return
        }
        
        let param: Parameters = ["apiKey" : "",
                     "email" : "\(mailId)",
            "startTime" : startTimeInterval,
            "endTime" : endTimeInterval ]
        
        
        let url = URL(string: "")!
        
        Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: ["Content_Type" : "application/json"]).responseJSON { (response) in
            
            
            switch(response.result) {
                
            case .success(_):
                
                
                if let userDetails = response.result.value{
                    
//                    print("response: \(userDetails)")
//                    let json = JSON(userDetails)
//                    
//                        print("JSON Format is \(json)")
                    
                   // let firstNamePath = ["data","user","firstName"]
                    
                    
                    if let data = userDetails as? [String : Any]{
                        
                        if let user = data["data"] as? [String : Any] {
                            
                            if let userValue = user[""] as? [String : Any]{
                                
                                  self.totalMinutes = userValue["minutes"] as! Int
                                print(self.totalMinutes)
                            }
                        }
                        
                    }
                    
                    
                   /* let path = ["data","sathish.gurunathan@adaptavantcloud.com","minutes"]
                    self.minutes = json[path].stringValue
                    print("The Minutes is \(self.minutes)")
                    //minutes = self.totalMinutes as! String
                   // self.count.text = self.minutes         */
                    self.count.text = "\(self.totalMinutes)"
                    
                    
                    
                    
                }
            break
                
            case .failure(_):
                
                print(response.result.error)
                break
                
                
            }
        }
    }
}
