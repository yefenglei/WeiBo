//
//  WBEmotionPopView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/8.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//  用来表示一页的表情（里面显示1~20个表情）

import UIKit

class WBEmotionPopView: UIView {
    @IBOutlet weak var emotionButton: WBEmotionButton!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    static func popView()->WBEmotionPopView{
        return NSBundle.mainBundle().loadNibNamed("WBEmotionPopView", owner: nil, options: nil).last as! WBEmotionPopView
    }
    
    func showFrom(button:WBEmotionButton?){
        if let btn = button{
            // 给popView传递数据
            self.emotionButton.emotion=btn.emotion
            
            // 取得最上面的window
            let window = UIApplication.sharedApplication().windows.last
            window?.addSubview(self)
            
            // 计算出被点击的按钮在window中的frame
            let btnFrame = btn.convertRect(btn.bounds, toView: nil)
            self.y=CGRectGetMidY(btnFrame)-self.height //100
            self.centerX=CGRectGetMidX(btnFrame)
        }
    }

}
