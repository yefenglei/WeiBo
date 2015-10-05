//
//  WBStatus.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/27.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation
class WBStatus:NSObject{
    override static func objectClassInArray() -> [NSObject : AnyObject]! {
        return ["pic_urls":[WBPhoto.self]]
    }
    
 /// 字符串型的微博ID
    var idstr:String!
 /// 微博信息内容
    var text:String!
 /// 微博作者的用户信息字段 详细
    var user:WBUser!
    /**
    1.今年
    1> 今天
    * 1分内： 刚刚
    * 1分~59分内：xx分钟前
    * 大于60分钟：xx小时前
    
    2> 昨天
    * 昨天 xx:xx
    
    3> 其他
    * xx-xx xx:xx
    
    2.非今年
    1> xxxx-xx-xx xx:xx
    */
 /// 微博创建时间
    var created_at:String!{
        get{
            let fmt=NSDateFormatter()
            // 如果是真机调试，转换这种欧美时间，需要设置locale
            fmt.locale = NSLocale(localeIdentifier: "en_US")
            // 设置日期格式（声明字符串里面每个数字和单词的含义）
            // E:星期几
            // M:月份
            // d:几号(这个月的第几天)
            // H:24小时制的小时
            // m:分钟
            // s:秒
            // y:年
            fmt.dateFormat="EEE MMM dd HH:mm:ss Z yyyy"
            //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
            // 微博的创建日期
            let createDate:NSDate=fmt.dateFromString(_created_at)!
            // 当前时间
            let now=NSDate()
            // 日历对象（方便比较两个日期之间的差距）
            let calendar=NSCalendar.currentCalendar()
            // NSCalendarUnit枚举代表想获得哪些差值
//            let unit:NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit
            let unit:NSCalendarUnit = [NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second]
            // 计算两个日期之间的差值
            let cmps=calendar.components(unit ,fromDate: createDate, toDate: now, options: NSCalendarOptions(rawValue: 0))
            if(cmps.year==0){
                // 今年
                if(cmps.day==1){
                    // 昨天
                    fmt.dateFormat="昨天 HH:mm"
                    return fmt.stringFromDate(createDate)
                }else if(0==cmps.day){
                    // 今天
                    if(cmps.hour>=1){
                        return "\(cmps.hour)小时前"
                    }else if(cmps.minute>=1){
                        return "\(cmps.minute)分钟之前"
                    }else{
                        return "刚刚"
                    }
                }else{
                    // 今年的其他日子
                    fmt.dateFormat="MM-dd HH:mm"
                    return fmt.stringFromDate(createDate)
                }
            }else{
                // 非今年
                fmt.dateFormat="yyyy-MM-dd HH:mm"
                return fmt.stringFromDate(createDate)
            }
        }
        set{
            self._created_at=newValue
        }
    }
    var _created_at:String!
 /// 微博来源
    var source:String!{
        get{
            return self._source == nil ? "" : self._source
        }
        set{
            // 正则表达式 NSRegularExpression
            // 截串 NSString
            var range=NSRange()
            range.location=(newValue as NSString).rangeOfString(">").location
            range.length=(newValue as NSString).rangeOfString("</").location-range.location
            let location=(newValue as NSString).substringWithRange(range)
            self._source="来自\(location)"
            
            
        }
    }
    var _source:String?
 /// 微博配图地址。多图时返回多图链接。无配图返回“[]”
    private var _pic_urls:[String]?
    var pic_urls:[String]!{
        get{
            if(self._pic_urls == nil){
                return [String]()
            }else{
                return self.pic_urls
            }
        }
        set{
            self._pic_urls=newValue
        }
    }
 /// 被转发的原微博信息字段，当该微博为转发微博时返回
    var retweeted_status:WBStatus?
 /// 转发数
    var reposts_count:Int?
 /// 评论数
    var comments_count:Int?
 /// 表态数
    var attitudes_count:Int?
}