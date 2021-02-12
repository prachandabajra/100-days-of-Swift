//
//  ViewController.swift
//  Project4-6-Challenge
//
//  Created by Prachanda Muni Bajracharya on 2/12/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    //  For holding the addActionButton itself as a weak variable
    weak var actionToEnable : UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding both button on right side of navigation bar
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemTapped))
//        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
//        navigationItem.rightBarButtonItems = [addButton, shareButton]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearListTapped))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, shareButton]
        navigationController?.isToolbarHidden = false
        
        title = "Shopping List"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItemTapped() {
        let ac = UIAlertController(title: "Add items", message: nil, preferredStyle: .alert)
        let addActionButton = UIAlertAction(title: "Add", style: .default) {
                  [weak self, weak ac] _ in
                  guard let item = ac?.textFields?[0].text else { return }
                  
                  self?.shoppingList.insert(item, at: 0)
                  
                  self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

              }

        ac.addTextField(configurationHandler: {(textField: UITextField) -> Void in
            textField.placeholder = "Enter item name"
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        })
        
        ac.addAction(addActionButton)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        //  For holding the addActionButton itself as a weak variable
        self.actionToEnable = addActionButton
        addActionButton.isEnabled = false
        
        present(ac, animated: true)
    }
    
    @objc func textChanged(_ sender: UITextField) {
        self.actionToEnable?.isEnabled  = (!(sender.text!.isEmpty))
    }
    
    @objc func clearListTapped() {
        shoppingList.removeAll()
        tableView.reloadData()
    }
    
    @objc func shareTapped() {
        if shoppingList.isEmpty {
            let ac = UIAlertController(title: "Warning", message: "No items in the list", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
            return
        }
        
        let listToShare = shoppingList.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [listToShare], applicationActivities: nil)
        // Adding both button on right side of navigation bar
//        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        vc.popoverPresentationController?.barButtonItem = toolbarItems?[1]
        present(vc, animated: true)
    }
}

