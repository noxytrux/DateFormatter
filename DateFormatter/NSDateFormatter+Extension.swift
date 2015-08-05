//
//  NSDateFormatter+Extension.swift
//  DateFormatter
//
//  Created by Marcin Pędzimąż on 05.08.2015.
//  Copyright (c) 2015 Marcin Małysz. All rights reserved.
//

import UIKit

extension NSDateFormatter {

    private static let genericFormatter = NSDateFormatter.databaseISO8601FormatterFactory()
   
    private class func databaseISO8601FormatterFactory() -> NSDateFormatter {
        
        let formatter = NSDateFormatter()
        
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return formatter
    }
    
    //MARK: public interface
    
    class func ISOStringFromDate(date:NSDate) -> String {
        
        return self.genericFormatter.stringFromDate(date)
    }
    
    class func dateFromISOString(date:String) -> NSDate {
        
        return self.genericFormatter.dateFromString(date)!
    }
    
}