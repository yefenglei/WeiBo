//
//  CellGroup.swift
//  IOSHelper
//
//  Created by 叶锋雷 on 15/11/19.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation
class CellGroup {
    var header:String?
    var footer:String?
    lazy var cellItems:[CellItem]=[CellItem]()
    
    init(){
    
    }
    
    init(cellItems:[CellItem],header:String?,footer:String?){
        self.cellItems=cellItems
        self.header=header
        self.footer=footer
    }
    
    func addCellItem(item:CellItem){
        self.cellItems.append(item)
    }
}