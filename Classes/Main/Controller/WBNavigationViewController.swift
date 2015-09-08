//
//  WBNavigationViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/7.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBNavigationViewController: UINavigationController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController:UIViewController){
        super.init(rootViewController: rootViewController)
        
        // 设置整个项目所有item的主题样式
        var barbuttom=UIBarButtonItem.appearance()
        
        // 设置普通状态
        var textAttrs=[NSForegroundColorAttributeName:UIColor.orangeColor(),NSFontAttributeName:UIFont.systemFontOfSize(15)]
        barbuttom.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal)
        // 设置不可用状态
        var disabledTextAttrs=[NSForegroundColorAttributeName:UIColor.grayColor(),NSFontAttributeName:UIFont.systemFontOfSize(15)]
        barbuttom.setTitleTextAttributes(disabledTextAttrs, forState: UIControlState.Disabled)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func showViewController(vc: UIViewController, sender: AnyObject!) {

        if(self.viewControllers.count==0){// rootview 不给它设置uibarbutton
            return
        }
        // 隐藏底部tabbar
        vc.hidesBottomBarWhenPushed=true
        
        vc.navigationItem.leftBarButtonItem=UIBarButtonItem.itemWithTarget(self,action:"back:", image: "navigationbar_back", highlightImage: "navigationbar_back_highlighted")
        vc.navigationItem.rightBarButtonItem=UIBarButtonItem.itemWithTarget(self,action:"more:", image: "navigationbar_more", highlightImage: "navigationbar_more_highlighted")
        
//        var backBtn=UIButton()
//        backBtn.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
//        // 设置图片
//        backBtn.setBackgroundImage(UIImage(named: "navigationbar_back")!, forState: UIControlState.Normal)
//        backBtn.setBackgroundImage(UIImage(named: "navigationbar_back_highlighted")!, forState: UIControlState.Highlighted)
//        // 设置尺寸
//        backBtn.size=backBtn.currentBackgroundImage!.size
//        vc.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: backBtn)
//        
//        var moreBtn=UIButton()
//        moreBtn.addTarget(self, action: "more:", forControlEvents: UIControlEvents.TouchUpInside)
//        moreBtn.setBackgroundImage(UIImage(named: "navigationbar_more"), forState: UIControlState.Normal)
//        moreBtn.setBackgroundImage(UIImage(named: "navigationbar_more_highlighted"), forState: UIControlState.Highlighted)
//        moreBtn.size=moreBtn.currentBackgroundImage!.size
//        vc.navigationItem.rightBarButtonItem=UIBarButtonItem(customView: moreBtn)
        
        // 跳转
        super.showViewController(vc, sender: sender)
    }
    /// back to last viewcontroller
    ///
    /// :param: UIButton button
    /// :returns: void
    func back(button:UIButton){
        self.popViewControllerAnimated(true)
    }
    /// back to the rootViewController
    ///
    /// :param: UIButton button
    /// :returns: void
    func more(button:UIButton){
        self.popToRootViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
