//
//  WBHomeTableViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/6.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBHomeTableViewController: UITableViewController,WBDropDownMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem=UIBarButtonItem.itemWithTarget(self,action: "friendSearch:", image: "navigationbar_friendsearch", highlightImage: "navigationbar_friendsearch_highlighted")
        self.navigationItem.rightBarButtonItem=UIBarButtonItem.itemWithTarget(self,action: "pop:", image: "navigationbar_pop", highlightImage: "navigationbar_pop_highlighted")
        
        // 设置中间按钮
        let titleButton=UIButton()
        titleButton.width=150
        titleButton.height=30
        // 设置文字 图片
        titleButton.setTitle("首页", forState: UIControlState.Normal)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.titleLabel?.font=UIFont.systemFontOfSize(17)
        titleButton.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        titleButton.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        
        //var attrDict=[NSFontAttributeName:UIFont.systemFontOfSize(17)]
        //var titleRect=(titleButton.titleLabel!.text! as NSString).textRectWithSize(titleButton.titleLabel!.size, attributes: attrDict)
        
        titleButton.imageEdgeInsets=UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        titleButton.addTarget(self, action: "titleClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.titleView=titleButton
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func titleClicked(button:UIButton){
        // 创建下拉菜单
        let menu=WBDropDownMenu()
        menu.delegate=self
        let tv=UITableView(frame: CGRectMake(0, 0, 100, 44*3))
        menu.userInteractionEnabled=true
        //menu.setContent(tv)
        let vc=WBDropDownContentTableViewController()
        vc.tableView=tv
        menu.setContentViewController(vc)
        // 显示
        menu.showFrom(button)
    }
    
    func friendSearch(button:UIBarButtonItem){
        WBLog.Log("left barbuttom friendSearch taped")
    }
    
    func pop(button:UIBarButtonItem){
        WBLog.Log("right barbuttom pop taped")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId:String="cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        // Configure the cell...
        cell!.textLabel?.text="text-message-\(indexPath.row)"
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if #available(iOS 8.0, *) {
            self.navigationController?.showViewController(WBTestViewController(), sender: self)
        } else {
            self.navigationController?.pushViewController(WBTestViewController(), animated: true)
        }
    }
    /// 下拉菜单被销毁
    ///
    /// - parameter menu: WBDropDownMenu
    /// - returns: void
    func dropdownMenuDidDismiss(menu: WBDropDownMenu) {
        let button=self.navigationItem.titleView as! UIButton
        // 箭头向下
        button.selected=false
    }
    /// 下拉菜单被显示
    ///
    /// - parameter menu: WBDropDownMenu
    /// - returns: void
    func dropdownMenuDidShow(menu: WBDropDownMenu) {
        let button=self.navigationItem.titleView as! UIButton
        // 箭头向上
        button.selected=true
    }
    
    /**/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
