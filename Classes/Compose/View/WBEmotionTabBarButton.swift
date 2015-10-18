//
//  WBEmotionTabBarButton.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/8.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBEmotionTabBarButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置文字颜色
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Disabled)
        // 设置字体
        self.titleLabel?.font=UIFont.systemFontOfSize(13)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var highlighted:Bool{
        get{
            return false
        }
        set{
            
        }
    }

}
