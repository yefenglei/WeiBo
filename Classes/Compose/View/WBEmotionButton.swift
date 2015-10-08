//
//  WBEmotionButton.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/7.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBEmotionButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    private var _emotion:WBEmotion?
    var emotion:WBEmotion!{
        set{
            self._emotion=newValue
            if(newValue.png != nil){
                // 有图片
                self.setImage(UIImage(named: newValue.png!), forState: UIControlState.Normal)
            }else if(newValue.code != nil){
                // 是emoji表情
                // 设置emoji
                self.setTitle((newValue.code! as NSString).emoji() as String , forState: UIControlState.Normal)
            }
        }
        get{
            return self._emotion
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    func setup(){
        self.titleLabel?.font=UIFont.systemFontOfSize(32)
        
        // 按钮高亮的时候。不要去调整图片（不要调整图片会灰色）
        self.adjustsImageWhenHighlighted=false
    }
    
}
