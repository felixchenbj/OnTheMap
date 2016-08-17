//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by felix on 8/12/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {

    var onTheMapModel: OnTheMapModel {
        get {
            return OnTheMapModel.sharedModel()
        }
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityClient.sharedUdacityClient().logoff { (info, success) in
            FunctionsHelper.performUIUpdatesOnMain({
                if success {
                    //UIHelper.switchToLoginView(self)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("Logoff failed: \(info)")
                }
            })
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        refreshData()
    }
    
    @IBAction func pin(sender: UIBarButtonItem) {
        UIHelper.switchToInformationPostingView(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.addTarget(self, action: #selector(LocationTableViewController.refreshStatusChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapModel.sharedModel().count()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationTableCell", forIndexPath: indexPath)
        
        if let location = OnTheMapModel.sharedModel().getStudentLocatAt(indexPath.row) {
            cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("table row selected: \(indexPath.row)")
        if let location = OnTheMapModel.sharedModel().getStudentLocatAt(indexPath.row) {
            var urlToOpen = location.mediaURL
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
    
    func refreshStatusChanged() {
        print("refreshStatusChanged")
        refreshData(true)
    }
    
    private func refreshData(forRefreshControl: Bool = false) {
        StudentLocationClient.sharedStudentLocationClient().fetchStudentLoactionList { (info, success) in
            FunctionsHelper.performUIUpdatesOnMain({
                if success {
                    self.tableView.reloadData()
                    
                    if forRefreshControl {
                        print("end refreshing")
                        self.refreshControl?.endRefreshing()
                    }
                } else {
                    print("Fetch student loaction failed: \(info)")
                    FunctionsHelper.popupAnOKAlert(self, title: "Error", message: "Fetch student loaction failed.", handler: nil)
                }
            })
        }

    }
}