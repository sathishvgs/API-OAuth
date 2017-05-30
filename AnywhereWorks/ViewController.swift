//
//  ViewController.swift
//  AnywhereWorks
//
//  Created by user on 5/23/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
    }
        
    override func viewDidAppear(_ animated: Bool){
            

            
        if let _ = userDefaults.object(forKey: "AccessToken") {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let displayInfoViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarID") as? TabBarControllerViewController  else {
                return
            }
            
            navigationController?.pushViewController(displayInfoViewController, animated: true)

        }
        

    }
}

