//
//  DetailViewController.swift
//  23.Day-Project(1-3)-Milestone
//
//  Created by Sabir Myrzaev on 24.10.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    // MARK: - Variable
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    // MARK: - lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        title = "Countries \(selectedPictureNumber) of \(totalPictures)"
        countryLabel.text = selectedImage?.uppercased()
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButton))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    @objc func shareButton() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        guard let text = selectedImage?.uppercased() else { return }
        
        let vc = UIActivityViewController(activityItems: [image, text], applicationActivities: [])
        
        present(vc, animated: true, completion: nil)
    }
    


}
