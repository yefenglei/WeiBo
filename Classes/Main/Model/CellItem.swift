//
//  CellItem.swift
//  IOSHelper
//
//  Created by 叶锋雷 on 15/11/19.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

typealias ItemOption=()->Void

class CellItem:NSObject{
    var title:String!
    var icon:String?
    var option:ItemOption?
    var subTitle:String?
    init(title:String!,icon:String?){
        self.title=title
        self.icon=icon
    }
}