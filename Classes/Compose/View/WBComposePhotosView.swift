//
//  WBComposePhotosView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/12.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBComposePhotosView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var photos:[UIImage]=[UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addPhoto(photo:UIImage){
        let photoView=UIImageView()
        photoView.image=photo
        self.addSubview(photoView)
        
        // 存储图片
        self.photos.append(photo)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置图片的尺寸和位置
        let count=self.subviews.count
        let maxCol:Int=4
        let imageWH:CGFloat=70
        let imageMargin:CGFloat=10
        for i:Int in 0...count-1{
            let photoView=self.subviews[i] as! UIImageView
            let col = CGFloat(i % maxCol)
            photoView.x=col*(imageWH+imageMargin)
            
            let row=CGFloat(i/maxCol)
            photoView.y=row*(imageWH + imageMargin)
            photoView.width=imageWH
            photoView.height=imageWH
        }
    }
    
}
