//
//  ViewController.swift
//  50.Day-Milestone-Projects(10-12)
//
//  Created by Sabir Myrzaev on 24.11.2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variable
    var photo = [Photo]()
    
    // MARK: - lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        let defaults = UserDefaults.standard
        
        if let savedPhoto = defaults.object(forKey: "photo") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photo = try jsonDecoder.decode([Photo].self, from: savedPhoto)
            } catch {
                print("Failed to load photo")
            }
        }
        
    }
    // MARK: - Use camera & libraryPhoto
    @IBAction func cameraBarButton(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        let ac = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
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
    // MARK: - Codable
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photo) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photo")
        } else {
            print("Failed to save photo")
        }
    }
    
    // MARK: - UIImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let picture = Photo(name: "Unknown", image: imageName)
        photo.append(picture)
        save()
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
        
        let ac = UIAlertController(title: "Enter the name of the picture", message: nil, preferredStyle: .alert)
        
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                print(newName)
                picture.name = newName
                self?.save()
                self?.tableView.reloadData()
            }))
            present(ac, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: - TableViewController delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotoTableViewCell else { fatalError("Error cell") }
        
        let picture = photo[indexPath.row]
        
        cell.nameLabel.text = picture.name
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.photoImageView.image = UIImage(contentsOfFile: path.path)
        
        cell.photoImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.photoImageView.layer.borderWidth = 2
        cell.photoImageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        //let path = getDocuments
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = photo[indexPath.item]
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let pictureImageName = picture.image
            let pict = getDocumentsDirectory().appendingPathComponent(pictureImageName)
            
            vc.selectedImage = pict.path
                
               vc.selectedName = picture.name
       
               navigationController?.pushViewController(vc, animated: true)
           }
 
    }
}




