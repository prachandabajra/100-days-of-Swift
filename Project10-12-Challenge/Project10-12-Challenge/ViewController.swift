//
//  ViewController.swift
//  Project10-12-Challenge
//
//  Created by Prachanda Muni Bajracharya on 3/2/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickImage))
        
        title = "Photo Album"
        
        load()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        cell.textLabel?.text = photos[indexPath.row].caption
        cell.textLabel?.textAlignment = .center
        
        let path = getDocumentsDirectory().appendingPathComponent(photos[indexPath.row].name)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true    // needed for cornerRadius to work
        
        return cell
    }
    
    @objc func pickImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Store Image
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        // Caption
        var caption = "No Caption"
        let ac = UIAlertController(title: "Add Caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak ac, weak self] _ in
            if let text = ac?.textFields?[0].text {
                caption = text
            }
            
            let photo = Photo(name: imageName, caption: caption)
            self?.photos.append(photo)
            self?.save()
            self?.tableView.reloadData()
            
        })
       
         present(ac, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Choose", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "View Photo", style: .default) {
            [weak self] _ in
            self?.viewPhoto(indexPath)
        })
        ac.addAction(UIAlertAction(title: "Delete Photo", style: .destructive) {
            [weak self] _ in
            self?.photos.remove(at: indexPath.row)
            self?.save()
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func viewPhoto(_ indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.caption = photos[indexPath.row].caption
            let path = getDocumentsDirectory().appendingPathComponent(photos[indexPath.row].name)
            vc.imagePath = path.path
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // User Defaults: Write
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: photos, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        }
    }
    
    func load() {
        // User Defaults: Read
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "photos") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Photo] {
                photos = decodedPeople
            }
        }
    }
}

