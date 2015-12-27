//
//  ArrowCellItem.swift
//  IOSHelper
//
//  Created by 叶锋雷 on 15/11/19.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation
class ArrowCellItem: CellItem {
    var targetViewControllerName:String!
    var useStoryboard:Bool!
    
    init(title: String, icon: String?,targetViewControllerName:String,useStoryboard:Bool=false){
        super.init(title: title, icon: icon)
        self.targetViewControllerName=targetViewControllerName
        self.useStoryboard=useStoryboard
    }
}