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
        
        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]

        // view.addConstraints() adds an array of constraints to our view controller's view. This array is used rather than a single constraint because VFL can generate multiple constraints at a time.
        // NSLayoutConstraint.constraints(withVisualFormat:) is the Auto Layout method that converts VFL into an array of constraints.
        // The H: parts means that we're defining a horizontal layout
        // The pipe symbol, |, means "the edge of the view." We're adding these constraints to the main view inside our view controller, so this effectively means "the edge of the view controller."
        // Finally, we have [label1], which is a visual way of saying "put label1 here".
        // "H:|[label1]|" means "horizontally, I want my label1 to go edge to edge in my view."
        for label in viewsDictionary.keys {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
        }
        
        // V: meaning that these constraints are vertical.
        // - symbol, which means "space". It's 10 points by default, but you can customize it.
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1]-[label2]-[label3]-[label4]-[label5]", options: [], metrics: nil, views: viewsDictionary))
    }


}

