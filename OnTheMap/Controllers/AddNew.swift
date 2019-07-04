//
//  AddNew.swift
//  OnTheMap
//
//  Created by Haya Mousa on 07/06/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import UIKit
import CoreLocation



class AddNew: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findOnMap: UIButton!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTextField.delegate = self
        self.urlTextField.delegate = self
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        let location = locationTextField.text
        let link = urlTextField.text
        
        if locationTextField.text!.isEmpty != false && urlTextField.text!.isEmpty != false {
        self.alert(message: "Please fill out all fields", title: "Uncompleted")
            return
        }
        
        let studentLocation = StudentLocation(mapString: location!, mediaURL: link!)
        geocodeCoordinates(studentLocation)
    }
    
    func geocodeCoordinates(_ studentLocation: StudentLocation) {
        
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMark, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.alert(message: "Location not found", title: "ERROR!")
                    return
                }
                else {
                    guard let firstLocation = placeMark?.first?.location else { return }
                    
                    var location = studentLocation
                    location.latitude = firstLocation.coordinate.latitude
                    location.longitude = firstLocation.coordinate.longitude
                    self.performSegue(withIdentifier: "goToVerificationScreenSegue", sender: location)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVerificationScreenSegue", let viewController = segue.destination as? DetailViewController {
            viewController.location = (sender as! StudentLocation)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func UserCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
  
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        view.frame.origin.y = -(getKeyboardHeight(notification))
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        view.frame.origin.y = 0
    }
    
}
