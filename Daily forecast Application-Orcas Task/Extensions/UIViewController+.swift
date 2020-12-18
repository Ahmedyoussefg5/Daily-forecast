//
//  UIViewController+.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import UIKit

extension UIViewController {
    var withNavigationBarAdded: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    func getAlertWithCloseButton(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        return alert
    }
}
