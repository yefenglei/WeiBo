//
//  WBHomeTableViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/6.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBHomeTableViewController: UITableViewController,WBDropDownMenuDelegate {
    var statusFrames=NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor=CommonHelper.Color(211, g: 211, b: 211, a: 1)
        //获取用户信息（昵称）
        setupUserInfo();
        //设置导航栏内容
        setupNav();
        // 集成下拉刷新控件
        self.setupDownRefresh()
        
        // 集成上拉刷新控件
        self.setupUpRefresh()
        
//        let timer=NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(10), target: self, selector: "setupUnreadCount", userInfo: nil, repeats: true)
//        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
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
        // 1.拼接请求参数
        let account=WBAccountTool.account!
        let params=NSMutableDictionary()
        params["access_token"]=account.access_token
        
        //取出最前面的微博（最新的微博，ID最大的微博）
        let firstStatusF=self.statusFrames.firstObject as? WBStatusFrame
        if(firstStatusF != nil){
            // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
            params["since_id"]=firstStatusF!.status.idstr
        }
        // 2.发送请求
        WBHttpTool.get("https://api.weibo.com/2/statuses/friends_timeline.json", params: params, success: { (responseObject) -> Void in
            // 请求成功
            // 将 "微博字典"数组 转为 "微博模型"数组
            let newStatuses:NSMutableArray=WBStatus.objectArrayWithKeyValuesArray(responseObject["statuses"])
            // 将 HWStatus数组 转为 HWStatusFrame数组
            let newFrames=WBStatusFrame.statusFrames(newStatuses)
            
            // 将最新的微博数据，添加到总数组的最前面
            let range=NSMakeRange(0, newFrames.count)
            let set=NSIndexSet(indexesInRange: range)
            self.statusFrames.insertObjects(newFrames, atIndexes: set)
            
            // 刷新表格
            self.tableView.reloadData()
            
            // 结束刷新
            control.endRefreshing()
            
            //显示最新微博的数量
            self.showNewStatusCount(newStatuses.count)
            }) { (error) -> Void in
                // 请求失败
                control.endRefreshing()
        }
    }
    
///  加载更多的微博数据
    func loadMoreStatus(){
        // 1.拼接请求参数
        let account=WBAccountTool.account
        let params=NSMutableDictionary()
        params["access_token"]=account?.access_token
        
        // 取出最后面的微博（最新的微博，ID最大的微博）
        let lastStatusF=self.statusFrames.lastObject as? WBStatusFrame
        if(lastStatusF != nil){
            // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
            // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
            let maxId:Int64=Int64(lastStatusF!.status.idstr)!-1
            params["max_id"]=maxId.description
        }
        
        // 2.发送请求
        WBHttpTool.get("https://api.weibo.com/2/statuses/friends_timeline.json", params: params, success: { (responseObject) -> Void in
            // 将 "微博字典"数组 转为 "微博模型"数组
            let newStatuses=WBStatus.objectArrayWithKeyValuesArray(responseObject["statuses"])
            // 将 HWStatus数组 转为 HWStatusFrame数组
            let newFrames=WBStatusFrame.statusFrames(newStatuses)
            // 将更多的微博数据，添加到总数组的最后面
            self.statusFrames.addObjectsFromArray(newFrames)
            // 刷新表格
            self.tableView.reloadData()
            // 结束刷新(隐藏footer)
            self.tableView.tableFooterView?.hidden=true
            }) { (error) -> Void in
                self.tableView.tableFooterView?.hidden=true
        }
    }
///  获得未读数
    func setupUnreadCount(){
        // 1.拼接请求参数
        let account=WBAccountTool.account
        let params=NSMutableDictionary()
        params["access_token"]=account?.access_token
        params["uid"]=account?.uid
        
        // 2.发送请求
        WBHttpTool.get("https://rm.api.weibo.com/2/remind/unread_count.json", params: params, success: { (responseObject) -> Void in
            // 请求成功
            let status:NSNumber=responseObject["status"] as! NSNumber
            if(status.integerValue == 0){
                // 如果是0，得清空数字
                self.tabBarItem.badgeValue=nil
                UIApplication.sharedApplication().applicationIconBadgeNumber=0
            }else{
                // 非0情况
                self.tabBarItem.badgeValue=status.integerValue.description
                UIApplication.sharedApplication().applicationIconBadgeNumber=status.integerValue
            }
            }) { (error) -> Void in
                
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
    
///  集成上拉刷新控件
    func setupUpRefresh(){
        let footer=WBLoadMoreFooter.footer()
        footer.hidden=true
        self.tableView.tableFooterView=footer
    }
    
    ///  获取用户信息（昵称）
    func setupUserInfo(){
        // 1.拼接请求参数
        let account=WBAccountTool.account!
        let params=NSMutableDictionary()
        params["access_token"]=account.access_token
        params["uid"]=account.uid
        
        // 2.发送请求
        WBHttpTool.get("https://api.weibo.com/2/users/show.json", params: params, success: { (responseObject) -> Void in
            // 标题按钮
            let titleButtion=self.navigationItem.titleView as! UIButton
            // 设置名字
            let user=WBUser(keyValues: responseObject)
            titleButtion.setTitle(user.name, forState: UIControlState.Normal)
            // 存储昵称到沙盒中
            account.name=user.name
            WBAccountTool.saveAccount(account)
            }) { (error) -> Void in
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
    
    ///  显示最新微博的数量
    ///
    ///  - parameter count: 最新微博的数量
    func showNewStatusCount(count:Int){
        // 刷新成功(清空图标数字)
        self.tabBarItem.badgeValue=nil
        UIApplication.sharedApplication().applicationIconBadgeNumber=0
        
        // 1.创建label
        let label=UILabel()
        label.backgroundColor=UIColor(patternImage: UIImage(named: "timeline_new_status_background")!)
        label.width=UIScreen.mainScreen().bounds.size.width
        label.height=35
        
        // 2.设置其他属性
        if(count==0){
            label.text="没有新的微博数据，稍后再试"
        }else{
            label.text="共有\(count)条新的微博数据"
        }
        label.textColor=UIColor.whiteColor()
        label.textAlignment=NSTextAlignment.Center
        label.font=UIFont.systemFontOfSize(16)
        
        // 3.添加
        label.y=64-label.height
        // 将label添加到导航控制器的view中，并且是盖在导航栏下边
        self.navigationController?.view.insertSubview(label, belowSubview: self.navigationController!.navigationBar)
        
        // 4.动画
        // 先利用1s的时间，让label往下移动一段距离
        let duration:CGFloat=1.0
        UIView.animateWithDuration(NSTimeInterval(duration), animations: { () -> Void in
            label.transform=CGAffineTransformMakeTranslation(0, label.height)
            }, completion: { (finished) -> Void in
            // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
                let delay:CGFloat = 1.0
                // UIViewAnimationOptions.CurveLinear:匀速
                UIView.animateWithDuration(NSTimeInterval(duration), delay: NSTimeInterval(delay), options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    label.transform=CGAffineTransformIdentity
                    }, completion: { (finished) -> Void in
                        label.removeFromSuperview()
                })
        })
        
        // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
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
        return self.statusFrames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获得cell
        let cell:WBStatusCell=WBStatusCell.cellWithTabelView(tableView)
        
        // 给cell传递模型数据
        cell.statusFrame=self.statusFrames[indexPath.row] as? WBStatusFrame
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //    scrollView == self.tableView == self.view
        // 如果tableView还没有数据，就直接返回
        if(self.statusFrames.count == 0 || self.tableView.tableFooterView!.hidden == false){
            return
        }
        
        let offsetY:CGFloat=scrollView.contentOffset.y
        // 当最后一个cell完全显示在眼前时，contentOffset的y值
        let judgeOffsetY:CGFloat=scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView!.height
        if(offsetY >= judgeOffsetY){
            // 最后一个cell完全进入视野范围内
            // 显示footer
            self.tableView.tableFooterView?.hidden=false
            
            // 加载更多的微博数据
            self.loadMoreStatus()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let frame:WBStatusFrame=self.statusFrames[indexPath.row] as! WBStatusFrame
        return frame.cellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if #available(iOS 8.0, *) {
//            self.navigationController?.showViewController(WBTestViewController(), sender: self)
//        } else {
//            self.navigationController?.pushViewController(WBTestViewController(), animated: true)
//        }
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
