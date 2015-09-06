//
//  Common.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/5.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import Foundation
import UIKit

class CommonHelper{
    // 随机色
    static var randomColor:UIColor{
        get{
            return UIColor(red: CGFloat(Double(arc4random_uniform(256))/255.0), green: CGFloat(Double(arc4random_uniform(256))/255.0), blue: CGFloat(Double(arc4random_uniform(256))/255.0), alpha: 1.0)
        }

    }
    // 文字颜色
    static var fontColor:UIColor{
        get{
            return UIColor(red: CGFloat(Double(arc4random_uniform(123))/255.0), green: CGFloat(Double(arc4random_uniform(123))/255.0), blue: CGFloat(Double(arc4random_uniform(123))/255.0), alpha: 1.0)
        }
        
    }
    // RGB
    static func Color(r:Double,g:Double,b:Double,a:Double)->UIColor{
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(a))
    }
}


