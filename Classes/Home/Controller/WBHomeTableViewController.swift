//
//  WBHomeTableViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/6.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBHomeTableViewController: UITableViewController,WBDropDownMenuDelegate {
    lazy var statusFrames=NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取用户信息（昵称）
        setupUserInfo();
        //设置导航栏内容
        setupNav();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    ///  标题点击
    ///
    ///  - parameter button:
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
    
    ///  UIRefreshControl进入刷新状态：加载最新的数据
    ///
    ///  - parameter control: 下拉刷新控件
    func loadNewStatus(control:UIRefreshControl){
        // 1.请求管理者
        let mgr=AFHTTPRequestOperationManager()
        // 2.拼接请求参数
        let account=WBAccountTool.account!
        let params=NSMutableDictionary()
        params["access_token"]=account.access_token
        
        //取出最前面的微博（最新的微博，ID最大的微博）
        let firstStatusF=self.statusFrames.firstObject as? WBStatusFrame
        if(firstStatusF != nil){
            // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
            params["since_id"]=firstStatusF!.status.idstr
        }
        // 3.发送请求
        mgr.GET("https://api.weibo.com/2/statuses/friends_timeline.json", parameters: params, success: { (operation, responseObject) -> Void in
            // 请求成功
            // 将 "微博字典"数组 转为 "微博模型"数组
            let newStatuses=WBStatus.objectArrayWithKeyValuesArray(responseObject["statuses"])
            // 将 HWStatus数组 转为 HWStatusFrame数组
            
            
            }) { (operation, error) -> Void in
                // 请求失败
        }
        
    }
    
    
    
///  集成下拉刷新控件
    func setupDownRefresh(){
        // 1.添加刷新控件
        let control=UIRefreshControl()
        // 只有用户通过手动下拉刷新，才会触发UIControlEventValueChanged事件
        control.addTarget(self, action: "loadNewStatus:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(control)
        // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
        control.beginRefreshing()
        // 3.马上加载数据
        self.loadNewStatus(control)
    }
    
    ///  获取用户信息（昵称）
    func setupUserInfo(){
        // 1.请求管理者
        let mgr=AFHTTPRequestOperationManager()
        
        // 2.拼接请求参数
        let account=WBAccountTool.account!
        let params=NSMutableDictionary()
        params["access_token"]=account.access_token
        params["uid"]=account.uid
        
        // 3.发送请求
        mgr.GET("https://api.weibo.com/2/users/show.json", parameters: params, success: { (operation, responseObject) -> Void in
            // 标题按钮
            let titleButtion=self.navigationItem.titleView as! UIButton
            // 设置名字
            let user=WBUser(keyValues: responseObject)
            titleButtion.setTitle(user.name, forState: UIControlState.Normal)
            // 存储昵称到沙盒中
            account.name=user.name
            WBAccountTool.saveAccount(account)
            
            }) { (operation, error) -> Void in
                NSLog("请求失败：\(error)")
        }
    }
///  设置导航栏内容
    func setupNav(){
        /* 设置导航栏上面的内容 */
        self.navigationItem.leftBarButtonItem=UIBarButtonItem.itemWithTarget(self,action: "friendSearch:", image: "navigationbar_friendsearch", highlightImage: "navigationbar_friendsearch_highlighted")
        self.navigationItem.rightBarButtonItem=UIBarButtonItem.itemWithTarget(self,action: "pop:", image: "navigationbar_pop", highlightImage: "navigationbar_pop_highlighted")
        // 设置中间标题按钮
        let titleButton=WBTitleButton()
        // 设置图片和文字
        var name=WBAccountTool.account!.name
        name = (name==nil) ? name : "首页"
        titleButton.setTitle(name, forState: UIControlState.Normal)
        //var attrDict=[NSFontAttributeName:UIFont.systemFontOfSize(17)]
        //var titleRect=(titleButton.titleLabel!.text! as NSString).textRectWithSize(titleButton.titleLabel!.size, attributes: attrDict)
        // 监听标题点击
        titleButton.addTarget(self, action: "titleClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.titleView=titleButton
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
