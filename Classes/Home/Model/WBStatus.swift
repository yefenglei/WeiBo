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
        return ["pic_urls":WBPhoto.self]
    }
    
    
 /// 字符串型的微博ID
    var idstr:String!
 /// 微博信息内容
    private var _text:String?
    var text:String!{
        set{
            self._text=newValue
            self._attributedText=self.attributedTextWithText(newValue as NSString)
        }
        get{
            if(self._text==nil){
                self._text=""
            }
            return self._text!
        }
    }
    
 /// 微博信息内容 -- 带有属性的(特殊文字会高亮显示\显示表情)
    var _attributedText:NSAttributedString?
    var attributedText:NSAttributedString?{
        get{
            return self._attributedText
        }
        set{
            self._attributedText=newValue
        }
    }
    
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
    private var _created_at:String!
 /// 微博来源
    var source:String!{
        get{
            return self._source == nil ? "<a>未认证应用</a>" : self._source
        }
        set{
            // 正则表达式 NSRegularExpression
            // 截串 NSString
            var sc=newValue
            if(sc==""){
                sc="<a>未认证应用</a>"
            }
            var range=NSRange()
            range.location=(sc as NSString).rangeOfString(">").location + 1
            range.length=(sc as NSString).rangeOfString("</").location-range.location
            let location=(sc as NSString).substringWithRange(range)
            self._source="来自\(location)"
        }
    }
    private var _source:String?
 /// 微博配图地址。多图时返回多图链接。无配图返回“[]”
    var pic_urls:NSArray?
 /// 被转发的原微博信息字段，当该微博为转发微博时返回
    private var _retweeted_status:WBStatus?
    
    var retweeted_status:WBStatus?{
        get{
            return self._retweeted_status
        }
        set{
            self._retweeted_status=newValue
            let retweetContent=NSString(format: "@%@ : %@", newValue!.user.name, newValue!.text)
            self.retweetedAttributedText=self.attributedTextWithText(retweetContent)
        }
    }

 /// 被转发的原微博信息内容 -- 带有属性的(特殊文字会高亮显示\显示表情)
    var retweetedAttributedText:NSAttributedString?
 /// 转发数
    var reposts_count:NSNumber?
 /// 评论数
    var comments_count:NSNumber?
 /// 表态数
    var attitudes_count:NSNumber?
    
    /**
     *  普通文字 --> 属性文字
     *
     *  @param text 普通文字
     *
     *  @return 属性文字
     */
    private func attributedTextWithText(text:NSString)->NSAttributedString{
        let attributedText=NSMutableAttributedString()
        // 表情的规则
        let emotionPattern="\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]"
        // @的规则
        let atPattern = "@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+"
        // #话题#的规则
        let topicPattern = "#[0-9a-zA-Z\\u4e00-\\u9fa5]+#"
        // url链接的规则
        let urlPattern = "\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))"
        //let pattern="\(emotionPattern)|\(atPattern)|\(topicPattern)|\(urlPattern)"
        let pattern=NSString(format: "%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern) as String
        // 遍历所有的特殊字符串
        var parts=[WBTextPart]()
        
        text.enumerateStringsMatchedByRegex(pattern) { (captureCount, capturedStrings, capturedRanges, stop) -> Void in
            if(capturedRanges.memory.length==0){
                return
            }
            let part=WBTextPart()
            part.isSpecial=true
            part.text=capturedStrings.memory as! String
            part.range=capturedRanges.memory
            part.isEmotion=part.text.hasPrefix("[")&&part.text.hasSuffix("]")
            parts.append(part)
        }
        // 遍历所有的非特殊字符
        text.enumerateStringsSeparatedByRegex(pattern) { (captureCount, capturedStrings, capturedRanges, stop) -> Void in
            if(capturedRanges.memory.length==0){
                return
            }
            let part=WBTextPart()
            part.text=capturedStrings.memory as! String
            part.range=capturedRanges.memory
            parts.append(part)
        }
        
        // 排序
        // 系统是按照从小 -> 大的顺序排列对象
        parts.sortInPlace { (part1, part2) -> Bool in
            part1.range.location<part2.range.location
        }
        
        let font=WBConstant.WBStatusCellContentFont
        var specials=[WBSpecial]()
        // 按顺序拼接每一段文字
        for part:WBTextPart in parts{
            // 等会需要拼接的子串
            var substr:NSAttributedString
            if(part.isEmotion==true){ // 表情
                let attach=NSTextAttachment()
                let name=WBEmotionTool.emotion(part.text)?.png
                if(name != nil){
                    // 能找到对应的图片
                    attach.image=UIImage(named: name!)
                    attach.bounds=CGRectMake(0, -3, font.lineHeight, font.lineHeight)
                    substr=NSAttributedString(attachment: attach)
                }else{
                    // 表情图片不存在
                    substr=NSAttributedString(string: part.text)
                }
            }else if(part.isSpecial==true){
                // 非表情特殊文字
                let attr=[NSForegroundColorAttributeName:UIColor.redColor()]
                substr=NSAttributedString(string: part.text, attributes: attr)
                // 创建特殊对象
                let s=WBSpecial()
                s.text=part.text
                let loc=attributedText.length
                let len=(part.text as NSString).length
                s.range=NSMakeRange(loc, len)
                specials.append(s)
            }else{
                // 非特殊文字
                substr=NSAttributedString(string: part.text)
            }
            attributedText.appendAttributedString(substr)
        }
        
        // 一定要设置字体,保证计算出来的尺寸是正确的
        attributedText.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute("specials", value: specials, range: NSMakeRange(0, 1))
        
        return attributedText
    }
}