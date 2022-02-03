//
//  ViewController.swift
//  82.Day-Project(22-24)-Milestone
//
//  Created by Sabir Myrzaev on 03.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var circleView: UIView!
    
    var array = [1, 5, 8, 6, 4, 2, 1, 2]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        circleView.bounceOut(duration: 5)
        5.times()
        
        array.remove(item: 1)
        
        for i in array {
            print(i)
        }
    }
}

extension UIView {
    func bounceOut(duration: TimeInterval ) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.0001, y: 0.0001)
        }
    }
}

extension Int {
    func times() {
        for _ in 0..<self {
            print("Hello!")
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        let itemIndex = self.firstIndex(of: item)
        if let firstItemIndex = itemIndex {
            remove(at: firstItemIndex)
        }
    }
}
