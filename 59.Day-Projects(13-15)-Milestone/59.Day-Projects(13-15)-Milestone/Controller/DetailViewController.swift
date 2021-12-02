//
//  DetailViewController.swift
//  59.Day-Milestone:-Projects(13-15)
//
//  Created by Sabir Myrzaev on 02.12.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var detailItem: Country?
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var factsLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!




    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityLabel.text = detailItem?.city
        factsLabel.text = detailItem?.facts
        countryLabel.text = detailItem?.image
        
    }
}
