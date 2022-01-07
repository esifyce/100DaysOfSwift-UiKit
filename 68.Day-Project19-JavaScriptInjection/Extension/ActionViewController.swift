//
//  ActionViewController.swift
//  Extension
//
//  Created by Sabir Myrzaev on 05.01.2022.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var pageTextView: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    
        // extensionContextпозволяет нам контролировать, как оно взаимодействует с родительским приложением. В этом случае inputItemsэто будет массив данных, которые родительское приложение отправляет нашему расширению для использования
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // входной элемент содержит массив вложений, которые передаются нам в виде файла NSItemProvider
            if let itemProvider = inputItem.attachments?.first {
                // попросить поставщика элемента фактически предоставить нам свой элемент
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else
                    {
                        return
                    }
                    guard let javascriptValues = itemDictionary[NSExtensionJavaScriptFinalizeArgumentKey] as? NSDictionary else
                    {
                        return
                    }
                    self?.pageTitle = javascriptValues["title"] as? String ?? ""
                    self?.pageURL = javascriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        let nonificationCenter = NotificationCenter.default
        nonificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        nonificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else
        {
            return
        }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            pageTextView.contentInset = .zero
        } else {
            pageTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        pageTextView.scrollIndicatorInsets = pageTextView.contentInset
        
        let selectedRange = pageTextView.selectedRange
        pageTextView.scrollRangeToVisible(selectedRange)
        
    }

    @IBAction func done() {
        
        let item = NSExtensionItem()
        // словарь содержащий ключ «customJavaScript» и значение
        let argument: NSDictionary = ["customJavaScript": pageTextView.text ?? ""]
        // cловарь в другой словарь с ключом
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        // большой словарь внутри NSItemProviderобъекта с идентификатором типа kUTTypePropertyList
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }

}
