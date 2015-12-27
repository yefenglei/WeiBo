//
//  BaseCell.swift
//  IOSHelper
//
//  Created by 叶锋雷 on 15/11/21.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    private var _item:CellItem!
    private lazy var _arrowImgView:UIImageView = UIImageView(image: UIImage(named: "CellArrow"))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 设置Cell的数据
    func setItem(item:CellItem){
        // 1.设置子控件的数据
        setUpData(item);
        // 2.设置右边视图
        setAccessoryView();

    }
    
    /// 设置子控件的数据
    private func setUpData(item:CellItem){
        self._item=item
        if(item.icon != nil){
            self.imageView?.image=UIImage(named: item.icon!)
        }
        self.textLabel?.text=item.title
        self.detailTextLabel?.text=item.subTitle
    }
    
    /// 设置右边视图
    private func setAccessoryView(){
        if(self._item.isKindOfClass(ArrowCellItem)){
            self.accessoryView=self._arrowImgView
            self.selectionStyle=UITableViewCellSelectionStyle.Default
        }else{
            self.accessoryView=nil
            self.selectionStyle=UITableViewCellSelectionStyle.Default
        }
    }
    
    static func cellWithTableView(tableview:UITableView)->BaseCell{
        let ID:String="cell"
        var cell = tableview.dequeueReusableCellWithIdentifier(ID) as? BaseCell
        if(cell == nil){
            cell=BaseCell(style: UITableViewCellStyle.Value1, reuseIdentifier: ID)
        }
        return cell!
    }

}
