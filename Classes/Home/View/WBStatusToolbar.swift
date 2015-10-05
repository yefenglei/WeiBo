//
//  WBStatusToolbar.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/4.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBStatusToolbar: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var _status:WBStatus?
    var status:WBStatus?{
        get{
            return self._status
        }
        set{
            self._status=newValue
            // 转发
            self.setupBtnCount(newValue!.reposts_count, btn: self.repostBtn, title: "转发")
            // 评论
            self.setupBtnCount(newValue!.comments_count, btn: self.commentBtn, title: "评论")
            // 赞
            self.setupBtnCount(newValue!.attitudes_count, btn: self.attitudeBtn, title: "赞")
        }
    }
    
    /** 里面存放所有的按钮 */
    lazy var btns:NSMutableArray=NSMutableArray()
    /** 里面存放所有的分割线 */
    lazy var dividers:NSMutableArray=NSMutableArray()
    
    var repostBtn:UIButton!
    var commentBtn:UIButton!
    var attitudeBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor(patternImage: UIImage(named: "timeline_card_bottom_background")!)
        
        // 添加按钮
        self.repostBtn=self.setupBtn("转发", icon: "timeline_icon_retweet")
        self.commentBtn=self.setupBtn("评论", icon: "timeline_icon_comment")
        self.attitudeBtn=self.setupBtn("赞", icon: "timeline_icon_unlike")
        
        // 添加分割线
        self.setupDivider()
        self.setupDivider()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
///  添加分割线
    func setupDivider(){
        let divider=UIImageView()
        divider.image=UIImage(named: "timeline_card_bottom_line")
        self.addSubview(divider)
        self.dividers.addObject(divider)
    }
    
    ///  初始化一个按钮
    ///
    ///  - parameter title: 按钮文字
    ///  - parameter icon:  按钮图标
    ///
    ///  - returns: 按钮
    func setupBtn(title:String,icon:String)->UIButton{
        let btn=UIButton()
        btn.setImage(UIImage(named: icon), forState: .Normal)
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0)
        btn.setTitle(title, forState: .Normal)
        btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background_highlighted"), forState: UIControlState.Highlighted)
        btn.titleLabel?.font=UIFont.systemFontOfSize(13)
        self.addSubview(btn)
        self.btns.addObject(btn)
        return btn
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置按钮的frame
        let btnCount:Int=self.btns.count
        let btnW:CGFloat=self.width/CGFloat(btnCount)
        let btnH=self.height
        for i:Int in 0...btnCount-1{
            let btn:UIButton=self.btns[i] as! UIButton
            btn.y=0
            btn.width=btnW
            btn.x=CGFloat(i)*btnW
            btn.height=btnH
        }
        
        // 设置分割线的frame
        let dividerCount:Int=self.dividers.count
        for i:Int in 0...dividerCount-1{
            let divider:UIImageView=self.dividers[i] as! UIImageView
            divider.width = CGFloat(1)
            divider.height=btnH
            divider.x=CGFloat(i+1)*btnW
            divider.y=0
        }
        
    }
    
    func setupBtnCount(count:Int?,btn:UIButton,var title:String){
        if(count != nil && count! > 0){
            // 数字不为0
            if(count<10000){
                // 不足10000：直接显示数字，比如786、7986
                title="\(count!)"
            }else{
                let wan:Double = Double(count!)/10000.0
                title=NSString(format: "%.1f万", wan) as String
                // 将字符串里面的.0去掉
                title=title.stringByReplacingOccurrencesOfString(".0", withString: "")
            }
        }
        btn.setTitle(title, forState: .Normal)
    }

}
