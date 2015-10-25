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
        return self.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes as? [String : AnyObject], context: nil)
    }
    
    ///  将字符串转为 图文混排的字符串
    ///
    ///  - parameter attchWH: 行高
    ///
    ///  - returns: NSAttributedString
    func attributedStringWithString(attchWH:CGFloat)->NSAttributedString{
        // 1.加载本地表情
        let emotions=WBEmotionTool.allEmotions
        
        // 2.把上面的content转换为可变的属性字符串
        let attributeString = NSMutableAttributedString(string: self as String)
        
        // 3.进行正则匹配，获取每个表情在字符串中的范围，下面的正则表达式会匹配[/*],所以[123567]也会被匹配上，下面我们会做相应的处理
        let pattern = "\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
        var resultArray:[NSTextCheckingResult]=[NSTextCheckingResult]()
        do{
            let re = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            //通过正则表达式来匹配字符串
            resultArray = re.matchesInString(self as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length))
        }
        catch{
            
        }
        // 4.数据准备工作完成，下面开始遍历资源文件找到文字对应的图片，找到后把图片名存入字典中，图片在源字符串中的位置也要存入到字典中，最后把字典存入可变数组中。
        //用来存放字典，字典中存储的是图片和图片对应的位置
        var imageArray = [NSMutableDictionary]()
        
        //根据匹配范围来用图片进行相应的替换
        for match:NSTextCheckingResult in resultArray{
            //获取数组元素中得到range
            let range=match.range
            
            //获取原字符串中对应的值
            let subStr=self.substringWithRange(range)
            
            for i:Int in 0..<emotions.count{
                let emotion=emotions[i] as! WBEmotion
                if(emotion.code == nil && emotion.chs! == subStr){
                    //新建文字附件来存放我们的图片
                    let textAttachment:NSTextAttachment=NSTextAttachment()
                    
                    //let attchWH:CGFloat=20
                    textAttachment.bounds=CGRectMake(0, -4, attchWH, attchWH)
                    //给附件添加图片
                    textAttachment.image=UIImage(named: emotion.png!)
                    
                    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                    let imageStr=NSAttributedString(attachment: textAttachment)
                    
                    //把图片和图片对应的位置存入字典中
                    let imageDic=NSMutableDictionary(capacity: 2)
                    imageDic.setObject(imageStr, forKey: "image")
                    imageDic.setObject(range, forKey: "range")
                    
                    //把字典存入数组中
                    imageArray.append(imageDic)
                }
            }
        }
        
        
        // 5.转换完成，我们需要对attributeString进行替换，替换的时候要从后往前替换，弱从前往后替换，会造成range和图片要放的位置不匹配的问题。
        //从后往前替换
        for(var i:Int=imageArray.count-1;i>=0;i--){
            let range:NSRange=imageArray[i].valueForKey("range") as! NSRange
            //进行替换
            attributeString.replaceCharactersInRange(range, withAttributedString: imageArray[i].valueForKey("image") as! NSAttributedString)
        }
        
        // 6.返回替换好的可变属性字符串
        return attributeString

    }
}