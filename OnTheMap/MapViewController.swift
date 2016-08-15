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
            return OnTheMapModel.sharedModel()
        }
    }
    
    var currentStudentLocationIndex = 0
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func logout(sender: UIBarButtonItem) {
        onTheMapModel.udacityClient.logoff { (info, success) in
            FunctionsHelper.performUIUpdatesOnMain({
                if success {
                    UIHelper.switchToLoginView(self)
                } else {
                    print("Logoff failed: \(info)")
                }
            })
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        onTheMapModel.studentLocationClient.fetchStudentLoactionList { (info, success) in
            FunctionsHelper.performUIUpdatesOnMain({
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
        UIHelper.switchToInformationPostingView(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        addAnnotationsFromStudentLocations()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let currentStudentLocation = onTheMapModel.studentLocationClient.getStudentLocatAt(currentStudentLocationIndex) {
            print("centerMapOnStudentLocation, first location")
            FunctionsHelper.centerMapOnStudentLocation(currentStudentLocation, mapView: mapView)
        }
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
            if let toOpen = view.annotation?.subtitle! {
                print("Open the URL in annotation: \(toOpen)")
                var urlToOpen = toOpen
                if !urlToOpen.hasPrefix(Constants.ApiScheme) {
                    urlToOpen = Constants.ApiScheme + "://" + urlToOpen
                }
                if let url  = NSURL(string: urlToOpen) {
                    if UIApplication.sharedApplication().canOpenURL(url) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
            }
        }
    }
}
