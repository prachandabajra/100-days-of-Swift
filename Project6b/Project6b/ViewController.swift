//
//  ViewController.swift
//  Project6b
//
//  Created by Prachanda Muni Bajracharya on 2/10/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.text = "THESE"
        label1.backgroundColor = .red
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.text = "ARE"
        label2.backgroundColor = .cyan
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.text = "SOME"
        label3.backgroundColor = .yellow
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.text = "AWESOME"
        label4.backgroundColor = .green
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.text = "LABELS"
        label5.backgroundColor = .orange
        label5.sizeToFit()
        
        // All five views then get added to the view belonging to our view controller by using view.addSubview().
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        
        // Auto Layout constraints
        // Using Visual Format Language-------------------------------------------------
        // -----------------------------------------------------------------------------
        // view.addConstraints() adds an array of constraints to our view controller's view. This array is used rather than a single constraint because VFL can generate multiple constraints at a time.
        // NSLayoutConstraint.constraints(withVisualFormat:) is the Auto Layout method that converts VFL into an array of constraints.
        // The H: parts means that we're defining a horizontal layout
        // The pipe symbol, |, means "the edge of the view." We're adding these constraints to the main view inside our view controller, so this effectively means "the edge of the view controller."
        // Finally, we have [label1], which is a visual way of saying "put label1 here".
        // "H:|[label1]|" means "horizontally, I want my label1 to go edge to edge in my view."
        
//        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//
//        for label in viewsDictionary.keys {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
        
        // V: meaning that these constraints are vertical.
        // - symbol, which means "space". It's 10 points by default, but you can customize it.
        // Constraint priority is a value between 1 and 1000, where 1000 means "this is absolutely required" and anything less is optional. By default, all constraints you have are priority 1000, so Auto Layout will fail to find a solution in our current layout. But if we make the height optional – even as high as priority 999 – it means Auto Layout can find a solution to our layout: shrink the labels to make them fit.
        // It's the @999 that assigns priority to a given constraint, and using (label1) for the sizes of the other labels is what tells Auto Layout to make them the same height.
        
//        let metrics = ["layoutHeight" : 88]
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(layoutHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        
        // Using Anchors------------------------------------------------------------------
        // -------------------------------------------------------------------------------
        // Every UIView has a set of anchors that define its layouts rules. The most important ones are widthAnchor, heightAnchor, topAnchor, bottomAnchor, leftAnchor, rightAnchor, leadingAnchor, trailingAnchor, centerXAnchor, and centerYAnchor.
        // Most of those should be self-explanatory, but it’s worth clarifying the difference between leftAnchor, rightAnchor, leadingAnchor, and trailingAnchor. For me, left and leading are the same, and right and trailing are the same too. This is because my devices are set to use the English language, which is written and read left to right. However, for right-to-left languages such as Hebrew and Arabic, leading and trailing flip around so that leading is equal to right, and trailing is equal to left.
        var previous: UILabel?
        
        for label in [label1, label2, label3, label4, label5] {
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/5, constant: -10).isActive = true
            
            if let previous = previous {
                // we have a previous label – create a height constraint
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                // this is the first label
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            // set the previous label to be the current one, for the next loop iteration
            previous = label
        }
    }


}

