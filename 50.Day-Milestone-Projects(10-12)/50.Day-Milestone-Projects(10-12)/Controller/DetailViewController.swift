//
//  DetailViewController.swift
//  50.Day-Milestone-Projects(10-12)
//
//  Created by Sabir Myrzaev on 24.11.2021.
//

import UIKit

class DetailViewController: UIViewController {
        
    @IBOutlet weak var photoImageView: UIImageView!
    
    var selectedImage: String?
    var selectedName: String?


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(selectedName ?? "")"
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            photoImageView.image = UIImage(contentsOfFile: imageToLoad)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
