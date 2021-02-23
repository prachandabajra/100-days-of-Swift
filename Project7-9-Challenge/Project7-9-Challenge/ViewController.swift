//
//  ViewController.swift
//  Project7-9-Challenge
//
//  Created by Prachanda Muni Bajracharya on 2/21/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var livesLabel: UILabel!
    var guessedWord: UITextField!
    var currentAnswer: String!
    var letterButtons = [UIButton]()
    var words = [String]()
    var usedLetters = [String]()
    
    var activatedButtons = [UIButton]()
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var lives = 7 {
        didSet {
            livesLabel.text = "Lives Left: \(lives)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        livesLabel = UILabel()
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.text = "Lives Left: \(lives)"
        livesLabel.textAlignment = .right
        view.addSubview(livesLabel)
        
        guessedWord = UITextField()
        guessedWord.translatesAutoresizingMaskIntoConstraints = false
        guessedWord.text = "_ _ _ _ _ _"
        guessedWord.textAlignment = .center
        guessedWord.font = UIFont.systemFont(ofSize: 40)
        guessedWord.isUserInteractionEnabled = false
        guessedWord.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
//        guessedWord.defaultTextAttributes.updateValue(10, forKey: NSAttributedString.Key.kern)
        view.addSubview(guessedWord)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            livesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            livesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            guessedWord.topAnchor.constraint(equalTo: livesLabel.bottomAnchor, constant: 50),
            guessedWord.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            buttonsView.topAnchor.constraint(equalTo: guessedWord.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 320),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
        ])
        

        let letterFontSize = 40
        var letterCount = 0
        
        // create 26 buttons as a 4x7 grid
        for row in 0..<4 {
            for col in 0..<7 {
                if letterCount > 25 {
                    break
                }
                
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(letterFontSize))

                letterButton.setTitle(letters[letterCount], for: .normal)
//                letterButton.tintColor = .red

                letterButton.frame = CGRect(x: letterFontSize * col, y: letterFontSize * row, width: letterFontSize, height: letterFontSize)

                buttonsView.addSubview(letterButton)

                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                letterCount += 1
            }
        }
        
        
//        for col in 0..<7 {
//            let letterButton = UIButton(type: .system)
//            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(letterFontSize))
//
//            letterButton.setTitle("A", for: .normal)
//            //                letterButton.tintColor = .red
//
//            letterButton.frame = CGRect(x: letterFontSize * col, y: letterFontSize * col, width: letterFontSize, height: letterFontSize)
//
//            buttonsView.addSubview(letterButton)
//
//            letterButtons.append(letterButton)
//        }
        
                
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text?.lowercased() else {
            return
        }
//        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        
        usedLetters.append(buttonTitle)
        
        if let _ = currentAnswer?.contains(buttonTitle) {
            let currentGuess = currentAnswer!
            var promptWord = ""
            
            for letter in currentGuess {
                let strLetter = String(letter)

                if usedLetters.contains(strLetter) {
                    promptWord += strLetter
                } else {
                    promptWord += "?"
                }
            }
            
            guessedWord.text = promptWord
            
        }
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    func loadLevel() {
        if let wordsFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsString = try? String(contentsOf: wordsFileURL) {
                words = wordsString.components(separatedBy: "\n")

                currentAnswer = words[level - 1]
               
                
                guessedWord.text = ""
                for (index, currentAnswerLetter) in currentAnswer.enumerated() {
                    print(currentAnswerLetter)
//                    if index + 1 == currentAnswer.count {
//                        guessedWord.text?.append("_")
//                    } else {
                        guessedWord.text?.append("?")
//                    }
                }
            }
        }
    }

}

