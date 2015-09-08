//
//  WBTabBarViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/6.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 3.设置子控制器
        var homeVc=WBHomeTableViewController()
        addChildView(homeVc, title: "首页", image: "tabbar_home", selectedImage: "tabbar_home_selected")
        var messageVc=WBMessageCenterTableViewController()
        addChildView(messageVc, title: "消息", image: "tabbar_message_center", selectedImage: "tabbar_message_center_selected")
        var discoverVc=WBDiscoverTableViewController()
        addChildView(discoverVc, title: "发现", image: "tabbar_discover", selectedImage: "tabbar_discover_selected")
        var profileVc=WBProfileTableViewController()
        addChildView(profileVc, title: "我", image: "tabbar_profile", selectedImage: "tabbar_profile_selected")

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Add a new childview to tabbarviewcontroller.
    ///
    /// :param: childVc 子控制器
    /// :param: title 标题
    /// :param: image 图片
    /// :param: selectedImage 选中时的图片
    /// :returns: void
    func addChildView(childView:UIViewController,title:String,image:String,selectedImage:String){
//        childView.tabBarItem.title=title
//        childView.navigationItem.title=title
        // 设置子控制器的文字
        childView.title=title
        var textAttrs=[NSForegroundColorAttributeName:CommonHelper.fontColor]
        var selectedTextAttrs=[NSForegroundColorAttributeName:UIColor.orangeColor()]
        childView.tabBarItem.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal)
        childView.tabBarItem.setTitleTextAttributes(selectedTextAttrs, forState: UIControlState.Selected)
        // 设置图片
        childView.tabBarItem.image=UIImage(named: image)
        var homeSelectedImage=UIImage(named: selectedImage)
        //childView.view.backgroundColor=CommonHelper.randomColor
        // 声明:这张图片按照原来的样子显示，不要自动渲染成系统的颜色
        homeSelectedImage=homeSelectedImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        childView.tabBarItem.selectedImage=homeSelectedImage
        
        // 包装导航控制器
        var navVc=WBNavigationViewController(rootViewController: childView)
        self.addChildViewController(navVc)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
