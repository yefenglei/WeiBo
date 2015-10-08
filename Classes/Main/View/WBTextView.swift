//
//  WBTextView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/8.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBTextView: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let WBNotificationCenter=NSNotificationCenter.defaultCenter()

    private var _placeholder:String?
    var placeholder:String?{
        get{
            return self._placeholder
        }
        set{
            self._placeholder=newValue
            self.setNeedsDisplay()
        }
    }
    
    private var _placeholderColor:UIColor?
    var placeholderColor:UIColor?{
        get{
            return self._placeholderColor
        }
        set{
            self._placeholderColor=newValue
            self.setNeedsDisplay()
        }
    }
    
    override var text:String?{
        get{
            return self.text
        }
        set{
            self.text=newValue
            // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
            self.setNeedsDisplay()
        }
    }
    
    override var attributedText:NSAttributedString?{
        get{
            return self.attributedText
        }
        set{
            self.attributedText=newValue
            self.setNeedsDisplay()
        }
    }
    
    override var font:UIFont?{
        get{
            return self.font
        }
        set{
            self.font=newValue
            self.setNeedsDisplay()
        }
    }
    
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        // 通知
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        WBNotificationCenter.addObserver(self, selector: "textDidChange", name: UITextViewTextDidChangeNotification, object: self)
        
    }
    
    deinit{
        WBNotificationCenter.removeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
///  监听文字改变
    func textDidChange(){
        // 重绘（重新调用）
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        // 如果有输入文字，就直接返回，不画占位文字
        if(self.hasText()){
            return
        }
        // 文字属性
        var attrs=[String:AnyObject]()
        attrs[NSFontAttributeName]=self.font
        attrs[NSForegroundColorAttributeName]=self.placeholderColor == nil ? self.placeholderColor:UIColor.grayColor()
        // 画文字
        let x:CGFloat=5
        let w:CGFloat=rect.size.width - 2 * x
        let y:CGFloat=8
        let h:CGFloat=rect.size.height - 2*y
        let placeholderRect=CGRectMake(x, y, w, h)
        (self.placeholder! as NSString).drawInRect(placeholderRect, withAttributes: attrs)
    }
}
