//
//  UIHelper.swift
//  OnTheMap
//
//  Created by felix on 8/15/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit

struct UIHelper {
    static func switchToLoginView(currentViewController: UIViewController) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        currentViewController.presentViewController(resultVC, animated: true, completion:nil)
    }
    
    static func switchToInformationPostingView(currentViewController: UIViewController) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        
        currentViewController.presentViewController(resultVC, animated: true, completion:nil)
    }
}
