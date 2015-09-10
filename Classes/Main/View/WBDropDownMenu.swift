//
//  WBDropDownMenu.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/10.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBDropDownMenu: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var _containerView:UIImageView?
    var containerView:UIImageView{
        get{
            if(_containerView == nil){
                // 添加带箭头的灰色图片
                var container=UIImageView()
                container.image=UIImage(named: "popover_background")
                container.width=217
                container.height=217
                container.userInteractionEnabled=true
                self._containerView=container
                self.addSubview(self._containerView!)
            }
            return _containerView!
        }
    }
    
    private var _content:UIView?
    var content:UIView?{
        get{
            return _content
        }
    }
    ///添加内容
    func setContent(content:UIView){
        _content=content
        // 调整内容位置
        _content!.x=10
        _content!.y=15
        // 调整内容的宽度
        _content!.width=self.containerView.width-2*content.x
        // 设置灰色背景的尺寸
        self.containerView.height=CGRectGetMaxY(_content!.frame)+10
        
        
        self.containerView.addSubview(_content!)
    }
    
    private var _contentViewController:UIViewController?
    var contentViewController:UIViewController?{
        get{
            return _contentViewController
        }
    }
    // 添加内容控制器
    func setContentViewController(viewcontroller:UIViewController){
        setContent(viewcontroller.view)
        _contentViewController=viewcontroller
    }
    
    
    init(){
        super.init(frame: CGRect.nullRect)
        // 清除颜色
        self.backgroundColor=UIColor.clearColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView.frame=frame
        self.backgroundColor=UIColor.clearColor()
    }
    
    /// 显示
    func showFrom(view:UIView){
        // 1.获得最上层的窗口
        var window=UIApplication.sharedApplication().windows.last as! UIWindow
        // 2.添加自己到窗口上
        window.addSubview(self)
        // 3.设置尺寸
        self.frame=window.bounds
        // 4.调整自己的位置
        self.containerView.x=(self.width-self.containerView.width)*0.5
        self.containerView.y=50
    }
    
    /// 销毁
    func dismiss(){
        self.removeFromSuperview()
    }
    


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
