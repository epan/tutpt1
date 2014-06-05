//
//  ViewController.swift
//  tutpt1
//
//  Created by Eric Pan on 6/5/14.
//  Copyright (c) 2014 Eric Pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // This method asks for the number of rows in our section, normally the length of an array controller
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 10 // Number of rows hard-coded to 10
    }
    
    // Create a new instance of UITableViewCell called cell, using Subtitle cell style
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        cell.text = "Row #\(indexPath.row)"
        cell.detailTextLabel.text = "Subtitle #\(indexPath.row)"
        
        return cell
    }
}

