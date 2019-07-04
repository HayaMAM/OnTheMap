//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Haya Mousa on 03/07/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import Foundation
import UIKit


class TabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        
        let mapVC = self.viewControllers![0] as! theMap
        mapVC.getUserInfo()
    }
    
    @IBAction func addNewLocationPressed(_ sender: Any) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewLocation")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        UdacityAPI.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
}
