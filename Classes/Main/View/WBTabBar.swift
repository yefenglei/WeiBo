//
//  WBTabBar.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/15.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit
//warning 因为WBTabBar继承自UITabBar，所以称为WBTabBar的代理，也必须实现UITabBar的代理协议
protocol WBTabBarDelegate{
    func tabBarDidClickPlusButton(tabBar:WBTabBar)
}
class WBTabBar: UITabBar {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var _plusButton:UIButton!
    //override var delegate:UITabBarDelegate?
    
    var wbDelegate:WBTabBarDelegate?
    
    init(){
        super.init(frame: CGRect.null)
        self.addPlusButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addPlusButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addPlusButton()
    }
    
    func addPlusButton(){
        // 添加一个按钮到tabbar中
        let plusBtn=UIButton()
        plusBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        plusBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        plusBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        plusBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        plusBtn.addTarget(self, action: "sendMessage:", forControlEvents: UIControlEvents.TouchUpInside)
        plusBtn.size=plusBtn.currentBackgroundImage!.size
        _plusButton=plusBtn
        self.addSubview(plusBtn)
    }
    
    ///  点击+号按钮，进入写微博界面
    ///
    ///  - parameter button: 按钮
    func sendMessage(button:UIButton){
//        let tv=WBComposeViewController()
//        let nav=WBNavigationViewController(rootViewController: tv)
//        self.window!.rootViewController!.presentViewController(nav, animated: true, completion: nil)
        if(wbDelegate != nil){
            self.wbDelegate!.tabBarDidClickPlusButton(self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 1.设置加号按钮的位置
        self._plusButton.centerX=self.width*0.5
        self._plusButton.centerY=self.height*0.5
        // 2.设置其它tabbarbutton的位置和尺寸
        let tabBarCount:Int=5
        var tabbarButtonIndex:CGFloat=0
        let tabbarButtonWidth:CGFloat=self.width/CGFloat(tabBarCount)
        let count=self.subviews.count
        if(count==0){
            return
        }
        for i:Int in 0...count-1{
            let childView=self.subviews[i] 
            let cls:AnyClass=NSClassFromString("UITabBarButton")!
            if(childView.isKindOfClass(cls)){
                // 设置宽度
                childView.width=tabbarButtonWidth
                // 设置x
                childView.x = CGFloat(tabbarButtonIndex) * childView.width
                tabbarButtonIndex++
                if(2==tabbarButtonIndex){
                    tabbarButtonIndex++
                }
                // 隐藏按钮
                //childView.hidden=true
            }
        }
    }

}
