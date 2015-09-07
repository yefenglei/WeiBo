//
//  WBTest2ViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/6.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBTest2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var btn=UIButton(frame: CGRectMake(60, 200, 200, 50))
        btn.setTitle("Go to home page", forState: UIControlState.Normal)
        btn.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        // Do any additional setup after loading the view.
    }
    
    func buttonClicked(button:UIButton){
        self.navigationController?.popToRootViewControllerAnimated(true)
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
