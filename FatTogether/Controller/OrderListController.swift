//
//  ViewController.swift
//  FatTogether
//
//  Created by 吳得人 on 2017/8/30.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class OrderListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var orderArray = [String]()
    var shopIDArray = [String]()
    var orderID = [String]()
    
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
        
        fetchOrder()
    }
    
    func fetchOrder() {
        Database.database().reference().child("Order").observe(.childAdded, with: { (snapshot) in
            self.orderID.append(snapshot.key)
            if let dictionary = snapshot.value as? [String: Any] {
                self.orderArray.append(dictionary["shopName"] as! String)
                self.shopIDArray.append(dictionary["shopID"] as! String)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = "\(orderArray[indexPath.row]) 團購中"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(shopIDArray[indexPath.row], forKey: "shopKey")
        UserDefaults.standard.set(orderID[indexPath.row], forKey: "orderID")
        performSegue(withIdentifier: "showOrderTabBar", sender: self)
    }
    
}

