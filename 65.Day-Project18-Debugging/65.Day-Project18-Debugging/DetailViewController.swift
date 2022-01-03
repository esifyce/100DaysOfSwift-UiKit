//
//  DetailViewController.swift
//  17.Day-Project1-StormViewer
//
//  Created by Sabir Myrzaev on 20.10.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!

    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    var isCheckImage = false
    
    // MARK: - lifecycle VC
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pictures \(selectedPictureNumber) of \(totalPictures)"
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            isCheckImage = true
            assert(isCheckImage == true, "Image always has a value!")
        }
        
        isCheckImage = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
