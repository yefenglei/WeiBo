//
//  AppDelegate.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/5.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var task:UIBackgroundTaskIdentifier?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // 1.创建窗口
        self.window=UIWindow()
        self.window?.frame=UIScreen.mainScreen().bounds
        
        // 2.设置根控制器
        let account=WBAccountTool.account
        if(account != nil){
            //账号已登录，且未过期
            self.window?.switchRootViewController()
        }else{
            // 账号未登录 或 已过期
            let tabbarVc=WBAuthoViewController()
            self.window?.rootViewController=tabbarVc
        }
        
        // 3.显示窗口
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        /**
        *  app的状态
        *  1.死亡状态：没有打开app
        *  2.前台运行状态
        *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
        *  4.后台运行状态
        */
        // 向操作系统申请后台运行的资格，能维持多久，是不确定的
        self.task=application.beginBackgroundTaskWithExpirationHandler({ () -> Void in
            // 当申请的后台运行时间已经结束（过期），就会调用这个block
            
            // 赶紧结束任务
            application.endBackgroundTask(self.task!)

        })
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        let mgr=SDWebImageManager.sharedManager()
        // 1.取消下载
        mgr.cancelAll()
        
        // 2.清空内存中的所有图片
        mgr.imageCache.clearMemory()
    }

}

