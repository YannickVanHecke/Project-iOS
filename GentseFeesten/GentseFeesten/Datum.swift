//
//  Datum.swift
//  GentseFeesten
//
//  Created by Yannick Van Hecke on 13/01/16.
//  Copyright © 2016 Yannick Van Hecke. All rights reserved.
//

import Foundation

class Datum
{
    var unixDate : String = ""
    var date : String = ""
    var events : [Event] = []
    
    init(unixDate: String){
        self.unixDate = unixDate
        self.date = getDateOrTimeFromUnixDate(true, getTime: false)
    }
    
    func getDateOrTimeFromUnixDate(getDate: Bool, getTime: Bool) -> String{
    
        // Source : http://stackoverflow.com/questions/28489227/swift-ios-dates-and-times-in-different-format
        
        let dateFormatter = NSDateFormatter()
        if (getDate == false && getTime == true)
        {
            dateFormatter.dateFormat = "HH:mm"
        }
        if (getDate == true && getTime == false)
        {
            dateFormatter.dateFormat = "dd/MM"
        }
        
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(Double(self.unixDate)!))

        print("\(dateFormatter.stringFromDate(date))")
        return dateFormatter.stringFromDate(date).stringByReplacingOccurrencesOfString("July", withString: "Juli")
    }
}