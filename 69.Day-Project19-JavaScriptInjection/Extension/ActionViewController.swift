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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
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
        
        let defaults = UserDefaults.standard
        
        if let savedText = defaults.object(forKey: "text") as? Data {
            if let decodedText = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedText) as? String {
                pageTextView.text = decodedText
            }
        }
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
    
    @objc func add() {
        let ac = UIAlertController(title: "Please Select an Option", message: nil, preferredStyle: .actionSheet)
        pageTextView.text = ""
        ac.addAction(UIAlertAction(title: "PRINT", style: .default, handler: { [weak self] _ in
            self?.pageTextView.text = "print(document.title);"
        }))
        ac.addAction(UIAlertAction(title: "ALERT", style: .default, handler: { [weak self] _ in
            self?.pageTextView.text = "alert(document.title);"
        }))
        ac.addAction(UIAlertAction(title: "BLUE", style: .default,handler: blueBackground(_:)))
        ac.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: nil))
        
        present(ac, animated: true, completion: nil)
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
        save()
    }
    
    func blueBackground (_ action: UIAlertAction) {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": "document.body.style.background = \"lightblue\";"]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    // MARK: - UserDefaults
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: pageTextView.text ?? "none", requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData,forKey: "text")
        }
    }
}

