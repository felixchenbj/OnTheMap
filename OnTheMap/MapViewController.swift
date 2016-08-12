//
//  MapViewController.swift
//  OnTheMap
//
//  Created by felix on 8/11/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

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
                    print("Logoff failed: \(info)")
                }
            })
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        onTheMapModel.studentLocationClient.fetchStudentLoactionList { (info, success) in
            HelperFunctions.performUIUpdatesOnMain({
                if success {
                    self.clearAllAnnotations()
                    self.addAnnotationsFromStudentLocations()
                } else {
                    print("Fetch student loaction failed: \(info)")
                }
            })

        }
    }
    
    @IBAction func pin(sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAnnotationsFromStudentLocations()
        
        mapView.delegate = self
    }
    
    func switchBackToLogin() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")as! LoginViewController
        
        presentViewController(resultVC, animated: true, completion:nil)
    }
    
    func clearAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func addAnnotationsFromStudentLocations() {
         mapView.addAnnotations(generateAnnotationsFromStudentLocations())
    }
    
    func generateAnnotationsFromStudentLocations() -> [MKPointAnnotation]{
        var annotations = [MKPointAnnotation]()
        
        let locations = onTheMapModel.studentLocationClient.studentLocationList
        
        for location in locations {
            let annotation = MKPointAnnotation()
            
            let latitude = CLLocationDegrees(location.latitude)
            let longitude = CLLocationDegrees(location.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            
            annotations.append(annotation)
        }

        return annotations
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if var toOpen = view.annotation?.subtitle! {
                print("Open the URL in annotation: \(toOpen)")
                if !toOpen.hasPrefix(Constants.ApiScheme) {
                    toOpen = Constants.ApiScheme + "://" + toOpen
                }
                UIApplication.sharedApplication().openURL(NSURL(string: toOpen)!)
            }
        }
    }
}
