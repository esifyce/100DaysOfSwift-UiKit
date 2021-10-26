//
//  ListViewController.swift
//  25.Day-Project4-WebView
//
//  Created by Sabir Myrzaev on 26.10.2021.
//

import UIKit

class ListViewController: UITableViewController {
    
    var websites = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = true

        
        websites += ["apple.com", "hackingwithswift.com"]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {
            
            vc.selectedWebsite = websites[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }


}
