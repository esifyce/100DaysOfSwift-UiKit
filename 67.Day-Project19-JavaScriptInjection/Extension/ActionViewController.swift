//
//  ActionViewController.swift
//  Extension
//
//  Created by Sabir Myrzaev on 05.01.2022.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // extensionContextпозволяет нам контролировать, как оно взаимодействует с родительским приложением. В этом случае inputItemsэто будет массив данных, которые родительское приложение отправляет нашему расширению для использования
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // входной элемент содержит массив вложений, которые передаются нам в виде файла NSItemProvider
            if let itemProvider = inputItem.attachments?.first {
                // попросить поставщика элемента фактически предоставить нам свой элемент
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // code
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
