//
//  WBComposeToolbar.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/7.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

enum WBComposeToolbarButtonType:Int{
    case HWComposeToolbarButtonTypeCamera, // 拍照
    HWComposeToolbarButtonTypePicture, // 相册
    HWComposeToolbarButtonTypeMention, // @
    HWComposeToolbarButtonTypeTrend, // #
    HWComposeToolbarButtonTypeEmotion // 表情
}

protocol WBComposeToolbarDelegate:NSObjectProtocol{
    func composeToolbar(toolbar:WBComposeToolbar,didClickButton buttonType:WBComposeToolbarButtonType)
}

class WBComposeToolbar: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate:WBComposeToolbarDelegate?
    lazy var emotionButton:UIButton=UIButton()
    
    /** 是否要显示键盘按钮  */
    private var _showKeyboardButton:Bool?
    var showKeyboardButton:Bool!{
        get{
            if(self._showKeyboardButton == nil){
                return false
            }else{
                return self._showKeyboardButton!
            }
        }
        set{
            self._showKeyboardButton=newValue
            // 默认的图片名
            var image="compose_emoticonbutton_background"
            var highImage="compose_emoticonbutton_background_highlighted"
            
            // 显示键盘图标
            if(self.showKeyboardButton == true){
                image = "compose_keyboardbutton_background"
                highImage = "compose_keyboardbutton_background_highlighted"
            }
            
            // 设置图片
            self.emotionButton.setImage(UIImage(named: image), forState: UIControlState.Normal)
            self.emotionButton.setImage(UIImage(named: highImage), forState: UIControlState.Highlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor=UIColor(patternImage: UIImage(named: "compose_toolbar_background")!)
        // 初始化按钮
        self.setupBtn("compose_camerabutton_background", highImage: "compose_camerabutton_background_highlighted", type: WBComposeToolbarButtonType.HWComposeToolbarButtonTypeCamera)
        
        self.setupBtn("compose_toolbar_picture", highImage: "compose_toolbar_picture_highlighted", type: WBComposeToolbarButtonType.HWComposeToolbarButtonTypePicture)
        
        self.setupBtn("compose_mentionbutton_background", highImage: "compose_mentionbutton_background_highlighted", type: WBComposeToolbarButtonType.HWComposeToolbarButtonTypeMention)
        
        self.setupBtn("compose_trendbutton_background", highImage: "compose_trendbutton_background_highlighted", type: WBComposeToolbarButtonType.HWComposeToolbarButtonTypeTrend)
        
        self.setupBtn("compose_emoticonbutton_background", highImage: "compose_emoticonbutton_background_highlighted", type: WBComposeToolbarButtonType.HWComposeToolbarButtonTypeEmotion)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    ///  创建一个按钮
    ///
    ///  - parameter image:     普通状态下的图片
    ///  - parameter highImage: 高亮状态下的图片
    ///  - parameter type:      按钮类型
    ///
    ///  - returns: 按钮
    func setupBtn(image:String,highImage:String,type:WBComposeToolbarButtonType)->UIButton{
        let btn=UIButton()
        btn.setImage(UIImage(named: image), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: highImage), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: "btnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.tag = type.rawValue
        self.addSubview(btn)
        return btn
    }
    
    func btnClicked(btn:UIButton){
        if(self.delegate != nil && self.delegate!.respondsToSelector("composeToolbar::")){
            self.delegate!.composeToolbar(self, didClickButton: WBComposeToolbarButtonType(rawValue: btn.tag)!)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置所有按钮的frame
        let count=self.subviews.count
        let btnW:CGFloat=self.width / CGFloat(count)
        let btnH:CGFloat=self.height
        for i:Int in 0...count-1{
            let btn=self.subviews[i] as! UIButton
            btn.y=0
            btn.width=btnW
            btn.x = CGFloat(i) * btnW
            btn.height=btnH
        }
    }
}
