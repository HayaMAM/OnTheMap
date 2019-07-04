//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Haya Mousa on 07/06/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var studentInformation : [StudentLocation] = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func updateTable(){
        UdacityAPI.getAllLocations () {(studentsLocations, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    self.alert(message:"There was an error performing your request" , title: "ERROR!")
                    return
                }
                
                guard studentsLocations != nil else {
                    self.alert(message: "There was an error loading locations", title: "ERROR")
                    return
                }
                
                self.studentInformation = studentsLocations!
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformation.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")
        let student = studentInformation[indexPath.row]
        cell?.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell?.detailTextLabel?.text = "\(student.mediaURL)"
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = studentInformation[indexPath.row]
        if let url = URL(string: selectedCell.mediaURL!) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
                DispatchQueue.main.async {
                    self.alert(message: "URL is not valid", title: "Invalid")
                }
            }
           }else{
                DispatchQueue.main.async {
                self.alert(message: "URL is not valid", title: "Invalid")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.studentInformation.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.studentInformation)
        }
        
        return [delete]
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
