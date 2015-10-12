//
//  WBEmotionPageView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/8.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBEmotionPageView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    /** 这一页显示的表情（里面都是HWEmotion模型） */
    private var _emotions:NSArray?
    var emotions:NSArray!{
        get{
            return self._emotions == nil ? NSArray():self._emotions!
        }
        set{
            self._emotions=newValue
            let count=newValue.count
            for i:Int in 0...count-1{
                let btn=WBEmotionButton()
                self.addSubview(btn)
                // 设置表情数据
                btn.emotion=newValue[i] as! WBEmotion
                // 监听按钮点击
                btn.addTarget(self, action: "btnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    

    
    /** 点击表情后弹出的放大镜 */
    lazy var popView:WBEmotionPopView=WBEmotionPopView()
    /** 删除按钮 */
    weak var deleteButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 1.删除按钮
        let deleteBtn=UIButton()
        deleteBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
        deleteBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
        deleteBtn.addTarget(self, action: "deleteClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(deleteBtn)
        self.deleteButton=deleteBtn
        
        // 2.添加长按手势
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPressPageView:"))
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
///  监听删除按钮点击
    func deleteClicked(){
        CommonHelper.WBNotificationCenter.postNotificationName(WBConstant.WBEmotionDidDeleteNotification, object: nil)
    }
    ///  监听表情按钮点击
    ///
    ///  - parameter btn: 被点击的表情按钮
    func btnClicked(btn:WBEmotionButton){
        // 显示popView
        self.popView.showFrom(btn)
        
        // 等会让popView自动消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC) * 250), dispatch_get_main_queue(), { () -> Void in
            self.popView.removeFromSuperview()
        })
        
        // 发出通知
        self.selectEmotion(btn.emotion)
    }
    
    ///  在这个方法中处理长按手势
    ///
    ///  - parameter recognizer: 手势
    func longPressPageView(recognizer:UILongPressGestureRecognizer){
        let location=recognizer.locationInView(recognizer.view)
        // 获得手指所在的位置\所在的表情按钮
        let btn=self.emotionButtonWithLocation(location)
        
        switch(recognizer.state){
        case UIGestureRecognizerState.Cancelled,UIGestureRecognizerState.Ended:
            // 手指已经不再触摸pageView
            // 移除popView
            self.popView.removeFromSuperview()
            
            // 如果手指还在表情按钮上
            if(btn != nil){
                // 发出通知
                self.selectEmotion(btn!.emotion)
            }
            break
        case UIGestureRecognizerState.Began,UIGestureRecognizerState.Changed:
            // 手势开始（刚检测到长按）
            // 手势改变（手指的位置改变）
            self.popView.showFrom(btn)
            break
        default:
            break
        }
    }
    
    ///  根据手指位置所在的表情按钮
    ///
    ///  - parameter location: 手指的位置
    func emotionButtonWithLocation(location:CGPoint)->WBEmotionButton?{
        if(self.emotions == nil){
            return nil
        }
        let count=self.emotions!.count
        for i:Int in 0...count-1{
            let btn=self.subviews[i+1] as! WBEmotionButton
            if(CGRectContainsPoint(btn.frame, location)){
                // 已经找到手指所在的表情按钮了，就没必要再往下遍历
                return btn
            }
        }
        return nil
    }
    
    ///  选中某个表情，发出通知
    ///
    ///  - parameter emotion: 被选中的表情
    func selectEmotion(emotion:WBEmotion){
        // 将这个表情存进沙盒
        WBEmotionTool.addRecentEmotion(emotion)
        
        // 发出通知
        var userInfo=[String : AnyObject]()
        userInfo[WBConstant.WBSelectEmotionKey]=emotion
        CommonHelper.WBNotificationCenter.postNotificationName(WBConstant.WBEmotionDidSelectNotification, object: nil, userInfo: userInfo)
    }
    
    // CUICatalog: Invalid asset name supplied: (null), or invalid scale factor: 2.000000
    // 警告原因：尝试去加载的图片不存在
    override func layoutSubviews() {
        super.layoutSubviews()
        // 内边距（四周）
        let inset:CGFloat=20
        let count=self.emotions.count
        let btnW:CGFloat=(self.width - 2*inset) / WBConstant.WBEmotionMaxCols
        let btnH=(self.height - inset) / WBConstant.WBEmotionMaxRows
        for i:Int in 0...count-1{
            let btn=self.subviews[i+1] as! WBEmotionButton
            btn.width=btnW
            btn.height=btnH
            btn.x=inset+(CGFloat(i) % WBConstant.WBEmotionMaxCols) * btnW
            btn.y=inset+(CGFloat(i) / WBConstant.WBEmotionMaxCols) * btnH
        }
        
        // 删除按钮
        self.deleteButton.width=btnW
        self.deleteButton.height=btnH
        self.deleteButton.y=self.height-btnH
        self.deleteButton.x=self.width-inset-btnW
    }
    
}
