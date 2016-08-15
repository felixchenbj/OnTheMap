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
                    self.tableView.reloadData()
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
        
        refreshControl?.addTarget(self, action: #selector(LocationTableViewController.refreshStatusChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onTheMapModel.studentLocationClient.studentLocationList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationTableCell", forIndexPath: indexPath)
        
        if let location = onTheMapModel.studentLocationClient.getStudentLocatAt(indexPath.row) {
            cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("table row selected: \(indexPath.row)")
        
        if let tabBarController = tabBarController {
            if let mapViewController = tabBarController.viewControllers?[0].childViewControllers[0] as? MapViewController {
                mapViewController.currentStudentLocationIndex = indexPath.row
            }
        }
        
        // switch to map view
        tabBarController?.selectedIndex = 0
    }
    
    
    func refreshStatusChanged() {
        print("refreshStatusChanged")
        onTheMapModel.studentLocationClient.fetchStudentLoactionList { (info, success) in
            FunctionsHelper.performUIUpdatesOnMain({
                if success {
                    self.tableView.reloadData()
                    print("end refreshing")
                    self.refreshControl?.endRefreshing()
                } else {
                    print("Fetch student loaction failed: \(info)")
                }
            })
        }
    }
}