//
//  DetailViewController.swift
//  Project1
//
//  Created by Prachanda Muni Bajracharya on 1/28/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title is also optional
//        title = selectedImage
        title =  "Picture \(selectedPictureNumber) of \(totalPictures)"
        navigationItem.largeTitleDisplayMode = .never
        //  #selector tells the Swift compiler that a method called "shareTapped" will exist, and should be triggered when the button is tapped.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    // You already met the method viewDidLoad(), which is called when the view controller's layout has been loaded. There are several others that get called when the view is about to be shown, when it has been shown, when it's about to go away, and when it has gone away. These are called, respectively, viewWillAppear(), viewDidAppear(), viewWillDisappear() and viewDidDisappear().
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // We start with the method name, marked with @objc because this method will get called by the underlying Objective-C operating system (the UIBarButtonItem) so we need to mark it as being available to Objective-C code. When you call a method using #selector you’ll always need to use @objc too.
    // Tip: In case you were wondering, when you use @IBAction to make storyboards call your code, that automatically implies @objc – Swift knows that no @IBAction makes sense unless it can be called by Objective-C code.
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
//        guard let imageName = selectedImage else {
//                   print("No image name found")
//                   return
//               }
        
        let items: [Any] = [image, selectedImage ?? ""]
        
//        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
