//
//  WBEmotion.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/7.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBEmotion:NSObject,NSCoding{
    /** 表情的文字描述 */
    var chs:String?
    /** 表情的png图片名 */
    var png:String?
    /** emoji表情的16进制编码 */
    var code:String?
    
    override init() {
        super.init()
    }
    
    ///  将一个对象从沙盒中解档
    ///
    ///  - parameter aDecoder:
    ///
    ///  - returns:
    required init(coder aDecoder: NSCoder) {
        self.chs=aDecoder.decodeObjectForKey("chs") as? String
        self.png=aDecoder.decodeObjectForKey("png") as? String
        self.code=aDecoder.decodeObjectForKey("code") as? String
    }
    ///  将一个对象归档到沙盒中
    ///
    ///  - parameter enCoder:
    func encodeWithCoder(enCoder: NSCoder) {
        enCoder.encodeObject(self.chs, forKey: "chs")
        enCoder.encodeObject(self.png, forKey: "png")
        enCoder.encodeObject(self.code, forKey: "code")
    }
}