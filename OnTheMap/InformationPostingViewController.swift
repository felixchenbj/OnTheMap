//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by felix on 8/12/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {
    
    enum ViewMode {
        case PromptMode
        case SubmitMode
    }
    var currentViewMode = ViewMode.PromptMode
    
    var studentLocation: StudentLocation!
    
    var onTheMapModel: OnTheMapModel {
        get {
            return OnTheMapModel.sharedModel()
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var promptStackView: UIStackView!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func findOnTheMap(sender: UIButton) {
        if let address = addressTextField.text {
            if address.isEmpty {
                FunctionsHelper.popupAnOKAlert(self, title: "Warning", message: "The address should not be empty. Please input a address.", handler: nil)
            } else {
                
                activityIndicator.startAnimating()
                
                findAddressOnMap(address, completionHandler: { (studentLocation, success) in
                    FunctionsHelper.performUIUpdatesOnMain({
                        if success {
                            self.studentLocation = studentLocation
                            if let annotation = self.generateAnnotationFromStudentLocation() {
                                self.clearAllAnnotations()
                                self.mapView.addAnnotation(annotation)
                                FunctionsHelper.centerMapOnStudentLocation(self.studentLocation, mapView: self.mapView)
                            }
                            self.updateUIAccordingToViewMode(.SubmitMode)
                            
                        } else {
                            FunctionsHelper.popupAnOKAlert(self, title: "Error", message: "Invalid address. Please try another address.", handler: { action in
                                self.addressTextField.text = ""
                            })
                        }
                        self.activityIndicator.stopAnimating()
                    })
                })
            }
        }
    }
    
    @IBOutlet weak var submitStackView: UIStackView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func submit(sender: UIButton) {
        if validateValueOfTextField() {
            studentLocation.mediaURL = linkTextField.text!
            
            postStudentLocation()
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        studentLocation = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUIAccordingToViewMode(.PromptMode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func updateUIAccordingToViewMode(mode: ViewMode, animated: Bool = true) {
        currentViewMode = mode
        switch currentViewMode{
        case .PromptMode:
            print("PromptMode")
            
            if animated {
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                    self.submitStackView.alpha = 0
                    }, completion: { finished in
                        
                        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                            self.promptStackView.alpha = 1
                            }, completion: nil)
                        
                        self.promptStackView.hidden = false
                        self.submitStackView.hidden = true
                })
            } else {
                self.promptStackView.hidden = false
                self.submitStackView.hidden = true
            }
            
            cancelButton.setTitleColor(cancelButton.tintColor, forState: UIControlState.Normal)
        case .SubmitMode:
            print("SubmitMode")
            if animated {
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                    self.promptStackView.alpha = 0
                    }, completion: { finished in
                        
                        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                            self.submitStackView.alpha = 1
                            }, completion: nil)
                        
                        self.promptStackView.hidden = true
                        self.submitStackView.hidden = false
                })
            } else {
                self.promptStackView.hidden = true
                self.submitStackView.hidden = false
            }
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    func generateAnnotationFromStudentLocation() -> MKPointAnnotation?{
        
        if let studentLocation = studentLocation {
            let annotation = MKPointAnnotation()
            
            let latitude = CLLocationDegrees(studentLocation.latitude)
            let longitude = CLLocationDegrees(studentLocation.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            annotation.coordinate = coordinate
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaURL
            return annotation
        }
        return nil
    }

    func clearAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func findAddressOnMap(address: String, completionHandler: (studentLocation: StudentLocation?, success: Bool) -> Void) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
                print("completion")
                guard error == nil else {
                    print(error)
                    completionHandler(studentLocation: nil, success: false)

                    return
                }
                
                if placemarks?.count > 0 {
                    let placemark = placemarks![0]
                    print(placemark.name, placemark.country, placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare)
                    
                    var studentLocation = StudentLocation()
                    
                    studentLocation.mapString = address
                    studentLocation.latitude = (placemark.location?.coordinate.latitude)!
                    studentLocation.longitude = (placemark.location?.coordinate.longitude)!
                    
                    studentLocation.uniqueKey = UdacityClient.sharedUdacityClient().accountKey
                    
                    studentLocation.firstName = UdacityClient.sharedUdacityClient().firstName
                    studentLocation.lastName = UdacityClient.sharedUdacityClient().lastName
                    
                    completionHandler(studentLocation: studentLocation, success: true)
                    return
                }
            
                completionHandler(studentLocation: nil, success: false)
        }
    }
    
    func postStudentLocation() {
        
        if let studentLocation = studentLocation {
            StudentLocationClient.sharedStudentLocationClient().postStudentLocation(studentLocation, completionHandler: { (info, success) in
                FunctionsHelper.performUIUpdatesOnMain({
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    FunctionsHelper.popupAnOKAlert(self, title: "Error", message: "Post student location failed: \(info)", handler: nil)
                }
                })
            })
        }
    }
    
    func validateValueOfTextField() -> Bool{
        if let linkString = linkTextField.text {
            if linkString.isEmpty {
            FunctionsHelper.popupAnOKAlert(self, title: "Warning", message: "The link should not be empty. Please input a link.", handler: nil)
            return false
            }
            if let url  = NSURL(string: linkString) {
                if !UIApplication.sharedApplication().canOpenURL(url) {
                    FunctionsHelper.popupAnOKAlert(self, title: "Error", message: "Invalid link. Please try another link.", handler: nil)
                    return false
                }
            }
        } else {
            FunctionsHelper.popupAnOKAlert(self, title: "Error", message: "Invalid link. Please try another link.", handler: nil)
            return false
        }
        return true
    }
}
