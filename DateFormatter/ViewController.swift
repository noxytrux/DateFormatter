//
//  ViewController.swift
//  DateFormatter
//
//  Created by Marcin Pędzimąż on 05.08.2015.
//  Copyright (c) 2015 Marcin Małysz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var dates:[NSDate] = []
    var databaseQueue: FMDatabaseQueue! = nil
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.setup()
    }

    func setup() {
    
        self.dateTableView.hidden = true
        self.loadingIndicator.startAnimating()
        
        self.createDatabase { () -> Void in
    
            self.performMeasurement { () -> Void in
                
                self.dateTableView.reloadData()
                self.loadingIndicator.stopAnimating()
                self.dateTableView.hidden = false
            }
        }
    
    }
    
    func printTimeElapsedWhenRunningCode(title:String, operation: (() -> ())) {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        println("Time elapsed for \(title): \(timeElapsed) s")
    }
    
    func performMeasurement(completion:(() -> Void)) {
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
          
            self.databaseQueue.inDatabase({ (db:FMDatabase!) -> Void in
                
                db.logsErrors = true
                
                //load data
                
                var stringsArray:[String] = []
            
                var resultSet = db.executeQuery("SELECT iso_string FROM datestrings", withArgumentsInArray: nil)
                
                if db.hadError() == true {
                 
                    resultSet.close()
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        
                        completion()
                    })
                    
                    return
                }

                while resultSet.next() {
                
                    let resultDicitionary = resultSet.resultDictionary()
                    let dateString = resultDicitionary["iso_string"] as! String
                    
                    stringsArray.append(dateString)
                }
                
                resultSet.close()
                
                ////////////////////////////////////////////////////////
                //parse using NSDateFormatter
                
                self.printTimeElapsedWhenRunningCode("NSDateFromatter parsing", operation: { () -> () in

                    var datesFromNSDateFormatter:[NSDate] = []

                    for string in stringsArray {
                    
                        datesFromNSDateFormatter.append(NSDateFormatter.dateFromISOString(string))
                    }
                })
                
                ////////////////////////////////////////////////////////
                //parse using SQLFormatter
                
                self.printTimeElapsedWhenRunningCode("SQLDateFormatter parsing", operation: { () -> () in
                    
                    //assign adata so we can display it on table view
                    self.dates = SQLFormatter.parseDatesUsingStringArray(stringsArray) as! [NSDate]
                })
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    
                    //finish
                    completion()
                })

            })
        })
    }

}

