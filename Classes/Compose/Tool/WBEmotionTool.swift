//
//  WBEmotionTool.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/7.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBEmotionTool:NSObject{
    
    static let WBRecentEmotionsPath:String = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent("emotions.archive")
    
    static func addRecentEmotion(emotion:WBEmotion){
        // 加载沙盒中的表情数据
        var emotions=self.recentEmotions()
        if(emotions == nil){
            emotions = NSMutableArray()
        }
        
        // 将表情放到数组的最前面
        emotions?.insertObject(emotion, atIndex: 0)
        
        // 将所有的表情数据写入沙盒
        NSKeyedArchiver.archiveRootObject(emotions!, toFile: WBRecentEmotionsPath)
    }
    
    ///  返回装着HWEmotion模型的数组
    ///
    ///  - returns: 数组
    static func recentEmotions()->NSMutableArray?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(WBRecentEmotionsPath) as? NSMutableArray
    }
}