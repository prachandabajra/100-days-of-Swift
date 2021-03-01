//
//  ViewController.swift
//  Project1
//
//  Created by Prachanda Muni Bajracharya on 1/27/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var pictureViews = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
//        let fm = FileManager.default
//        let path = Bundle.main.resourcePath!
//        let items = try! fm.contentsOfDirectory(atPath: path)
//
//        for item in items {
//            if item.hasPrefix("nssl") {
//                // this is a picture to load!
//                pictures.append(item)
//            }
//        }
//
//        pictures = pictures.sorted()
//        print(pictures)
        
        // Using performSelector(): from Project 9 challenge
        performSelector(inBackground: #selector(loadImages), with: nil)
        
//        let defaults = UserDefaults.standard
//
//        if let savedPictureViews = defaults.object(forKey: "pictureViews") as? Data {
//            let jsonDecoder = JSONDecoder()
//
//            do {
//                pictureViews = try jsonDecoder.decode([Int].self, from: savedPictureViews)
//            } catch {
//                print("Cannot load views")
//            }
//        }
    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
            }
        }
        
        pictures = pictures.sorted()
        print(pictures)
        
        let defaults = UserDefaults.standard
        
        if let savedPictureViews = defaults.object(forKey: "pictureViews") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictureViews = try jsonDecoder.decode([Int].self, from: savedPictureViews)
            } catch {
                print("Cannot load views")
            }
        } else {
            for _ in 0..<pictures.count {
                pictureViews.append(0)
            }
        }
        
        // Not using "weak self" because dispatch_async will only hold the block that retains self only till the block is executed. Also the code that calls dispatch_async do not hold any reference to its internals, so there are no risk of retain cycles.
        // Source: https://stackoverflow.com/questions/26277371/swift-uitableview-reloaddata-in-a-closure
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        
        if !pictureViews.isEmpty {
            cell.detailTextLabel?.text = "\(pictureViews[indexPath.row]) Views"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            
            pictureViews[indexPath.row] += 1
            save()
            tableView.reloadData()
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareTapped() {
        let appURL: URL = URL(string: "https://www.google.com/")!
        let items = [appURL]
        
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    // User Defaults: Write
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictureViews) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictureViews")
        } else {
            print("Failed to save views.")
        }
    }
}

