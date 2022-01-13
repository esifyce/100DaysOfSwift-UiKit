//
//  DetailViewController.swift
//  74.Day-Project(19-21)-Milestone
//
//  Created by Sabir Myrzaev on 13.01.2022.
//

import UIKit

class DetailViewController: UIViewController {
     
     var notes = [Note]()
     
     // MARK: - Outlets
     @IBOutlet weak var noteTextView: UITextView!
     
     var titleNote = ""
     var textNote = ""
     var rowNote: Int?
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          title = titleNote
          noteTextView.text = textNote
          
          // nav bar butt
          let doneTapButt = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveTapped))
          let deleteTapButt = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
          let shareTapButt = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
          
          navigationItem.rightBarButtonItems = [doneTapButt, shareTapButt, deleteTapButt]
          
          // solve problem with keyboard
          let nonificationCenter = NotificationCenter.default
          nonificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
          nonificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
          checkNotes()
     }
     
     override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          // change tint color button in navBar
          navigationController?.navigationBar.barStyle = UIBarStyle.default
          navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
     }
     
     override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(true)
          // save data when we disappear vc
          textNote = noteTextView.text
          save()
     }
     // MARK: - Solve problem keyboard
     @objc func adjustForKeyboard(notification: Notification) {
          guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else
          {
               return
          }
          
          let keyboardScreenEndFrame = keyboardValue.cgRectValue
          let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
          
          if notification.name == UIResponder.keyboardWillHideNotification {
               noteTextView.contentInset = .zero
          } else {
               noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
          }
          
          noteTextView.scrollIndicatorInsets = noteTextView.contentInset
          
          let selectedRange = noteTextView.selectedRange
          noteTextView.scrollRangeToVisible(selectedRange)
          
     }
     // MARK: - Button Save&Delete&Share
     @objc func deleteTapped() {
          if let vc = storyboard?.instantiateViewController(withIdentifier: "main") as? ViewController {
               navigationController?.popToRootViewController(animated: true)
               checkNotes()
               vc.tableView.reloadData()
               if let rowToDelete = rowNote {
                    vc.notes.remove(at: rowToDelete)
                    vc.tableView.reloadData()
                    vc.save()
               }
          }
     }
     
     @objc func saveTapped() {
          navigationController?.popViewController(animated: true)
          textNote = noteTextView.text
          save()
          
     }
     
     // MARK: - UserDefaults Save&Load&Check
     func save() {
          if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: textNote, requiringSecureCoding: false) {
               let defaults = UserDefaults.standard
               defaults.set(savedData,forKey: "\(rowNote ?? 0)")
          }
     }
     
     func loadNotes(_ keyNote: String) {
          let defaults = UserDefaults.standard
          
          if let savedText = defaults.object(forKey: keyNote) as? Data {
               if let decodedText = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedText) as? String {
                    noteTextView.text = decodedText
               }
          }
     }
     
     func checkNotes() {
          loadNotes("\(rowNote ?? 0)")
     }
}
