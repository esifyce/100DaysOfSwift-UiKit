//
//  ViewController.swift
//  83.Day-Project25-SelfieShare
//
//  Created by Sabir Myrzaev on 03.02.2022.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?

    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Selfie Share"
        let connectedPeersButton = UIBarButtonItem(title: "Users", style: .plain, target: self, action: #selector(showConnectedPeers))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPromt))
        
        let pictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let textButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(sendText))
        
        navigationItem.leftBarButtonItems = [addButton, connectedPeersButton]
        navigationItem.rightBarButtonItems = [pictureButton, textButton]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    @objc func showConnectedPeers() {
        guard let mcSession = mcSession else { return }
        
        var users = ""
        for i in mcSession.connectedPeers {
            users += i.displayName + "\n"
        }
        
        if isConnected == true {
            let ac = UIAlertController(title: "Users in session", message: users, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            DispatchQueue.main.async { [weak self] in
                self?.present(ac, animated: true)
            }
        }
    }
    
    @objc func sendText() {
        let ac = UIAlertController(title: "Send message", message: nil, preferredStyle: .alert)
                       ac.addTextField()
                       
                let sendAction = UIAlertAction(title: "Send", style: .default) {
                    [weak self, weak ac] _ in
                           
                    guard let message = ac?.textFields?[0].text else { return }
                    
                    guard let mcSession = self?.mcSession else { return }
                           
                    if mcSession.connectedPeers.count > 0 {
                        let textData = Data(message.utf8)
                        do {
                            try mcSession.send(textData, toPeers: mcSession.connectedPeers, with: .reliable)
                            print("Message sent.")
                        } catch {
                            let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(ac, animated: true)
                        }
                    }
                }
                ac.addAction(sendAction)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(ac, animated: true)
    }
    
    @objc func showConnectionPromt() {
        let ac = UIAlertController(title: "Connecnt to otherts", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting(action:)))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send Error", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true, completion: nil)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected \(peerID.displayName)")
                isConnected = true
        case .connecting:
            print("Connecting \(peerID.displayName)")
        default:
            print("notConnected \(peerID.displayName)")
            if isConnected == true {
                DispatchQueue.main.async { [weak self] in
                    let ac = UIAlertController(title: "User disconnected", message: "\(peerID.displayName)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                    self?.isConnected = false
                }
                
            }
            isConnected = false
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }


}

