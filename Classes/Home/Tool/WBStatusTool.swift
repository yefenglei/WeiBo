//
//  WBStatusTool.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/12/20.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//  微博工具类:用来处理微博数据的缓存

import UIKit

class WBStatusTool: NSObject {
    
    private static var _db:FMDatabase?
    private static var db:FMDatabase!{
        get{
            if(WBStatusTool._db == nil){
                // 1.打开数据库
                var dbPath:NSString=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
                dbPath=dbPath.stringByAppendingPathComponent("statuses.sqlite")
                WBStatusTool._db=FMDatabase(path: dbPath as String)
                WBStatusTool._db!.open()
                
                // 2.创表
                let sql="CREATE TABLE IF NOT EXISTS t_status (id integer PRIMARY KEY, status blob NOT NULL, idstr text NOT NULL);"
                let result=WBStatusTool._db!.executeUpdate(sql, withArgumentsInArray: nil)
                if(result){
                    NSLog("表t_status创建成功！")
                }else{
                    NSLog("表t_status创建失败！")
                }
            }
            return WBStatusTool._db!
        }
        set{
            WBStatusTool._db=newValue
        }
    }
    
    /**
    *  根据请求参数去沙盒中加载缓存的微博数据
    *
    *  @param params 请求参数
    */
    static func statuses(params:Dictionary<String,String>)->[AnyObject]{
        // 根据请求参数生成对应的查询SQL语句
        var sql:String!
        if(params["since_id"] != nil){
            sql=NSString(format: "SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;",params["since_id"]!) as String
        }else if(params["max_id"] != nil){
            sql=NSString(format: "SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;",params["max_id"]!) as String
        }else{
            sql = "SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;"
        }
        
        // 执行SQL
        let set=WBStatusTool.db.executeQuery(sql, withArgumentsInArray: nil)
        var statuses=[AnyObject]()
        while(set.next()){
            let statusData=set.objectForColumnName("status") as! NSData
            let status=NSKeyedUnarchiver.unarchiveObjectWithData(statusData)!
            statuses.append(status)
        }
        return statuses
    }
    
    /**
    *  存储微博数据到沙盒中
    *
    *  @param statuses 需要存储的微博数据
    */
    static func saveStatuses(statuses:[NSDictionary]){
        // 要将一个对象存进数据库的blob字段,最好先转为NSData
        // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData
        for status:NSDictionary in statuses{
            let statusData=NSKeyedArchiver.archivedDataWithRootObject(status)
            WBStatusTool.db.executeUpdate("INSERT INTO t_status(status, idstr) VALUES (?, ?);", statusData, status["idstr"]!)
        }
    }
    
    /// 移除数据库
    static func removeDatabase(){
        WBStatusTool._db=nil
    }
}
