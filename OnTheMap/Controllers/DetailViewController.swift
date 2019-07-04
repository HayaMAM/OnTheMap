//
//  DetailViewController.swift
//  OnTheMap
//
//  Created by Haya Mousa on 24/06/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var showOnMap: MKMapView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    var location: StudentLocation!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        populateMapView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func SubmitPressed(_ sender: Any) {
        UdacityAPI.getUserInfo {
            self.location.firstName = UdacityAPI.first
            self.location.lastName = UdacityAPI.last
            UdacityAPI.postLocation(studentLocation: self.location){(error) in
                DispatchQueue.main.async {
                    if error != nil {
                        DispatchQueue.main.async {
                        self.alert(message: "Uable to complete your request", title: "ERROR!")
                        }
                    } else {
                        DispatchQueue.main.async {

                        let alert = UIAlertController(title: "New location Added", message: "Successfully submitted a new location!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                                    (action) -> Void in
                                    self.performSegue(withIdentifier: "goToTabBarController", sender: self)
                                }))
                                self.present(alert, animated: true, completion: nil)
                        }
                        
                   }
                }
            }
        }
    }
    
  private func populateMapView(){
    
    var annotations = [MKPointAnnotation]()
    let lat = CLLocationDegrees(location.latitude!)
    let lon = CLLocationDegrees(location.longitude!)
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = "\(location.firstName) \(location.lastName)"
    annotation.subtitle = location.mediaURL
    annotations.append(annotation)
    
    let span = MKCoordinateSpan.init(latitudeDelta: 1, longitudeDelta: 1)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    
        DispatchQueue.main.async {
            self.showOnMap.addAnnotations(annotations)
            self.showOnMap.setRegion(region, animated: true)
            print("New location added to the Map View.")
        }
    }
 
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

}
