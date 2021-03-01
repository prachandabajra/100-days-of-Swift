//
//  ViewController.swift
//  Project2
//
//  Created by Prachanda Muni Bajracharya on 1/30/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var count = 0
    var showScore = false
    var customButton = UIBarButtonItem.init()
    var customButton2 = UIBarButtonItem.init()
    
    // Project12 challenge
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("showScore")
        
        customButton = UIBarButtonItem(title: "Show", style: .done, target: self, action: #selector(showScoreTapped))
        customButton2 = UIBarButtonItem(title: "Hide", style: .done, target: self, action: #selector(showScoreTapped))
        navigationItem.rightBarButtonItem = customButton
        

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
       
        // CALayer
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // CALayer doesn't understand UIColor, so it need to be converted to CGColor
        // for custom color
//        button1.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        readHighScore()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        count += 1
        
        if showScore {
            title = "\(count). | \(countries[correctAnswer].uppercased())? | Score: \(score)"
        } else {
            title = "\(count). | \(countries[correctAnswer].uppercased())?"
        }
    }

    //  The event used for the attachment is called TouchUpInside
    // @IBOutlet is a way of connecting code to storyboard layouts, and @IBAction is a way of making storyboard layouts trigger code.
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if (sender.tag == correctAnswer) {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        if (count == 10) {
            var message =  "Your final score is \(score)"
            if score > highScore {
                message = "Congratulations! you have a new highscore: \(score)"
                highScore = score
                saveHighScore()
            }
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
            ac.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
                self.count = 0
                self.score = 0
                self.askQuestion()
            })
            
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
        }
    }
    
    @objc func showScoreTapped() {
        showScore = !showScore
    
        if (showScore) {
            navigationItem.rightBarButtonItem = customButton2
            title = "\(count). | \(countries[correctAnswer].uppercased())? | Score: \(score)"
        } else {
            navigationItem.rightBarButtonItem = customButton
            title =  "\(count). | \(countries[correctAnswer].uppercased())?"
        }
    }
    
    // UserDefaults
    func readHighScore() {
        let defaults = UserDefaults.standard
        
        // if nothing is saved, defaults.integer will return 0
        highScore = defaults.integer(forKey: "highScore")
    }
    
    func saveHighScore() {
        let defaults = UserDefaults.standard
        
        defaults.set(highScore, forKey: "highScore")
    }
}

