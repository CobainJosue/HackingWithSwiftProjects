//
//  ViewController.swift
//  Project2
//
//  Created by Josue Quiñones on 2/25/19.
//  Copyright © 2019 Josue Quiñones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfAnswers = 0
    var highestScore = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showScore))
        
        let defaults = UserDefaults.standard
        highestScore = defaults.integer(forKey: "score")
        
        askQuestions()
    }
    
    @objc func showScore() {
        
        let ac = UIAlertController(title: "Your score:", message: "\(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    func askQuestions(action: UIAlertAction! = nil) {
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        
        title = "\(countries[correctAnswer].uppercased())   score: \(score)"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        var title: String
        var message: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            message = "Your score is \(score)."
        } else {
            title = "Wrong"
            score -= 1
            message = "Wrong! That's the flag of \(countries[sender.tag].uppercased())  Your score is \(score)."
        }
        
        numberOfAnswers += 1
        
        if numberOfAnswers >= 10 {
            if score > highestScore {
                message = "YOU BEAT THE HIGHEST SCORE: \(score)."
                highestScore = score
                let defaults = UserDefaults.standard
                defaults.set(highestScore, forKey: "score")
            } else {
                message = "Your FINAL score is \(score). The game is gonna restart"
            }
            score = 0
            numberOfAnswers = 0
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestions))
        present(ac, animated: true)
        
    }
    


}

