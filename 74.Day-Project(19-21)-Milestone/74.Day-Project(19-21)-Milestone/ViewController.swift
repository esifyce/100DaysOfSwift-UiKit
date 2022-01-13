//
//  ViewController.swift
//  74.Day-Project(19-21)-Milestone
//
//  Created by Sabir Myrzaev on 13.01.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        loadNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
            navigationController?.navigationBar.barStyle = UIBarStyle.default
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            loadNotes()
            tableView.reloadData()
        }
    
    // MARK: - navigation bar button
    @objc func addNote() {
        let note = Note(name: "Unknown", text: "")
                
        let ac = UIAlertController(title: "Enter the name new NOTE:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let newNote = ac?.textFields?[0].text else { return }
            note.name = newNote
            self?.notes.insert(note, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
            self?.save()
                     }))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func deleteNote() {
        print("delete Note")
    }
    
    // MARK: - Save&Load Notes
    
    func loadNotes() {
        let defaults = UserDefaults.standard

        if let notesToLoad = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                notes = try jsonDecoder.decode([Note].self, from: notesToLoad)
                print("Notes loaded to table view successfully.")
            } catch {
                print("Failed to load notes.")
            }
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save notes.")
        }
    }
    
}

// MARK: - TableView delegate/data source
extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = notes[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            vc.titleNote = notes[indexPath.row].name
            vc.textNote = notes[indexPath.row].text
            vc.rowNote = indexPath.row
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        save()
    }
}
