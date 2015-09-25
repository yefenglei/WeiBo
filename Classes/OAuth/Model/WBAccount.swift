//
//  WBAccount.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/25.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation
class WBAccount:NSObject,NSCoding{
    var access_token:String
    var expires_in:Int64
    var uid:String
    var create_time:NSDate
    var name:String?
    init(dictData:NSDictionary){
        self.access_token=dictData.valueForKey("access_token") as! String
        self.expires_in=(dictData.valueForKey("expires_in") as! NSNumber).longLongValue
        self.uid=dictData.valueForKey("uid") as! String
        self.create_time=NSDate()
    }
    ///  将一个对象从沙盒中解档
    ///
    ///  - parameter aDecoder:
    ///
    ///  - returns:
    required init(coder aDecoder: NSCoder) {
        self.access_token=aDecoder.decodeObjectForKey("access_token") as! String
        self.expires_in=aDecoder.decodeInt64ForKey("expires_in")
        self.uid=aDecoder.decodeObjectForKey("uid") as! String
        self.create_time=aDecoder.decodeObjectForKey("create_time") as! NSDate
    }
    ///  将一个对象归档到沙盒中
    ///
    ///  - parameter enCoder:
    func encodeWithCoder(enCoder: NSCoder) {
        enCoder.encodeObject(self.access_token, forKey: "access_token")
        enCoder.encodeInt64(self.expires_in, forKey: "expires_in")
        enCoder.encodeObject(self.access_token, forKey: "uid")
        enCoder.encodeObject(self.create_time, forKey: "create_time")
    }
    
    
}