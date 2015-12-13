//
//  WBTextPart.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/12/6.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBTextPart {
    /** 这段文字的内容 */
    var text:String!
    /** 这段文字的范围 */
    var range:NSRange!
    /** 是否为特殊文字 */
    var isSpecial:Bool!
    /** 是否为表情 */
    var isEmotion:Bool!
    init(){
        self.isSpecial=false
        self.isEmotion=false
    }
}