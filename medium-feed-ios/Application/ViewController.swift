//
//  ViewController.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routeToMain()
    }
    
    func routeToMain() {
        
        guard
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        else {
            return
        }
        
        if let window = sceneDelegate.window {
            let appCoordinator = AppCoordinator(window: window)
            appCoordinator.start()
        }
        
    }


}

