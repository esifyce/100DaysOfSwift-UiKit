//
//  ViewController.swift
//  90.Day-Project(25-27)-Milestone
//
//  Created by Sabir Myrzaev on 08.02.2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var setImportButton: UIButton!
    @IBOutlet var setTopButton: UIButton!
    @IBOutlet var setBottomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImportButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setTopButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setBottomButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        setImportButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        setTopButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        setBottomButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        
        setImportButton.addTarget(self, action: #selector(buttonCancel), for: .touchDragExit)
        setTopButton.addTarget(self, action: #selector(buttonCancel), for: .touchDragExit)
        setBottomButton.addTarget(self, action: #selector(buttonCancel), for: .touchDragExit)

        setImportButton.addTarget(self, action: #selector(buttonDragInside), for: .touchDragInside)
        setTopButton.addTarget(self, action: #selector(buttonDragInside), for: .touchDragInside)
        setBottomButton.addTarget(self, action: #selector(buttonDragInside), for: .touchDragInside)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func importPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func setTopText(_ sender: Any) {
        let ac = UIAlertController(title: "Set top text:", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
        ac.addAction(UIAlertAction(title: "Set", style: .default) { [weak self, weak ac] _ in
            guard let topText = ac?.textFields?[0].text else { return }
            
                let imageSize = self?.imageView.image?.size
                if let imageSize = imageSize {
                    let renderer = UIGraphicsImageRenderer(size: imageSize)
                    
                    let image = renderer.image { ctx in
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .center
                    
                        let attrs: [NSAttributedString.Key: Any] = [
                            .font: UIFont(name: "Avenir", size: 120)!,
                            .paragraphStyle: paragraphStyle,
                            .foregroundColor: UIColor(white: 1, alpha: 1),
                            .strokeWidth: -3,
                            .strokeColor: UIColor.black
                        ]
                    
                        let string = topText
                    
                        let attributedString = NSAttributedString(string: string, attributes: attrs)
                    
                        let imageToDraw = self?.imageView.image
                        imageToDraw?.draw(at: CGPoint(x: 0, y: 0))
                        
                        attributedString.draw(with: CGRect(x: 0, y: 0, width: (imageToDraw?.size.width)!, height: 200), options: .usesLineFragmentOrigin, context: nil)
                                            
                    }
                    
                    self?.imageView.alpha = 0
                    self?.dismiss(animated: true)
                    self?.imageView.image = image
                    
                    UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                        self?.imageView.alpha = 1
                    })
                }
            })

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    @IBAction func setBottomText(_ sender: Any) {
    let ac = UIAlertController(title: "Set bottom text:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
    ac.addAction(UIAlertAction(title: "Set", style: .default) { [weak self, weak ac] _ in
        guard let topText = ac?.textFields?[0].text else { return }
        
            let imageSize = self?.imageView.image?.size
            if let imageSize = imageSize {
                let renderer = UIGraphicsImageRenderer(size: imageSize)
                
                let image = renderer.image { ctx in
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                
                    let attrs: [NSAttributedString.Key: Any] = [
                        .font: UIFont(name: "Arial", size: 120)!,
                        .paragraphStyle: paragraphStyle,
                        .foregroundColor: UIColor(white: 1, alpha: 1),
                        .strokeWidth: -3,
                        .strokeColor: UIColor.black
                    ]
                   
                    let string = topText
                
                    let attributedString = NSAttributedString(string: string, attributes: attrs)
                
                    let imageToDraw = self?.imageView.image
                    imageToDraw?.draw(at: CGPoint(x: 0, y: 0))
                    
                    attributedString.draw(with: CGRect(x: 0, y: (imageToDraw?.size.height)! - 170, width: (imageToDraw?.size.width)!, height: 200), options: .usesLineFragmentOrigin, context: nil)
                    
                }
                self?.imageView.alpha = 0
                self?.dismiss(animated: true)
                self?.imageView.image = image
                
                UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                    self?.imageView.alpha = 1
                })
            }
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.alpha = 0
        dismiss(animated: true)
        imageView.image = image
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.imageView.alpha = 1
        })
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 30, options: [], animations: {
            sender.transform = .identity
        })
    }
    
    @objc func buttonDown(_ sender: UIButton) {
       UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 30, options: [], animations: {
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
       })
    }
    
    @objc func buttonCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 30, options: [], animations: {
            sender.transform = .identity
        })
    }
    
    @objc func buttonDragInside(_ sender: UIButton) {
       UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 30, options: [], animations: {
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
       })
    }
    
}
