//
//  FetchOrderController.swift
//  FatTogether
//
//  Created by 吳得人 on 2017/8/31.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class FetchOrderController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var orderDict = [String: Array<String>]()
    var orderNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "test"
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        fetchOrderList()
    }
    
    func fetchOrderList() {
        guard let orderID = UserDefaults.standard.string(forKey: "orderID") else {
            return
        }
        Database.database().reference().child("Order").child("\(orderID)").child("list").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.orderNameArray.append(snapshot.key)
                let name = snapshot.key
                let array = dictionary["content"] as! Array<String>
                self.orderDict.updateValue(array, forKey: name)
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
        return orderNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let name = orderNameArray[indexPath.row]
        let text = "\(orderDict[name]!)"
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = "\(name) - \(text)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
}
