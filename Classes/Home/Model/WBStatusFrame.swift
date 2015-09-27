//
//  WBStatusFrame.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/27.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//  一个WBStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放一个cell的高度
//  3.存放着一个数据模型HWStatus

import Foundation

class WBStatusFrame:NSObject{
    /// 昵称字体
    let WBStatusCellNameFont=UIFont.systemFontOfSize(15)
    /// 时间字体
    let WBStatusCellTimeFont=UIFont.systemFontOfSize(12)
    /// 来源字体
    let WBStatusCellSourceFont=UIFont.systemFontOfSize(15)
    ///  正文字体
    let WBStatusCellContentFont=UIFont.systemFontOfSize(14)
    /// 被转发微博的正文字体
    let WBStatusCellRetweetContentFont=UIFont.systemFontOfSize(13)
    /// cell之间的间距
    let WBStatusCellMargin=CGFloat(15)
    ///  cell的边框宽度
    let WBStatusCellBorderW=CGFloat(10)
    
    private var _status:WBStatus!
    var status:WBStatus!{
        get{
            return self._status
        }
        set{
            self._status=newValue
            let user=newValue.user
            // cell的宽度
            var cellW=UIScreen.mainScreen().bounds.size.width
            /* 原创微博 */
            
            /** 头像 */
            let iconWH=CGFloat(35)
            let iconX=WBStatusCellBorderW
            let iconY=WBStatusCellBorderW
            self.iconViewF=CGRectMake(iconX, iconY, iconWH, iconWH)
            
            /** 昵称 */
            let nameX=CGRectGetMaxX(self.iconViewF)+WBStatusCellBorderW
            let nameY=iconY
            let nameSize=(user.name as NSString).size(WBStatusCellNameFont)
            self.nameLabelF=CGRectMake(nameX, nameY, nameSize.width, nameSize.height)
            
            /** 时间 */
            let timeX:CGFloat=nameX
            let timeY:CGFloat=CGRectGetMaxY(self.nameLabelF)+WBStatusCellBorderW
            let timeSize=(status.created_at as NSString).size(WBStatusCellTimeFont)
            self.timeLabelF=CGRectMake(timeX, timeY, timeSize.width, timeSize.height)
            
            /** 来源 */
            let sourceX=CGRectGetMaxX(self.timeLabelF)+WBStatusCellBorderW
            let sourceY=timeY
            let sourceSize=(status.source as NSString).size(WBStatusCellSourceFont)
            self.sourceLabelF=CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height)
            
            /** 正文 */
            let contentX=iconX
            let contentY=max(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + WBStatusCellBorderW
            let maxW=cellW-2*contentX
            let contentSize=(status.text as NSString).size(WBStatusCellContentFont,maxW: maxW)
            self.contentLabelF=CGRectMake(contentX, contentY, contentSize.width, contentSize.height)
            
            /** 配图 */
            let originalH:CGFloat=0
            if(status.pic_urls.count>0){
                // 有配图
                let photosX=contentX
                let photosY=CGRectGetMaxY(self.contentLabelF)+WBStatusCellBorderW
                
            }
        }
    }
    /** 原创微博整体 */
    var originalViewF:CGRect!
    /** 头像 */
    var iconViewF:CGRect!
    /** 会员图标 */
    var vipViewF:CGRect!
    /** 配图 */
    var photosViewF:CGRect!
    /** 昵称 */
    var nameLabelF:CGRect!
    /** 时间 */
    var timeLabelF:CGRect!
    /** 来源 */
    var sourceLabelF:CGRect!
    /** 正文 */
    var contentLabelF:CGRect!
    
    /** 转发微博整体 */
    var retweetViewF:CGRect!
    /** 转发微博正文 + 昵称 */
    var retweetContentLabelF:CGRect!
    /** 转发配图 */
    var retweetPhotosViewF:CGRect!
    /** 底部工具条 */
    var toolbarF:CGRect!
    /** cell的高度 */
    var cellHeight:CGFloat!
}