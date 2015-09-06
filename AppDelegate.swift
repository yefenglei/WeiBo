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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // 1.创建窗口
        self.window=UIWindow()
        self.window?.frame=UIScreen.mainScreen().bounds
        
        // 2.设置根控制器
        var tabbarVc=UITabBarController()
        self.window?.rootViewController=tabbarVc
        // 3.设置子控制器
        var homeVc=WBHomeTableViewController()
        addChildView(homeVc, title: "首页", image: "tabbar_home", selectedImage: "tabbar_home_selected")
        var messageVc=WBMessageCenterTableViewController()
        addChildView(messageVc, title: "消息", image: "tabbar_message_center", selectedImage: "tabbar_message_center_selected")
        var discoverVc=WBDiscoverTableViewController()
        addChildView(discoverVc, title: "发现", image: "tabbar_discover", selectedImage: "tabbar_discover_selected")
        var profileVc=WBProfileTableViewController()
        addChildView(profileVc, title: "我", image: "tabbar_profile", selectedImage: "tabbar_profile_selected")
        
        tabbarVc.addChildViewController(homeVc)
        tabbarVc.addChildViewController(messageVc)
        tabbarVc.addChildViewController(discoverVc)
        tabbarVc.addChildViewController(profileVc)

        
        // 4.显示窗口
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
    
    /// Add a new childview to tabbarviewcontroller.
    ///
    /// :param: images Images of selected
    /// :returns: void
    func addChildView(childView:UIViewController,title:String,image:String,selectedImage:String){
        childView.tabBarItem.title=title
        var textAttrs=[NSForegroundColorAttributeName:CommonHelper.fontColor]
        var selectedTextAttrs=[NSForegroundColorAttributeName:UIColor.orangeColor()]
        childView.tabBarItem.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal)
        childView.tabBarItem.setTitleTextAttributes(selectedTextAttrs, forState: UIControlState.Selected)
        childView.tabBarItem.image=UIImage(named: image)
        var homeSelectedImage=UIImage(named: selectedImage)
        childView.view.backgroundColor=CommonHelper.randomColor
        // 声明:这张图片按照原来的样子显示，不要自动渲染成系统的颜色
        homeSelectedImage=homeSelectedImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        childView.tabBarItem.selectedImage=homeSelectedImage
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


}

