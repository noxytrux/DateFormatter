//
//  ViewController+Database.swift
//  DateFormatter
//
//  Created by Marcin Pędzimąż on 05.08.2015.
//  Copyright (c) 2015 Marcin Małysz. All rights reserved.
//

import UIKit

let kMaximumDatabaseObjects:Int! = 250000

extension ViewController {
    
    private class func databaseDirectory() -> String {
    
        let documentsDirectoryPath: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return documentsDirectoryPath.stringByAppendingPathComponent("databse.db")
    }
    
    private class func databaseExist() -> Bool {
    
        let fileManager = NSFileManager.defaultManager()
    
        return fileManager.fileExistsAtPath(self.databaseDirectory())
    }
    
    func createDatabase(completion: (()->Void)) {
    
        if ViewController.databaseExist() == true {
        
            self.databaseQueue = FMDatabaseQueue(path: ViewController.databaseDirectory())
            
            completion()
            return
        }
        
        var database: FMDatabase! = FMDatabase(path: ViewController.databaseDirectory())
        
        database.open()

        let filePath = NSBundle.mainBundle().pathForResource("db_script", ofType: "sql")
        
        var error:NSError? = nil
        
        let script = NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: &error)
        
        if let error = error {
        
            println("Error while loading script \(error)")
        }
        
        let utf8String = script?.UTF8String
        
        sqlite3_exec(database.sqliteHandle(), utf8String!, nil, nil, nil)
        
        println("loading script: \(NSString(CString: sqlite3_errmsg(database.sqliteHandle()), encoding: NSASCIIStringEncoding))")
        
        database.close()
        
        self.databaseQueue = FMDatabaseQueue(path: ViewController.databaseDirectory())
        
        //generate dummy data

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in

            self.databaseQueue.inTransaction({ (db:FMDatabase!, rollback:UnsafeMutablePointer<ObjCBool>) -> Void in
                
                db.logsErrors == true
              
                let query = "INSERT OR REPLACE INTO datestrings (iso_string) VALUES (?)"
                
                for index in 0...kMaximumDatabaseObjects {
                
                    let date = NSDate(timeIntervalSinceNow: NSTimeInterval(index * 100))
                    
                    var updated = db.executeUpdate(query, withArgumentsInArray: [NSDateFormatter.ISOStringFromDate(date)])
                    
                    if updated == false {
                    
                        break
                    }
                }
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    
                    completion()
                })
            })
        })
    }
    
}