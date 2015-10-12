//
//  WBConstant.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/4.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBConstant{
    /// 昵称字体
    static let WBStatusCellNameFont=UIFont.systemFontOfSize(15)
    /// 时间字体
    static let WBStatusCellTimeFont=UIFont.systemFontOfSize(12)
    /// 来源字体
    static let WBStatusCellSourceFont=UIFont.systemFontOfSize(12)
    ///  正文字体
    static let WBStatusCellContentFont=UIFont.systemFontOfSize(14)
    /// 被转发微博的正文字体
    static let WBStatusCellRetweetContentFont=UIFont.systemFontOfSize(13)
    /// cell之间的间距
    static let WBStatusCellMargin=CGFloat(15)
    ///  cell的边框宽度
    static let WBStatusCellBorderW=CGFloat(10)
    
    // 通知
    // 表情选中的通知
    static let WBEmotionDidSelectNotification = "WBEmotionDidSelectNotification"
    static let WBSelectEmotionKey = "WBSelectEmotionKey"
    // 删除文字的通知
    static let WBEmotionDidDeleteNotification = "WBEmotionDidDeleteNotification"
    
    // MARK: - WBEmotionPageView
    // 一页中最多3行
    static let WBEmotionMaxRows:CGFloat=3
    // 一行中最多7列
    static let WBEmotionMaxCols:CGFloat=7
    
    static var WBEmotionPageSize:CGFloat{
        return WBEmotionMaxRows * WBEmotionMaxCols - CGFloat(1)
    }
}