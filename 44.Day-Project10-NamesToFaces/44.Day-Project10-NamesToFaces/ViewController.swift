//
//  ViewController.swift
//  42.Day-Project10-NamesToFaces
//
//  Created by Sabir Myrzaev on 17.11.2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variable
    var people = [Person]()
    
    // MARK: - lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    // touch image
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        let ac = UIAlertController(title: "CHOOSE", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
            picker.sourceType = .photoLibrary
            self?.present(picker, animated: true, completion: nil)
        }))
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            picker.sourceType = .camera
            self?.present(picker, animated: true, completion: nil)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: - CollectionViewController settings
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else { fatalError(" ERROR: deqreuse cell") }
        
        let person = people[indexPath.item]
        
        cell.nameLabel.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let mainAC = UIAlertController(title: "Choose", message: "What're you wanted? RENAME or Delete photos", preferredStyle: .alert)
        mainAC.addAction(UIAlertAction(title: "RENAME", style: .default, handler: { [weak self] _ in
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            }))
            self?.present(ac, animated: true, completion: nil)
        }))
        mainAC.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { _ in
            person.image = ""
            collectionView.reloadData()
        }))
        
        present(mainAC, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}

