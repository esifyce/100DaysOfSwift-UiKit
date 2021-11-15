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
    var allPetitions = [Petition]()
    var searchedPetitions = [Petition]()
    
    // MARK: - lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(infoPetitions))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(sortPetitions))
        
        title = "Whitehouse Petitions"
        
        performSelector(inBackground: #selector(fetchData), with: nil)
    }
    
    @objc func fetchData() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(ac, animated: true, completion: nil)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func infoPetitions() {
        let ac = UIAlertController(title: "CREDIT", message: "We The People API of the Whitehouse", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    @objc func sortPetitions() {
        let ac = UIAlertController(title: "Search petitions containing", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        let clearSearch = UIAlertAction(title: "Clear filters", style: .default) {
            [weak self] action in
            self?.petitions.removeAll(keepingCapacity: true)
            self?.petitions += self!.allPetitions
            self?.tableView.reloadData()
            
            // clearSearch loads again all the petitions, that have been
            //saved in a separate array called allPetitions.
            
        }
        ac.addAction(submitAction)
        ac.addAction(clearSearch)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        allPetitions += petitions
        for item in allPetitions {
            if item.title.lowercased().contains("\(answer.lowercased())") {
                searchedPetitions.append(item)
            }
        }
        petitions.removeAll(keepingCapacity: true)
        petitions += searchedPetitions
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

