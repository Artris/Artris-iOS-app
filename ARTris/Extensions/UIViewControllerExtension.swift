//
//  UIViewControllerExtension.swift
//  ARTris
//
//  Created by Grazietta Hof on 2017-11-15.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentView(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.duration = 0.2
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewController, animated: false, completion: nil)
    }
}
