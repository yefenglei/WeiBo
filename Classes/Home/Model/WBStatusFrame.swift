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
            let cellW=UIScreen.mainScreen().bounds.size.width
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
            
            /** 会员图标 */
            if(user.vip != nil && user.vip!){
                let vipX : CGFloat = CGRectGetMaxX(self.nameLabelF) + WBConstant.WBStatusCellBorderW;
                let vipY:CGFloat = nameY
                let vipH:CGFloat=nameSize.height
                let vipW:CGFloat=14
                self.vipViewF=CGRectMake(vipX, vipY, vipW, vipH)
            }
            
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
            //let contentSize=(status.text as NSString).size(WBStatusCellContentFont,maxW: maxW)
            let contentSize=status.attributedText?.boundingRectWithSize(CGSizeMake(maxW, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size
            self.contentLabelF=CGRectMake(contentX, contentY, contentSize!.width, contentSize!.height)
            
            /** 配图 */
            var originalH:CGFloat=0
            if(status.pic_urls != nil && status.pic_urls!.count>0){
                // 有配图
                let photosX=contentX
                let photosY=CGRectGetMaxY(self.contentLabelF)+WBStatusCellBorderW
                let photosSize=WBStatusPhotosView.size(status.pic_urls!.count)
                self.photosViewF = CGRectMake(photosX, photosY, photosSize.width, photosSize.height)
                originalH=CGRectGetMaxY(self.photosViewF)+WBStatusCellBorderW
            }else{
                // 没有配图
                originalH=CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW
            }
            /** 原创微博整体 */
            let originalX:CGFloat=0
            let originalY:CGFloat=WBStatusCellMargin
            let originalW:CGFloat=cellW
            self.originalViewF=CGRectMake(originalX, originalY, originalW, originalH)
            var toolbarY:CGFloat=0
            /* 被转发微博 */
            if(status.retweeted_status != nil){
                let retweeted_status:WBStatus=status.retweeted_status!
                //let retweeted_status_user=retweeted_status.user
                /** 被转发微博正文 */
                let retweetContentX = WBStatusCellBorderW;
                let retweetContentY = WBStatusCellBorderW;
                //let retweetContent = NSString(format: "@%@ : %@", retweeted_status_user.name,retweeted_status.text)
                //let retweetContentSize = retweetContent.size(WBStatusCellRetweetContentFont, maxW: maxW)
                let retweetContentSize = status.retweetedAttributedText?.boundingRectWithSize(CGSizeMake(maxW, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size
                
                self.retweetContentLabelF=CGRectMake(retweetContentX, retweetContentY, retweetContentSize!.width, retweetContentSize!.height)
                
                /** 被转发微博配图 */
                var retweetH:CGFloat=0
                if(retweeted_status.pic_urls!.count > 0){
                    // 转发微博有配图
                    let retweetPhotosX=retweetContentX
                    let retweetPhotosY=CGRectGetMaxY(self.retweetContentLabelF) + WBStatusCellBorderW
                    let retweetPhotosSize=WBStatusPhotosView.size(retweeted_status.pic_urls!.count)
                    self.retweetPhotosViewF=CGRectMake(retweetPhotosX, retweetPhotosY, retweetPhotosSize.width, retweetPhotosSize.height)
                    retweetH=CGRectGetMaxY(self.retweetPhotosViewF) + WBStatusCellBorderW
                }else{
                    // 转发微博没有配图
                    retweetH=CGRectGetMaxY(self.retweetContentLabelF) + WBStatusCellBorderW
                }
                /** 被转发微博整体 */
                let retweetX:CGFloat=0
                let retweetY=CGRectGetMaxY(self.originalViewF)
                let retweetW=cellW
                self.retweetViewF=CGRectMake(retweetX, retweetY, retweetW, retweetH)
                toolbarY = CGRectGetMaxY(self.retweetViewF)
            }else{
                toolbarY=CGRectGetMaxY(self.originalViewF)
            }
            
            /** 工具条 */
            let toolbarX:CGFloat = 0;
            let toolbarW:CGFloat = cellW;
            let toolbarH:CGFloat = 35;
            self.toolbarF=CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH)
            
            /* cell的高度 */
            self.cellHeight = CGRectGetMaxY(self.toolbarF)
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

    ///  将HWStatus模型转为HWStatusFrame模型
    ///
    ///  - parameter statuses: HWStatus模型数组
    ///
    ///  - returns: HWStatusFrame模型数组
    static func statusFrames(statuses:NSMutableArray)->[WBStatusFrame]{
        var frames=[WBStatusFrame]()
        for status:AnyObject in statuses{
            let f=WBStatusFrame()
            f.status=status as! WBStatus
            frames.append(f)
        }
        return frames
    }
    
}