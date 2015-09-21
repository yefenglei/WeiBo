//
//  WBTestModalViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/21.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBTestModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=CommonHelper.randomColor
        let btn=UIButton(frame: CGRectMake(60, 200, 200, 50))
        btn.setTitle("Go back home page", forState: UIControlState.Normal)
        btn.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonClicked(button:UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
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
