//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by felix on 8/11/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var originalViewY: CGFloat = 0.0
    var keyboardToMove: CGFloat = 0.0
    
    var onTheMapModel: OnTheMapModel {
        get {
            return OnTheMapModel.sharedModel()
        }
    }
    
    @IBAction func login(sender: UIButton) {
        updateUI(true)
        
        onTheMapModel.udacityClient.login(usernameTextField.text!, password: passwordTextField.text!) { (info, success) in
            FunctionsHelper.performUIUpdatesOnMain({
                if success {
                    self.loginCompleted()
                } else {
                    
                    if let info = info {
                        print("Login failed: \(info)")
                        FunctionsHelper.popupAnOKAlert(self, title: "Error", message: "Login failed: "+info, handler: nil)
                    }
                    
                    self.updateUI(false)
                }
            })
        }
    }
    
    @IBAction func signUp(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: Constants.Udacity.SignupLink)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalViewY = self.view.frame.origin.y
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUI(false)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if isEditingTextFieldWouldBeCoveredByKeyboard(notification) {
            adjustViewToFitKeyboard(notification, offset: keyboardToMove * (-1))
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustViewToFitKeyboard(notification, offset: originalViewY)
    }
    
    func adjustViewToFitKeyboard(notification:NSNotification, offset: CGFloat) {
        var userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            self.view.frame.origin.y = offset
        } )
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func isEditingTextFieldWouldBeCoveredByKeyboard(notification: NSNotification) -> Bool{
        var result = false
        if let userInfo = notification.userInfo,
            keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            // if the editing textfield would be covered
            for textfield in [ usernameTextField, passwordTextField] {
                if textfield.editing && keyboardSize.CGRectValue().intersects(textfield.frame) {
                    keyboardToMove = textfield.frame.origin.y - textfield.frame.height
                    result = true
                }
            }
        }
        return result
    }
    
    func loginCompleted() {
        onTheMapModel.udacityClient.getUserInfo { (info, success) in
            FunctionsHelper.performUIUpdatesOnMain({
                if !success {
                    FunctionsHelper.popupAnOKAlert(self, title: "Error", message: "Failed to get user's information.", handler: nil)
                }
            })
        }
        onTheMapModel.studentLocationClient.fetchStudentLoactionList { (info, success) in
            FunctionsHelper.performUIUpdatesOnMain({
                if success {
                    self.switchToTabView()
                } else {
                    FunctionsHelper.popupAnOKAlert(self, title: "Error", message: "Fetch student loaction failed.", handler: nil)
                    
                    self.updateUI(false)
                }
            })
        }
    }
    
    func switchToTabView() {
        performSegueWithIdentifier("showTabView", sender: self)
    }
    
    func updateUI(loggingin: Bool) {
        if loggingin {
            loginButton.enabled = false
        } else {
            loginButton.enabled = true
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            loginButton.setTitle("Authorizing...", forState: UIControlState.Disabled)
        }
    }
}
