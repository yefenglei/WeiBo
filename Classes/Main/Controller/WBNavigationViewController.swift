//
//  WBNavigationViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/7.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBNavigationViewController: UINavigationController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController:UIViewController){
        super.init(rootViewController: rootViewController)
        
        // 设置整个项目所有item的主题样式
        let barbuttom=UIBarButtonItem.appearance()
        // 设置不可用状态
        let disabledTextAttrs=[NSForegroundColorAttributeName:UIColor.grayColor(),NSFontAttributeName:UIFont.systemFontOfSize(15)]
        barbuttom.setTitleTextAttributes(disabledTextAttrs, forState: UIControlState.Disabled)
        // 设置普通状态
        let textAttrs=[NSForegroundColorAttributeName:UIColor.orangeColor(),NSFontAttributeName:UIFont.systemFontOfSize(15)]
        barbuttom.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal)

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
    
    override func showViewController(vc: UIViewController, sender: AnyObject?) {

        if(self.viewControllers.count==0){// rootview 不给它设置uibarbutton
            return
        }
        // 隐藏底部tabbar
        vc.hidesBottomBarWhenPushed=true
        
        vc.navigationItem.leftBarButtonItem=UIBarButtonItem.itemWithTarget(self,action:"back:", image: "navigationbar_back", highlightImage: "navigationbar_back_highlighted")
        vc.navigationItem.rightBarButtonItem=UIBarButtonItem.itemWithTarget(self,action:"more:", image: "navigationbar_more", highlightImage: "navigationbar_more_highlighted")
        
        
        // 跳转
        if #available(iOS 8.0, *) {
            super.showViewController(vc, sender: sender)
        } else {
            super.pushViewController(vc, animated: true)
        }
    }
    /// back to last viewcontroller
    ///
    /// - parameter UIButton: button
    /// - returns: void
    func back(button:UIButton){
        self.popViewControllerAnimated(true)
    }
    /// back to the rootViewController
    ///
    /// - parameter UIButton: button
    /// - returns: void
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
