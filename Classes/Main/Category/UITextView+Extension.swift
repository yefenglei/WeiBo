//
//  UITextView+Extension.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/9.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

extension UITextView{
    func insertAttributedText(text:NSAttributedString){
        self.insertAttributedText(text, settingBlock: nil)
    }
    
    func insertAttributedText(text:NSAttributedString,settingBlock:((NSMutableAttributedString)->Void)?){
        let attributedText=NSMutableAttributedString()
        // 拼接之前的文字（图片和普通文字）
        attributedText.appendAttributedString(self.attributedText)
        
        // 拼接其他文字
        let loc=self.selectedRange.location
        attributedText.replaceCharactersInRange(self.selectedRange, withAttributedString: text)
        
        // 调用外面传进来的代码
        if(settingBlock != nil){
            settingBlock!(attributedText)
        }
        
        self.attributedText=attributedText
        
        // 移除光标到表情的后面
        self.selectedRange=NSMakeRange(loc + 1, 0)
    }
}