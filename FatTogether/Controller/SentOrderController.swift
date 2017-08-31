//
//  SentOrderController.swift
//  FatTogether
//
//  Created by 吳得人 on 2017/8/31.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class SentOrderController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var orderArray = [String]()
    var menuNameArray = [String]()
    var menuPriceArray = [Int]()
    var tableViewArray = [String]()
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBAction func selectMenu(_ sender: Any) {

        
        let alertController = UIAlertController(title: "甜度冰塊請先填寫下方備註欄後再選擇飲料\n非常感謝囧RZ", message: nil, preferredStyle: .actionSheet)
        for i in 0...self.menuNameArray.count - 1 {
        let name = "\(self.menuNameArray[i])-\(self.menuPriceArray[i])$ "
            let position = UIAlertAction(title: name, style: .default, handler: {
                alert -> Void in
                self.tableViewArray.append(name + self.textView.text)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            alertController.addAction(position)
        }
        
        let cancelButtonAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel) {
            action in
        }
        
        alertController.addAction(cancelButtonAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func sentOrder(_ sender: Any) {
        if nameText.text != "" {
            guard let orderID = UserDefaults.standard.string(forKey: "orderID") else {
            return
        }
            let ref = Database.database().reference().child("Order")
        let post = ["content": self.tableViewArray]
        let childUpdates = ["/\(orderID)/list/\(nameText.text!)/": post]
        ref.updateChildValues(childUpdates)
        _ = self.tabBarController?.selectedIndex = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "訂單資訊"
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        fetchShop()
    }
    
    func fetchShop() {
        guard let shopKey = UserDefaults.standard.string(forKey: "shopKey") else {
            return
        }
        Database.database().reference().child("Shop").observe(.childAdded, with: { (snapshot) in
            if snapshot.key == shopKey {
                if let dictionary = snapshot.value as? [String: Any] {
                    self.menuNameArray = dictionary["menuName"] as! [String]
                    self.menuPriceArray = dictionary["menuPrice"] as! [Int]
                }
            }
        }, withCancel: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = self.tableViewArray[indexPath.row]
        return cell
    }
    
}
