//
//  WBEmotionTabBar.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/8.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

enum WBEmotionTabBarButtonType:Int{
    case WBEmotionTabBarButtonTypeRecent, // 最近
    WBEmotionTabBarButtonTypeDefault, // 默认
    WBEmotionTabBarButtonTypeEmoji, // emoji
    WBEmotionTabBarButtonTypeLxh // 浪小花
}

protocol WBEmotionTabBarDelegate:NSObjectProtocol{
    func emotionTabBar(tabBar:WBEmotionTabBar,didSelectButton buttonType:WBEmotionTabBarButtonType)
}


class WBEmotionTabBar: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var selectedBtn:WBEmotionTabBarButton?

    private var _delegate:WBEmotionTabBarDelegate?
    var delegate:WBEmotionTabBarDelegate?{
        get{
            return self._delegate
        }
        set{
            self._delegate=newValue
            
            // 选中“默认”按钮
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupBtn("最近", buttonType: WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeRecent)
        let defaultButton=self.setupBtn("默认", buttonType: WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeDefault)
        self.setupBtn("Emoji", buttonType: WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeEmoji)
        self.setupBtn("浪小花", buttonType: WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeLxh)
        // 默认选中默认表情
        self.btnClicked(defaultButton)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///  创建一个按钮
    ///
    ///  - parameter title:      按钮文字
    ///  - parameter buttonType: 按钮类型
    func setupBtn(title:String,buttonType:WBEmotionTabBarButtonType)->WBEmotionTabBarButton{
        // 创建按钮
        let btn=WBEmotionTabBarButton()
        btn.addTarget(self, action: "btnClicked:", forControlEvents: UIControlEvents.TouchDown)
        btn.tag=buttonType.rawValue
        btn.setTitle(title, forState: UIControlState.Normal)
        self.addSubview(btn)
        
        // 设置背景图片
        var image="compose_emotion_table_mid_normal"
        var selectImage="compose_emotion_table_mid_selected"
        if(self.subviews.count == 1){
            image="compose_emotion_table_left_normal"
            selectImage="compose_emotion_table_left_selected"
        }else if(self.subviews.count==4){
            image="compose_emotion_table_right_normal"
            selectImage="compose_emotion_table_right_selected"
        }
        
        btn.setBackgroundImage(UIImage(named: image), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: selectImage), forState: UIControlState.Disabled)
        return btn
    }
    
    ///  按钮点击
    ///
    ///  - parameter btn: 按钮
    func btnClicked(btn:WBEmotionTabBarButton){
        if(self.selectedBtn != nil){
            self.selectedBtn!.enabled=true
        }
        btn.enabled=false
        self.selectedBtn=btn
        
        // 通知代理
        if(self.delegate != nil){
            self.delegate!.emotionTabBar(self, didSelectButton: WBEmotionTabBarButtonType(rawValue: btn.tag)!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置按钮的frame
        let btnCount=self.subviews.count
        let btnW:CGFloat=self.width / CGFloat(btnCount)
        let btnH:CGFloat=self.height
        for i:Int in 0...btnCount-1{
            let btn=self.subviews[i] as! WBEmotionTabBarButton
            btn.y=0
            btn.width=btnW
            btn.x=CGFloat(i)*btnW
            btn.height=btnH
        }
    }
}
