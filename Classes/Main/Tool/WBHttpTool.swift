//
//  WBHttpTool.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/31.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBHttpTool{
    static func get(url:String,params:AnyObject?,success:(responseObject:AnyObject) -> Void,failure:(error:NSError) -> Void){
        // 1.创建管理者
        let mgr=AFHTTPRequestOperationManager()
        // 2.发送请求
        mgr.GET(url, parameters: params, success: { (operation, responseObject) -> Void in
            success(responseObject: responseObject)
            }) { (operation, error) -> Void in
                failure(error: error)
        }
    }
    static func post(url:String,params:AnyObject?,success:(responseObject:AnyObject) -> Void,failure:(error:NSError) -> Void){
        // 1.创建管理者
        let mgr=AFHTTPRequestOperationManager()
        //self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
        //mgr.responseSerializer.acceptableContentTypes = NSSet(objects: ["text/plain","application/json","text/json","text/javascript"]) as Set<NSObject>
        mgr.responseSerializer.acceptableContentTypes = NSSet(array: ["text/plain","application/json","text/json","text/javascript"])as Set<NSObject>
        // 2.发送请求
        mgr.POST(url, parameters: params, success: { (operation, responseObject) -> Void in
            success(responseObject: responseObject)
            }) { (operation, error) -> Void in
                failure(error: error)
        }

    }
    
    static func post(url:String,params:AnyObject?,constructingBodyBlock: (formData:AFMultipartFormData) -> Void,success:(responseObject:AnyObject) -> Void,failure:(error:NSError) -> Void){
        // 1.创建管理者
        let mgr=AFHTTPRequestOperationManager()
        
        mgr.POST(url, parameters: params, constructingBodyWithBlock: { (fData:AFMultipartFormData) -> Void in
            constructingBodyBlock(formData: fData)
            }, success: { (operation:AFHTTPRequestOperation, responseObject) -> Void in
                success(responseObject: responseObject)
            }) { (operation:AFHTTPRequestOperation, error) -> Void in
                failure(error: error)
        }
    }
}