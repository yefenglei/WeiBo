//
//  NSString+Extension.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/27.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation
extension NSString{
    func size(font:UIFont,maxW:CGFloat)->CGSize{
        let attrs=[NSFontAttributeName:font]
        let maxSize=CGSizeMake(maxW, CGFloat.max)
        return self.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    
    func size(font:UIFont)->CGSize{
        return self.size(font, maxW: CGFloat.max)
    }
}