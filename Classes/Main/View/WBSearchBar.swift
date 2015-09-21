//
//  WBSearchBar.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/9.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBSearchBar: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    convenience init(){
        self.init(frame: CGRectMake(0, 0, 0, 0))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font=UIFont.systemFontOfSize(15)
        self.placeholder="请输入搜索条件"
        self.background=UIImage(named:"searchbar_textfield_background")
        self.frame=frame
        
        let searchIcon=UIImageView()
        searchIcon.height=30
        searchIcon.width=30
        searchIcon.image=UIImage(named: "searchbar_textfield_search_icon")
        searchIcon.contentMode=UIViewContentMode.Center
        self.leftView=searchIcon
        self.leftViewMode=UITextFieldViewMode.Always
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
