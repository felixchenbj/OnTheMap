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
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var promptStackView: UIStackView!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func findOnTheMap(sender: UIButton) {
        updateUIAccordingToViewMode(.SubmitMode)
    }
    
    @IBOutlet weak var submitStackView: UIStackView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func submit(sender: UIButton) {
        updateUIAccordingToViewMode(.PromptMode)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUIAccordingToViewMode(.PromptMode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func updateUIAccordingToViewMode(mode: ViewMode) {
        currentViewMode = mode
        switch currentViewMode{
        case .PromptMode:
            print("PromptMode")
            
            UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                    self.submitStackView.alpha = 0
                }, completion: { finished in
                    
                    UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                        self.promptStackView.alpha = 1
                        //self.submitStackView.alpha = 0
                        }, completion: nil)
                    
                    self.promptStackView.hidden = false
                    self.submitStackView.hidden = true
            })
            
            cancelButton.setTitleColor(cancelButton.tintColor, forState: UIControlState.Normal)
        case .SubmitMode:
            print("SubmitMode")
            UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                self.promptStackView.alpha = 0
                }, completion: { finished in
                    
                    UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
                        self.submitStackView.alpha = 1
                        }, completion: nil)
                    
                    self.promptStackView.hidden = true
                    self.submitStackView.hidden = false
            })
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
}
