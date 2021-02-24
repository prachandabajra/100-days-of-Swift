//
//  ViewController.swift
//  Project1
//
//  Created by Prachanda Muni Bajracharya on 1/27/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        // Using performSelector(): from Project 9 challenge
        performSelector(inBackground: #selector(loadImages), with: nil)
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

        // Not using "weak self" because dispatch_async will only hold the block that retains self only till the block is executed. Also the code that calls dispatch_async do not hold any reference to its internals, so there are no risk of retain cycles.
        // Source: https://stackoverflow.com/questions/26277371/swift-uitableview-reloaddata-in-a-closure
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pictures.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
//        cell.textLabel?.text = pictures[indexPath.row]
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//            // 2: success! Set its selectedImage property
//            vc.selectedImage = pictures[indexPath.row]
//            vc.selectedPictureNumber = indexPath.row + 1
//            vc.totalPictures = pictures.count
//
//            // 3: now push it onto the navigation controller
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
    @objc func shareTapped() {
        let appURL: URL = URL(string: "https://www.google.com/")!
        let items = [appURL]
        
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue PictureCell")
        }
        cell.name.text = pictures[indexPath.item]
        cell.image.image = UIImage(named: pictures[indexPath.item])
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.cornerRadius = 10
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

