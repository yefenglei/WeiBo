//
//  WBSpecial.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/12/7.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBSpecial {
    /** 这段特殊文字的内容 */
    var text : NSString!
    /** 这段特殊文字的范围 */
    var range:NSRange!
    /** 这段特殊文字的矩形框(要求数组里面存放CGRect) */
    var rects:[CGRect]!
}