//
//  WBStatusCell.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/4.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {
    
    private var _statusFrame:WBStatusFrame?
    var statusFrame:WBStatusFrame?{
        set{
            self._statusFrame=newValue
            
            let status:WBStatus=newValue!.status
            let user:WBUser=status.user
            
            /** 原创微博整体 */
            self.originalView.frame=newValue!.originalViewF
            
            /** 头像 */
            self.iconView.frame=newValue!.iconViewF
            self.iconView.user=user
            
            /** 会员图标 */
            if(user.vip != nil && user.vip!){
                self.vipView.hidden=false
                
                self.vipView.frame=newValue!.vipViewF
                let vipName="common_icon_membership_level\(user.mbrank.integerValue)"
                self.vipView.image=UIImage(named: vipName)
                
                self.nameLabel.textColor=UIColor.orangeColor()
            }else{
                self.nameLabel.textColor=UIColor.blackColor()
                self.vipView.hidden=true
            }
            
            /** 配图 */
            if(status.pic_urls != nil && status.pic_urls!.count>0){
                self.photosView.frame=newValue!.photosViewF
                self.photosView.photos=status.pic_urls
                self.photosView.hidden=false
            }else{
                self.photosView.hidden=true
            }
            
            /** 昵称 */
            self.nameLabel.text=user.name
            self.nameLabel.frame=newValue!.nameLabelF
            
            /** 时间 */
            let time:NSString=status.created_at
            let timeX:CGFloat=newValue!.nameLabelF.origin.x
            let timeY:CGFloat=CGRectGetMaxY(newValue!.nameLabelF) + WBConstant.WBStatusCellBorderW
            let timeSize:CGSize=time.size(WBConstant.WBStatusCellTimeFont)
            self.timeLabel.frame=CGRectMake(timeX, timeY, timeSize.width, timeSize.height)
            self.timeLabel.text=time as String
            
            /** 来源 */
            let sourceX:CGFloat=CGRectGetMaxX(self.timeLabel.frame) + WBConstant.WBStatusCellBorderW
            let sourceY:CGFloat=timeY
            let sourceSize=(status.source as NSString).size(WBConstant.WBStatusCellSourceFont)
            self.sourceLabel.frame=CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height)
            self.sourceLabel.text=status.source
            
            /** 正文 */
            //self.contentLabel.text=status.text
            //self.contentLabel.attributedText=(status.text as NSString).attributedStringWithString(WBConstant.WBStatusCellContentFont.lineHeight)
            self.contentLabel.attributedText=status.attributedText
            self.contentLabel.frame=newValue!.contentLabelF
            
            /** 被转发的微博 */
            if(status.retweeted_status != nil){
                let retweeted_status:WBStatus=status.retweeted_status!
                //let retweeted_status_user:WBUser=retweeted_status.user
                
                self.retweetView.hidden=false
                
                /** 被转发的微博整体 */
                self.retweetView.frame=newValue!.retweetViewF
                
                /** 被转发的微博正文 */
                //let retweetContent="@\(retweeted_status_user.name):\(retweeted_status.text)"
                //self.retweetContentLabel.text=retweetContent
                //self.retweetContentLabel.attributedText=(retweetContent as NSString).attributedStringWithString(WBConstant.WBStatusCellContentFont.lineHeight)
                self.retweetContentLabel.attributedText=status.retweetedAttributedText
                self.retweetContentLabel.frame=newValue!.retweetContentLabelF
                
                /** 被转发的微博配图 */
                if(retweeted_status.pic_urls!.count>0){
                    self.retweetPhotosView.frame=newValue!.retweetPhotosViewF
                    self.retweetPhotosView.photos=retweeted_status.pic_urls
                    self.retweetPhotosView.hidden=false
                }else{
                    self.retweetPhotosView.hidden=true
                }
            }else{
                self.retweetView.hidden=true
            }
            
            /** 工具条 */
            self.toolbar.frame=newValue!.toolbarF
            self.toolbar.status=status
        }
        get{
            return self._statusFrame
        }
    }
    
    /* 原创微博 */
    /** 原创微博整体 */
    var originalView:UIView!
    /** 头像 */
    var iconView:WBIconView!
    /** 会员图标 */
    var vipView:UIImageView!
    /** 配图 */
    var photosView:WBStatusPhotosView!
    /** 昵称 */
    var nameLabel:UILabel!
    /** 时间 */
    var timeLabel:UILabel!
    /** 来源 */
    var sourceLabel:UILabel!
    /** 正文 */
    var contentLabel:WBStatusTextView!
    
    /* 转发微博 */
    /** 转发微博整体 */
    var retweetView:UIView!
    /** 转发微博正文 + 昵称 */
    var retweetContentLabel:WBStatusTextView!
    /** 转发配图 */
    var retweetPhotosView:WBStatusPhotosView!
    /** 工具条 */
    var toolbar:WBStatusToolbar!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellWithTabelView(tableView:UITableView)->WBStatusCell{
        let ID:String="status"
        var cell:WBStatusCell?=tableView.dequeueReusableCellWithIdentifier(ID) as? WBStatusCell
        if(cell == nil){
            cell=WBStatusCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID)
        }
        return cell!
    }
    
    ///  cell的初始化方法，一个cell只会调用一次
    ///  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
    ///
    ///  - parameter style:           cell的样式
    ///  - parameter reuseIdentifier: cell 的唯一标识
    ///
    ///  - returns: 无
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=UIColor.clearColor()
        // 点击cell的时候不要变色
        self.selectionStyle=UITableViewCellSelectionStyle.None
        // 初始化原创微博
        self.setupOriginal()
        
        // 初始化转发微博
        self.setupRetweet()
        
        // 初始化工具条
        self.setupToolbar()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
///  初始化工具条
    func setupToolbar(){
        let toolbar=WBStatusToolbar()
        self.contentView.addSubview(toolbar)
        self.toolbar=toolbar
    }
///  初始化转发微博
    func setupRetweet(){
        /** 转发微博整体 */
        let retweetView=UIView()
        retweetView.backgroundColor=CommonHelper.Color(247, g: 247, b: 247, a: 1)
        self.contentView.addSubview(retweetView)
        self.retweetView=retweetView
        
        /** 转发微博正文 + 昵称 */
        //let retweetContentLabel=UILabel()
        let retweetContentLabel=WBStatusTextView()
        //retweetContentLabel.numberOfLines=0
        retweetContentLabel.font=WBConstant.WBStatusCellRetweetContentFont
        retweetView.addSubview(retweetContentLabel)
        self.retweetContentLabel=retweetContentLabel
        
        /** 转发微博配图 */
        let retweetPhotosView=WBStatusPhotosView()
        retweetView.addSubview(retweetPhotosView)
        self.retweetPhotosView=retweetPhotosView
    }
    
///  初始化原创微博
    func setupOriginal(){
        /** 原创微博整体 */
        let originalView=UIView()
        originalView.backgroundColor=UIColor.whiteColor()
        self.contentView.addSubview(originalView)
        self.originalView=originalView
        
        /** 头像 */
        let iconView=WBIconView()
        originalView.addSubview(iconView)
        self.iconView=iconView
        
        /** 会员图标 */
        let vipView=UIImageView()
        vipView.contentMode=UIViewContentMode.Center
        originalView.addSubview(vipView)
        self.vipView=vipView
        
        /** 配图 */
        let photosView=WBStatusPhotosView()
        originalView.addSubview(photosView)
        self.photosView=photosView
        
        /** 昵称 */
        let nameLabel=UILabel()
        nameLabel.font=WBConstant.WBStatusCellNameFont
        originalView.addSubview(nameLabel)
        self.nameLabel=nameLabel
        
        /** 时间 */
        let timeLabel=UILabel()
        timeLabel.font=WBConstant.WBStatusCellTimeFont
        timeLabel.textColor=UIColor.orangeColor()
        originalView.addSubview(timeLabel)
        self.timeLabel=timeLabel
        
        /** 来源 */
        let sourceLabel=UILabel()
        sourceLabel.font=WBConstant.WBStatusCellSourceFont
        originalView.addSubview(sourceLabel)
        self.sourceLabel=sourceLabel
        
        /** 正文 */
        //let contentLabel=UILabel()
        let contentLabel=WBStatusTextView()
        contentLabel.font=WBConstant.WBStatusCellContentFont
        //contentLabel.numberOfLines=0
        originalView.addSubview(contentLabel)
        self.contentLabel=contentLabel
        
    }

}
