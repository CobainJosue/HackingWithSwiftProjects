//
//  ViewController.swift
//  Consolidation7-9
//
//  Created by Josue Quiñones on 3/13/19.
//  Copyright © 2019 Josue Quiñones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentWordLabel: UILabel!
    var lettersLabel: UILabel!
    var oportunities: UILabel!
    var currentWord = "???"
    var promptWord = "???"
    var posibleWords = [String]()
    var score = 0 {
        didSet {
            title = "Score: \(score)"
        }
    }
    var wrongAnswers = 0
    var usedLetters = [String]()
    var letters = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tryLetter))
        title = "Score: \(score)"
        
        loadWords()
        
    }
    
    @objc func tryLetter() {
        let ac = UIAlertController(title: "New try", message: "Put a letter for a try!", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Try", style: .default, handler: { [unowned self] _ in
            guard let inputLetter = ac.textFields?[0].text else { return }
            
            if inputLetter.count == 1 {
                
                if self.usedLetters.contains(inputLetter) {
                    self.singleActionAlertWithoutHandler(title: "You already used thar letter", message: "😟", actionTitle: "OK")
                } else {
                    if !self.letters.contains(inputLetter) {
                        self.letters += "\(inputLetter), "
                    }
                    self.lettersLabel.text = "Letters that you've already used:\n\n\(self.letters)"
                    self.promptWord.removeAll()
                    if self.currentWord.contains(inputLetter) {
                        self.usedLetters.append(inputLetter)
                        
                        for letter in self.currentWord {
                            let strLetter = String(letter)
                            if self.usedLetters.contains(strLetter) {
                                self.promptWord += strLetter
                            } else {
                                self.promptWord += "?"
                            }
                        }
                        self.currentWordLabel.text = self.promptWord
                        
                        if !self.promptWord.contains("?") {
                            let ac = UIAlertController(title: "GREAT!", message: "You win!", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: { _ in
                                self.score += 1
                                self.newWord()
                            }))
                            self.present(ac, animated: true)
                            return
                        }
                    } else {
                        self.wrongAnswers += 1
                        self.oportunities.text = "Oportunities: \(7 - self.wrongAnswers)"
                        if self.wrongAnswers == 7 {
                            let ac = UIAlertController(title: "DEAD!", message: "You lose! 😭", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: { _ in
                                self.score -= 1
                                self.newWord()
                            }))
                            self.present(ac, animated: true)
                            return
                        }
                        self.singleActionAlertWithoutHandler(title: "Incorrect word!", message: "Near the hangman", actionTitle: "OK")
                    }
                }
                
            } else {
                print("Mas de una letra")
            }
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func singleActionAlertWithoutHandler(title: String, message: String, actionTitle: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default))
        present(ac, animated: true)
    }
    
    func loadWords() {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
                if let words = try? String(contentsOf: wordsURL) {
                    self.posibleWords = words.components(separatedBy: "\n")
                    if self.posibleWords.isEmpty {
                        self.posibleWords = ["empty"]
                    }
                    
                    DispatchQueue.main.async {
                        self.newWord()
                    }
                    
                }
            }
        }
        
    }
    
    func newWord() {
        usedLetters.removeAll()
        wrongAnswers = 0
        letters = ""
        lettersLabel.text = ""
        oportunities.text = "Oportunities: 7"
        currentWord = posibleWords.randomElement()!
        promptWord = ""
        for _ in currentWord {
            promptWord += "?"
        }
        currentWordLabel.text = promptWord
    }

    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        
        currentWordLabel = UILabel()
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWordLabel.textAlignment = .center
        currentWordLabel.numberOfLines = 1
        currentWordLabel.font = UIFont.systemFont(ofSize: 30)
        currentWordLabel.text = "??"
        //currentWordLabel.backgroundColor = .blue
        
        view.addSubview(currentWordLabel)
        
        lettersLabel = UILabel()
        lettersLabel.translatesAutoresizingMaskIntoConstraints = false
        lettersLabel.textAlignment = .left
        lettersLabel.numberOfLines = 0
        lettersLabel.font = UIFont.systemFont(ofSize: 26)
        lettersLabel.text = ""
        //lettersLabel.backgroundColor = .red
        
        view.addSubview(lettersLabel)
        
        oportunities = UILabel()
        oportunities.translatesAutoresizingMaskIntoConstraints = false
        oportunities.textAlignment = .right
        oportunities.numberOfLines = 1
        oportunities.font = UIFont.systemFont(ofSize: 20)
        oportunities.text = "Oportunities: 7"
        
        view.addSubview(oportunities)
        
        NSLayoutConstraint.activate([
            currentWordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            currentWordLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            currentWordLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 10),
            currentWordLabel.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.4, constant: -15),
            
            lettersLabel.topAnchor.constraint(equalTo: currentWordLabel.bottomAnchor, constant: 50),
            lettersLabel.leadingAnchor.constraint(equalTo: currentWordLabel.leadingAnchor),
            lettersLabel.trailingAnchor.constraint(equalTo: currentWordLabel.trailingAnchor),
            lettersLabel.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5, constant: -5),
            
            oportunities.topAnchor.constraint(equalTo: lettersLabel.bottomAnchor, constant: 5),
            oportunities.leadingAnchor.constraint(equalTo: currentWordLabel.leadingAnchor),
            oportunities.trailingAnchor.constraint(equalTo: currentWordLabel.trailingAnchor),
            oportunities.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            oportunities.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.1, constant: -5)
            ])
        
        
    }

}

