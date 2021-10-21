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

    // MARK: - Variable
    var countries = [String]()
    var score = 0

    
    // MARK: - lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor



        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "spain", "uk", "us"]
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }

}

