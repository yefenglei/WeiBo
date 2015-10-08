//
//  WBEmotionAttachment.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/7.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBEmotionAttachment:NSTextAttachment{
    private var _emotion:WBEmotion?
    var emotion:WBEmotion?{
        get{
            return self._emotion
        }
        set{
            self._emotion=newValue
            self.image=UIImage(named: newValue!.png!)
        }
    }
}