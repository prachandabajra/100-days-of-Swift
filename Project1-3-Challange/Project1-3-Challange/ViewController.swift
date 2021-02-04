//
//  ViewController.swift
//  Project1-3-Challange
//
//  Created by Prachanda Muni Bajracharya on 2/3/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var flags = [String]()
    var flagNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flag Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.contains("@2x") {
                flags.append(item)
                flagNames.append(item.replacingOccurrences(of: "@2x.png", with: "").uppercased())
            }
        }
        print(flags)
        print(flagNames)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlagList", for: indexPath)
        cell.textLabel?.text = flagNames[indexPath.row]
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        tableView.rowHeight = 50
        cell.imageView?.layer.cornerRadius = 8.0
        cell.imageView?.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = flags[indexPath.row]
            vc.selectedImageName = flagNames[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}

