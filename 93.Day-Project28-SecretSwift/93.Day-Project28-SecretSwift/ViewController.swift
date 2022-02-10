//
//  ViewController.swift
//  92.Day-Project28-SecretSwift
//
//  Created by Sabir Myrzaev on 09.02.2022.
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    @IBOutlet var authButton: UIButton!
    @IBOutlet var passButtom: UIButton!
    
    let password = "123"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)

    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in

                DispatchQueue.main.async {
                    if success {
                        self.unlockSecretMessage()
                    } else {
                        // error
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no boimetry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    @IBAction func passAuth(_ sender: Any) {
        let ac = UIAlertController(title: "Enter your password", message: nil, preferredStyle: .alert)
                    ac.addTextField()
                    
                ac.addAction(UIAlertAction(title: "Password", style: .default, handler: {[weak self, weak ac]  _ in
                    guard let textTF = ac?.textFields?[0].text else { return }
                    if textTF == self?.password {
                        self?.unlockSecretMessage()
                    } else {
                        self?.saveSecretMessage()
                    }
                    
                }))
                            
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(ac, animated: true)
    }
    
    @objc func closeAuth() {
        saveSecretMessage()
    }

    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeAuth))
        
        navigationItem.rightBarButtonItem = rightButton
        
        secret.isHidden = false
        authButton.isHidden = true
        passButtom.isHidden = true

        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        authButton.isHidden = false
        passButtom.isHidden = false
        navigationItem.rightBarButtonItem = nil
        
        title = "Nothing to see here"
        
    }

}

