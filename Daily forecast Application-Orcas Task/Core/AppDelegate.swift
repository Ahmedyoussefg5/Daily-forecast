//
//  AppDelegate.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configAppWindow()
        setAppRootVC()
        return true
    }
    
    private func configAppWindow() {
        window = UIWindow()
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
    }
    
    private func setAppRootVC() {
        window?.rootViewController = HomeViewController.create().withNavigationBarAdded
    }
}

