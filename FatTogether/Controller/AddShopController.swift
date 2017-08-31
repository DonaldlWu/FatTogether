//
//  AddShopController.swift
//  FatTogether
//
//  Created by 吳得人 on 2017/8/30.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit
import Firebase

class AddShopController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menuArray = [Menu]()
    var menuPriceArray = [Int]()
    var menuNameArray = [String]()
    var tableView: UITableView!
    
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var menuPriceTextField: UITextField!
    
    @IBAction func addMenu(_ sender: Any) {
        if menuNameTextField.text != "" && menuPriceTextField.text != "" {
            print(menuPriceTextField)
            print(menuNameTextField)
            guard let name = menuNameTextField.text, let price = menuPriceTextField.text else {
                return
            }
            menuArray.append(Menu(name: name, price: Int(price)!))
            menuPriceArray.append(Int(price)!)
            menuNameArray.append(name)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addShop(_ sender: Any) {
        if shopNameTextField.text != "" {
            let ref = Database.database().reference().child("Shop")
            let shopRef = ref.childByAutoId()
            let value: [AnyHashable: Any] = ["shopName": self.shopNameTextField.text as Any, "menuName": self.menuNameArray as Any, "menuPrice": self.menuPriceArray as Any]
            shopRef.updateChildValues(value)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = "\(menuArray[indexPath.row].menuName)- \(menuArray[indexPath.row].menuPrice)元"
        return cell
    }
    
}
