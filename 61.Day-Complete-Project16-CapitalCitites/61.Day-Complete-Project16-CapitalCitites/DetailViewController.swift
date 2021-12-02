//
//  DetailViewController.swift
//  60.Day-Project16-CapitalCitites
//
//  Created by Sabir Myrzaev on 03.12.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: String?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        guard let url = URL(string: detailItem) else { return }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
}
