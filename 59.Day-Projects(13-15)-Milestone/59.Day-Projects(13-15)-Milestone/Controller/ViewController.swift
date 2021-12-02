//
//  ViewController.swift
//  59.Day-Milestone:-Projects(13-15)
//
//  Created by Sabir Myrzaev on 02.12.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()

    // MARK: - Lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TownList"
        
        if let TownList = Bundle.main.url(forResource: "TownList", withExtension: "json") {
            if let data = try? Data(contentsOf: TownList) {
                parse(json: data)
                return
            }
        }
        showError()
    }

    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
            countries = jsonCountries.results
            tableView.reloadData()
        }
    }
    
    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = countries[indexPath.row]
        
        cell.textLabel?.text = country.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController {
        vc.detailItem = countries[indexPath.row]
        vc.title = countries[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
        }
    }
}

