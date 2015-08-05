//
//  ViewControllerDataSource.swift
//  DateFormatter
//
//  Created by Marcin Pędzimąż on 05.08.2015.
//  Copyright (c) 2015 Marcin Małysz. All rights reserved.
//

import Foundation

let kDefaultTableCellHeight:CGFloat! = 60

extension ViewController : UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dates.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return kDefaultTableCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("DateFormatterCellIdentifier", forIndexPath: indexPath) as! FormatterTableViewCell
        
        let date = self.dates[indexPath.row]
        
        cell.textLabel?.text = NSDateFormatter.ISOStringFromDate(date)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //empty
    }
}