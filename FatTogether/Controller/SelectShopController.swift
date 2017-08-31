//
//  SelectShopController.swift
//  FatTogether
//
//  Created by 吳得人 on 2017/8/30.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class SelectShopController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var shopNameArray = [String]()
    var shopIdArray = [String]()
    var shopMenuArray = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.tableFooterView = UIView()
        
        fetchShop()
        
    }
    
    func fetchShop() {
        FIRDatabase.database().reference().child("Shop").observe(.childAdded, with: { (snapshot) in
            self.shopIdArray.append(snapshot.key)
            if let dictionary = snapshot.value as? [String: Any] {
                
                self.shopNameArray.append(dictionary["shopName"] as! String)
                self.shopMenuArray.append(dictionary)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = shopNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "確定開團", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            
            let ref = FIRDatabase.database().reference().child("Order")
            let orderRef = ref.childByAutoId()
            let value: [AnyHashable: Any] = ["shopID": self.shopIdArray[indexPath.row] as Any, "shopName": self.shopNameArray[indexPath.row] as Any]
            orderRef.updateChildValues(value)
            self.navigationController?.popViewController(animated: true)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
}


