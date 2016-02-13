//
//  WBTitleButton.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/26.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let WBMargin:CGFloat=5
    override init(frame:CGRect){
        super.init(frame: frame)
        // 设置文字大小 图片
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.titleLabel?.font=UIFont.systemFontOfSize(17)
        self.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        self.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // 目的：想在系统计算和设置完按钮的尺寸后，再修改一下尺寸
    /**
    *  重写setFrame:方法的目的：拦截设置按钮尺寸的过程
    *  如果想在系统设置完控件的尺寸后，再做修改，而且要保证修改成功，一般都是在setFrame:中设置
    */
    override var frame:CGRect{
        set{
            var f = newValue
            f.size.width += WBMargin
            super.frame=f
        }
        get{
            return super.frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
        
        // 1.计算titleLabel的frame]
        self.titleLabel?.x=self.imageView!.x
        // 2.计算imageView的frame
        self.imageView?.x=CGRectGetMaxX(self.titleLabel!.frame)+WBMargin
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        // 只要修改了文字，就让按钮重新计算自己的尺寸
        self.sizeToFit()
    }
    
    override func setImage(image: UIImage?, forState state: UIControlState) {
        super.setImage(image, forState: state)
        // 只要修改了图片，就让按钮重新计算自己的尺寸
        self.sizeToFit()
    }
}
