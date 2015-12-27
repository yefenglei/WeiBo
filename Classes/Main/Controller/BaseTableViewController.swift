//
//  BaseTableViewController.swift
//  IOSHelper
//
//  Created by 叶锋雷 on 15/11/19.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    private var _dataList:[CellGroup]!
    
    init(){
        super.init(style: UITableViewStyle.Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset=UIEdgeInsetsMake(15, 0, 0, 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self._dataList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self._dataList[section].cellItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=BaseCell.cellWithTableView(tableView)
        let cellitem=self._dataList[indexPath.section].cellItems[indexPath.row]
        cell.setItem(cellitem)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消选中
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // 取出模型
        let cell=self._dataList[indexPath.section].cellItems[indexPath.row]
        // 执行操作
        if(cell.option != nil){
            cell.option!()
            self.tableView.reloadData()
            return
        }
        
        let arrowCell=cell as? ArrowCellItem
        if(arrowCell != nil && arrowCell!.targetViewControllerName != nil){
            // 如果是箭头模型
            let vc:UIViewController!
            if(arrowCell!.useStoryboard==true){
                // 从storyboard中加载view
                let mainSB=UIStoryboard(name: "Main", bundle: nil)
                vc=mainSB.instantiateViewControllerWithIdentifier(arrowCell!.targetViewControllerName)
            }else{
                let vcTpye=swiftClassFromString(arrowCell!.targetViewControllerName) as! UIViewController.Type
                vc=vcTpye.init()
                vc.title=arrowCell?.title
            }
            if #available(iOS 8.0, *) {
                self.navigationController?.showViewController(vc, sender: self)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // 设置group的头部信息
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self._dataList[section].header
    }
    // 设置group的尾部信息
   override  func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self._dataList[section].footer
    }
    
    // 设置数据源
    func setDataList(dataList:[CellGroup]){
        self._dataList=dataList
    }
    
    func addGroupToDataList(group:CellGroup){
        self._dataList.append(group)
    }
    
    func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? NSString {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            let classStringName = "_TtC\(appName.length)\(appName)\((className as NSString).length)\(className)"
            // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }

}
