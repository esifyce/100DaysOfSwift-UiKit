//
//  ViewController.swift
//  23.Day-Project(1-3)-Milestone
//
//  Created by Sabir Myrzaev on 24.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - Variable
    var countries = [String]()
    
    // MARK: - lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Milestone"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "spain", "uk", "us"]
    }
}

// MARK: - TableVC extension
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            vc.selectedImage = countries[indexPath.row]
            vc.totalPictures = countries.count
            vc.selectedPictureNumber = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
