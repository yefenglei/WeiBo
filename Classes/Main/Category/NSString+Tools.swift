//
//  NSString+Tools.swift
//  UIDemo
//
//  Created by 叶锋雷 on 15/6/14.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import Foundation
import UIKit
extension NSString{
    func textRectWithSize(size:CGSize,attributes:NSDictionary)->CGRect{
        return self.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes as [NSObject : AnyObject], context: nil)
    }
}