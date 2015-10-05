//
//  WBLoadMoreFooter.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/5.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBLoadMoreFooter:UIView{
    static func footer()->WBLoadMoreFooter{
        return NSBundle.mainBundle().loadNibNamed("WBLoadMoreFooter", owner: nil, options: nil).last as! WBLoadMoreFooter
    }
}