//
//  ViewController.swift
//  Project13
//
//  Created by Prachanda Muni Bajracharya on 3/4/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

// One downside to Core Image is it's not very guessable, so you need to know what you're doing otherwise you'll waste a lot of time. It's also not able to rely on large parts of Swift's type safety, so you need to be careful when using it because the compiler won't help you as much as you're used to.

// The first is a Core Image context, which is the Core Image component that handles rendering. We create it here and use it throughout our app, because creating a context is computationally expensive so we don't want to keep doing it.
// The second is a Core Image filter, and will store whatever filter the user has activated. This filter will be given various input settings before we ask it to output a result for us to show in the image view.
import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var changeFilter: UIButton!
    
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    let defaultFilter = "CISepiaTone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: defaultFilter)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        dismiss(animated: true)
        currentImage = image
        
        // Converting UIImage to CIImage
        // we can create a CIImage from a UIImage, and we send the result into the current Core Image Filter using the kCIInputImageKey.
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
        
        if changeFilter.titleLabel?.text == "Change Filter" {
            changeFilter.setTitle(defaultFilter, for: .normal)
        }
    }

    // For iPad we need popoverPresentationController
    // Changed sender:Any to sender:UIButton
    // Now we have a way to pin alertController(actionSheet) to a particular button
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    // The selector can be provided in two ways: vague and clean, or specific and ugly.
    // Previously we've had very simple selectors, like #selector(shareTapped). And we can use that approach here – Swift allows us to be really vague about the selector we intend to call, and this works just fine:
    // #selector(image)
    // This second option is longer, but provides much more information both to Xcode and to other people reading your code, so it's generally preferred. To be honest, this particular callback is a bit of a wart in iOS, but the fact that it stands out so much is testament to the fact that there are so few warts around!
    // #selector(image(_:didFinishSavingWithError:contextInfo:))
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Save Error", message: "There is no image to save", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    // All the filters and the keys they use are described fully in Apple's documentation, but for this project we're going to take a shortcut. There are four input keys we're going to manipulate across seven different filters. Sometimes the keys mean different things, and sometimes the keys don't exist, so we're going to apply only the keys that do exist with some cunning code.
    // Each filter has an inputKeys property that returns an array of all the keys it can support. We're going to use this array in conjunction with the contains() method to see if each of our input keys exist, and, if it does, use it. Not all of them expect a value between 0 and 1, so I sometimes multiply the slider's value to make the effect more pronounced.
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        // CIPixellate uses inputCenter, inputScale
        // CIBumpDistortion uses inputCenter, inputRadius, inputScale
        // CIGaussianBlur uses inputRadius
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }

        guard let outputImage = currentFilter.outputImage else { return }
        
        // Converting CIImage to UIImage: CIImage > CGImage > UIImage
        // It creates a new data type called CGImage from the output image of the current filter. We need to specify which part of the image we want to render, but using image.extent means "all of it." Until this method is called, no actual processing is done, so this is the one that does the real work. This returns an optional CGImage so we need to check and unwrap with if let.
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    // This method should update our currentFilter property with the filter that was chosen, set the kCIInputImageKey key again (because we just changed the filter), then call applyProcessing().
    func setFilter(action: UIAlertAction) {
        // make sure we have a valid image before continuing!
        guard currentImage != nil else { return }
        
        // safely read the alert action's title
        guard let actionTitle = action.title else { return }
        
        changeFilter.setTitle(actionTitle, for: .normal)

        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

