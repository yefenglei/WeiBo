//
//  WBEmotionTextView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/8.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBEmotionTextView: WBTextView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func insertEmotion(emotion:WBEmotion){
        if(emotion.code != nil){
            self.insertText((emotion.code! as NSString).emoji() as String)
        }else if(emotion.png != nil){
            // 加载图片
            let attch=WBEmotionAttachment()
            
            // 传递模型
            attch.emotion=emotion
            
            // 设置图片的尺寸
            let attchWH:CGFloat=self.font!.lineHeight
            attch.bounds=CGRectMake(0, -4, attchWH, attchWH)
            
            // 根据附件创建一个属性文字
            let imageStr=NSAttributedString(attachment: attch)
            
            // 插入属性文字到光标位置
            self.insertAttributedText(imageStr, settingBlock: { (attr:NSMutableAttributedString) -> Void in
                // 设置字体
                attr.addAttribute(NSFontAttributeName, value: self.font!, range: NSMakeRange(0, attr.length))
            })
        }
    }
    
    func fullText()->String{
        let fullText=NSMutableString()
        
        // 遍历所有的属性文字（图片、emoji、普通文字）
        self.attributedText?.enumerateAttributesInRange(NSMakeRange(0, self.attributedText!.length), options: NSAttributedStringEnumerationOptions.init(rawValue: 0), usingBlock: { (attrs:[String : AnyObject], range:NSRange, stop) -> Void in
            // 如果是图片表情
            let attch=attrs["NSAttachment"] as? WBEmotionAttachment
            if(attch != nil){
                fullText.appendString(attch!.emotion!.chs!)
            }else{
                // emoji 普通文本
                // 获得这个范围内的文字
                let str=self.attributedText?.attributedSubstringFromRange(range)
                fullText.appendString(str!.string)
            }
        })
        
        return fullText as String
    }
    
    /**
    selectedRange :
    1.本来是用来控制textView的文字选中范围
    2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置
    
    关于textView文字的字体
    1.如果是普通文字（text），文字大小由textView.font控制
    2.如果是属性文字（attributedText），文字大小不受textView.font控制，应该利用NSMutableAttributedString的- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
    **/
}
