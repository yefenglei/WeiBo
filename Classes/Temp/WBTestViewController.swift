//
//  WBTestViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/6.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="测试1控制器"
        self.view.backgroundColor=CommonHelper.randomColor
        let btn=UIButton(frame: CGRectMake(60, 200, 200, 50))
        btn.setTitle("Go to next scene", forState: UIControlState.Normal)
        btn.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
        
        // Do any additional setup after loading the view.
    }
    
    func buttonClicked(button:UIButton){
        let test2=WBTest2ViewController()
        test2.view.backgroundColor=CommonHelper.randomColor
        test2.title="测试2控制器"
        if #available(iOS 8.0, *) {
            self.navigationController?.showViewController(test2, sender: self)
        } else {
            self.navigationController?.pushViewController(test2, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
