//
//  UIBarButtomItem+Extension.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/8.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import Foundation
import UIKit
extension UIBarButtonItem{
    /// 创建一个UIBarButtomItem
    ///
    /// - parameter target: NSObject 点击item调用哪个对象
    /// - parameter target: NSObject 点击item调用target的方法
    /// - parameter image: String 图片
    /// - parameter highlightImage: String 高亮图片
    /// - returns: UIBarButtonItem
    static func itemWithTarget(target:NSObject,action:String,image:String,highlightImage:String)->UIBarButtonItem{
        let backBtn=UIButton()
        backBtn.addTarget(target, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
        // 设置图片
        backBtn.setBackgroundImage(UIImage(named: image)!, forState: UIControlState.Normal)
        backBtn.setBackgroundImage(UIImage(named: highlightImage)!, forState: UIControlState.Highlighted)
        // 设置尺寸
        backBtn.size=backBtn.currentBackgroundImage!.size
        return UIBarButtonItem(customView: backBtn)
    }
}