//
//  ViewController.swift
//  33.Day-Project7-WhitehousePetitions
//
//  Created by Sabir Myrzaev on 02.11.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - Variable
    var petitions = [Petition]()

    // MARK: - lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Whitehouse Petitions"
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }

    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell

    }
    
    

}

