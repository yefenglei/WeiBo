//
//  NSDate+Extension.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/6.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

extension NSDate{
    ///  判断某个时间是否为今年
    ///
    ///  - returns: true or false
    func isThisYear()->Bool{
        let calendar=NSCalendar.currentCalendar()
        // 获得某个时间的年月日时分秒
        let dateCmps:NSDateComponents=calendar.components(NSCalendarUnit.Year, fromDate: self)
        let nowCmps:NSDateComponents=calendar.components(NSCalendarUnit.Year, fromDate: NSDate())
        return dateCmps.year == nowCmps.year
    }
    
    ///  判断某个时间是否为昨天
    ///
    ///  - returns: true or false
    func isYesterday()->Bool{
        let calendar=NSCalendar.currentCalendar()
        let units:NSCalendarUnit=[NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day]
        // 获得某个时间的年月日时分秒
        let dateCmps:NSDateComponents=calendar.components(units, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        return dateCmps.year==0 && dateCmps.month==0 && dateCmps.day==1
    }
    ///  判断某个时间是否为今天
    ///
    ///  - returns: true or false
    func isToday()->Bool{
        let calendar=NSCalendar.currentCalendar()
        let units:NSCalendarUnit=[NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day]
        // 获得某个时间的年月日时分秒
        let dateCmps:NSDateComponents=calendar.components(units, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        return dateCmps.year==0 && dateCmps.month==0 && dateCmps.day==0
    }
}