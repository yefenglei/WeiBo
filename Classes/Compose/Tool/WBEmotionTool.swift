//
//  WBEmotionTool.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/7.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBEmotionTool:NSObject{
    
    private static var _allEmotions:NSMutableArray?
    static var allEmotions:NSMutableArray{
        if(_allEmotions == nil){
            // 1.加载本地表情
            let pathDefault=NSBundle.mainBundle().pathForResource("EmotionIcons/default/info.plist", ofType: nil)
            let emotions:NSMutableArray=WBEmotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: pathDefault!))
            
            let pathEmoji=NSBundle.mainBundle().pathForResource("EmotionIcons/emoji/info", ofType: "plist")
            let emojiArray=WBEmotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: pathEmoji!))
            for item:AnyObject in emojiArray{
                emotions.addObject(item)
            }
            
            let pathLxh=NSBundle.mainBundle().pathForResource("EmotionIcons/lxh/info.plist", ofType: nil)
            let lxhArray=WBEmotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: pathLxh!))
            for item:AnyObject in lxhArray{
                emotions.addObject(item)
            }
            _allEmotions = emotions
        }
        return _allEmotions!
    }
    
    static let WBRecentEmotionsPath:String = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent("emotions.archive")
    
    static func addRecentEmotion(emotion:WBEmotion){
        // 加载沙盒中的表情数据
        var emotions=self.recentEmotions()
        if(emotions == nil){
            emotions = NSMutableArray()
        }

        for em in emotions!{
            let item = em as! WBEmotion
            if(item.isEqualTo(emotion)){
                emotions?.removeObject(item)
                break
            }
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