//
//  ViewController.swift
//  19.Day-Project2-GuessTheFlag
//
//  Created by Sabir Myrzaev on 21.10.2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var scoreLabel: UILabel!

    // MARK: - Variable
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var endGame = 10
    
    // MARK: - lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        scoreLabel.text = "\(score)"

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "spain", "uk", "us"]
        askQuestion()
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var repeatGame: String = "Continue"
        var scoreMessage: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            scoreLabel.text = "\(score)"
            endGame -= 1
            scoreMessage = "Your score is \(score)"
        } else {
            title = "Wrong! It's \(countries[sender.tag].uppercased())"
            score -= 1
            scoreLabel.text = "\(score)"
            endGame -= 1
            scoreMessage = "Your score is \(score)"
        }
        
        if endGame == 0 {
            title = "Game Over"
            scoreMessage = "Your score is \(score)"
            repeatGame = "Try again"
            score = 0
            scoreLabel.text = "\(score)"
            endGame = 10
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }

        
        let ac = UIAlertController(title: title, message: scoreMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: repeatGame, style: .default, handler: askQuestion(action:)))
        
        present(ac, animated: true, completion: nil)
        
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) { [weak self] in
            self?.button1.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.button2.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.button3.transform = CGAffineTransform(scaleX: 1, y: 1)
        }

        
        title = countries[correctAnswer].uppercased()
    }

}

