//
//  WBStatusPhotoView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/27.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBStatusPhotoView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var _photo:WBPhoto!
    var photo:WBPhoto!{
        get{
            return self._photo
        }
        set{
            self._photo=newValue
            // 设置图片
            self.sd_setImageWithURL(NSURL(string: photo.thumbnail_pic), placeholderImage: UIImage(named: "timeline_image_placeholder"))
            // 显示\隐藏gif控件
            // 判断是否以gif或者GIF结尾
            self.gifView.hidden = !photo.thumbnail_pic.lowercaseString.hasSuffix("gif")
        }
    }
    
    private var _gifView:UIImageView?
    var gifView:UIImageView{
        get{
            if(self._gifView == nil){
                let image=UIImage(named: "timeline_image_gif")
                let gifV=UIImageView(image: image)
                self.addSubview(gifV)
                self._gifView=gifV
            }
            return self._gifView!
        }
        set{
            self._gifView=newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gifView.x=self.width-self.gifView.width
        self.gifView.y=self.height-self.gifView.height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 内容模式
        self.contentMode=UIViewContentMode.ScaleAspectFill
        // 超出边框的内容都剪掉
        self.clipsToBounds=true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
