//
//  ViewController.swift
//  tutpt1
//
//  Created by Eric Pan on 6/5/14.
//  Copyright (c) 2014 Eric Pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var appsTableView : UITableView = nil
    // @IBOutlet var appsTableView : UITableView
    var data: NSMutableData = NSMutableData()
    var tableData: NSArray = NSArray()
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        println("Search iTunes API at URL \(url)")
        
        connection.start()
        
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        if jsonResult.count>0 && jsonResult["results"].count>0 {
            var results: NSArray = jsonResult["results"] as NSArray
            self.tableData = results
            self.appsTableView.reloadData()
            
        }
    }
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchItunesFor("Angry Birds")
        
        // Keep track of and contain the response
        var data: NSMutableData = NSMutableData()
        var tableData: NSArray = NSArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // This method asks for the number of rows in our section, normally the length of an array controller
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    // Create a new instance of UITableViewCell called cell, using Subtitle cell style
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.text = rowData["trackName"] as String
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        var urlString: NSString = rowData["artworkURL60"] as NSString
        var imgURL:NSURL = NSURL(string: urlString)
        
        // Download an NSData representation of the image at the URL
        var imgData: NSData = NSData(contentsOfURL: imgURL)
        cell.image = UIImage(data: imgData)
        
        // Get the formatted price string for display in the subtitle
        var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
        cell.detailTextLabel.text = formattedPrice
        
        return cell
    }
}

