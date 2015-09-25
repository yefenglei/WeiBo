//
//  WBAccountTool.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/25.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//  处理账号的相关操作

import Foundation
class WBAccountTool{
    static let path=((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent("account.archive")
    ///  存储账号信息
    ///
    ///  - parameter account: 账号模型
    static func saveAccount(account:WBAccount){
        NSKeyedArchiver.archiveRootObject(account, toFile: path)
    }
    
    /// 账号
    /// 如果账号已过期，返回nil
    static var account:WBAccount?{
        get{
            // 解档模型
            let accountModel = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? WBAccount
            if let account=accountModel{
                // 验证账号是否过期
                // 过期的秒数
                let expires_in=account.expires_in
                // 获得过期时间
                let expires_time=account.create_time.dateByAddingTimeInterval(NSTimeInterval(expires_in))
                // 获得当前时间
                let now=NSDate()
                let result=expires_time.compare(now)
                if(result != NSComparisonResult.OrderedDescending){
                    // 过期
                    return nil
                }
                
                return account
            }else{
                return nil
            }

        }
    }
}