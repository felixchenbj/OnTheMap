//
//  MapViewController.swift
//  OnTheMap
//
//  Created by felix on 8/11/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var onTheMapModel: OnTheMapModel {
        get {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            return appDelegate.onTheMapModel
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func logout(sender: UIBarButtonItem) {
        onTheMapModel.udacityClient.logoff { (info, success) in
            HelperFunctions.performUIUpdatesOnMain({
                if success {
                    self.switchBackToLogin()
                } else {
                    print("Logoff failed: \(info)")                }
            })
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
    }
    
    @IBAction func pin(sender: UIBarButtonItem) {
    }
    
    
    func switchBackToLogin() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")as! LoginViewController
        
        presentViewController(resultVC, animated: true, completion:nil)
    }
}
