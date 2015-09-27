//
//  UIWindow.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/25.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation
import UIKit
extension UIWindow{
    ///  切换到主控制器
    func switchRootViewController(){
        let key="CFBundleVersion"
        // 上一次使用的版本号（储存在沙盒中的版本号）
        let lastVersion = CommonHelper.getUserDefaultValue(key) as? String
        // 当前软件的版本号（从info.plist中获取）
        let currentVersion=NSBundle.mainBundle().objectForInfoDictionaryKey(key)
        if(lastVersion != nil && currentVersion!.isEqualToString(lastVersion!)){
            let tabbarVc=WBTabBarViewController()
            self.rootViewController=tabbarVc
        }else{
            // 两个版本号不一致
            // 将新版本号存到沙盒里
            CommonHelper.setUserDefaultValue(key, value: currentVersion!)
            let startVc=WBNewFeatureViewController()
            self.rootViewController=startVc
        }
    }
}