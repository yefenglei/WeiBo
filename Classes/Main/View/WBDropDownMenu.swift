//
//  WBDropDownMenu.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/10.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

protocol WBDropDownMenuDelegate:NSObjectProtocol{
    func dropdownMenuDidDismiss(menu:WBDropDownMenu)
    func dropdownMenuDidShow(menu:WBDropDownMenu)
}
class WBDropDownMenu: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var delegate:WBDropDownMenuDelegate?
    private var _containerView:UIImageView?
    var containerView:UIImageView{
        get{
            if(_containerView == nil){
                // 添加带箭头的灰色图片
                let container=UIImageView()
                container.image=UIImage(named: "popover_background")
                //container.width=217
                //container.height=217
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

        // 设置灰色背景的高度
        self.containerView.height=CGRectGetMaxY(content.frame)+10
        // 设置灰色背景的宽度
        self.containerView.width=CGRectGetMaxX(content.frame)+10
        
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
        super.init(frame: CGRect.null)
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
        let window=UIApplication.sharedApplication().windows.last
        // 2.添加自己到窗口上
        window!.addSubview(self)
        // 3.设置尺寸
        self.frame=window!.bounds
        // 4.调整自己的位置
        // 转换坐标系
        let newFrame:CGRect=view.convertRect(view.bounds, toView: window)
        self.containerView.centerX=CGRectGetMidX(newFrame)
        self.containerView.y=CGRectGetMaxY(newFrame)
        
        // 5.显示向上剪头
        if let selfDelegate=self.delegate{
            if(selfDelegate.respondsToSelector("dropdownMenuDidShow:")){
                selfDelegate.dropdownMenuDidShow(self)
            }
        }
    }
    
    /// 销毁
    func dismiss(){
        self.removeFromSuperview()
        // 通知外界，自己被销毁了
        if let selfDelegate=self.delegate{
            if(selfDelegate.respondsToSelector("dropdownMenuDidDismiss:")){
                selfDelegate.dropdownMenuDidDismiss(self)
            }
        }

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismiss()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
