//
//  ViewController.swift
//  41.Day-Project(7-9)-Malestone
//
//  Created by Sabir Myrzaev on 17.11.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    let word = "RHYTHM"
    var usedLetters = [String]()
    var promtWord = ""
    var wrongAnsers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newTryLetter))
        
        checkWord()
    }
    
    func checkWord() {
        countLabel.text = "\(wrongAnsers)"
        promtWord = ""
        for letter in word {
            print(letter)
            let strLetter = String(letter)
            
            if usedLetters.contains(strLetter) {
                promtWord += strLetter
            } else {
                promtWord += "?"
            }
            wordLabel.text = promtWord
        }
        if promtWord == word {
            endGameAlert(title: "YOU WON", message: "COOOOOOOL!")
        } else if wrongAnsers == 8 {
            endGameAlert(title: "YOU LOSE", message: "LOOOOOOOOOSER!")
        }
    }
    
    @objc func newTryLetter() {
        let ac = UIAlertController(title: "Enter letter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let letter = ac?.textFields?[0].text else { return }
            self?.submit(letter)
        }
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
    }
    
    func submit(_ letter: String) {
        
        let upperLetter = letter.uppercased()
        
        usedLetters.append(upperLetter)
        
        wrongAnsers += 1
    
        checkWord()
    }
    
    // MARK: - LoseAlert or WinAlert Game
    func endGameAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
        usedLetters = [String]()
        wrongAnsers = 0
        checkWord()
    }
}

