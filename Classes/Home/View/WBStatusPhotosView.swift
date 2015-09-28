//
//  WBStatusPhotosView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/27.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//  cell上面的配图相册（里面会显示1~9张图片, 里面都是HWStatusPhotoView）

import UIKit

let WBStatusPhotoWH:CGFloat=70
let WBStatusPhotoMargin:CGFloat=10
class WBStatusPhotosView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var _photos:NSArray?
    var photos:NSArray?{
        get{
            return self._photos
        }
        set{
            self._photos=newValue
            let photosCount=newValue!.count
            // 创建足够数量的图片控件
            // 这里的self.subviews.count不要单独赋值给其他变量
            while(self.subviews.count<photosCount){
                let photoView=WBStatusPhotoView(frame: CGRect.null)
                self.addSubview(photoView)
            }
            // 遍历所有的图片控件，设置图片
            let subviewsCount=self.subviews.count
            for i:Int in 0...subviewsCount-1{
                let photoView=self.subviews[i] as! WBStatusPhotoView
                if(i<photosCount){ // 显示
                    photoView.photo=newValue![i] as! WBPhoto
                    photoView.hidden=false
                }else{
                    // 隐藏
                    photoView.hidden=true
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置图片的尺寸和位置
        let photosCount=self.photos!.count
        let maxCol=WBStatusPhotosView.WBStatusPhotoMaxCol(photosCount)
        for i:Int in 0...photosCount-1{
            let photoView=self.subviews[i] as! WBStatusPhotoView
            let col = i % maxCol
            photoView.x = CGFloat(col) * (WBStatusPhotoWH + WBStatusPhotoMargin)
            let row=i/maxCol
            photoView.y=CGFloat(row)*(WBStatusPhotoWH + WBStatusPhotoMargin)
            photoView.width=WBStatusPhotoWH
            photoView.height=WBStatusPhotoWH
        }
    }
    
    static func size(count:Int)->CGSize{
        // 最大列数（一行最多有多少列）
        let maxCols=WBStatusPhotoMaxCol(count)
        
        let cols=(count >= maxCols) ? maxCols : count
        let photosW = CGFloat(cols) * WBStatusPhotoWH + CGFloat(cols-1)*WBStatusPhotoMargin
        // 行数
        let rows=(count + maxCols-1)/maxCols
        let photosH = CGFloat(rows) * WBStatusPhotoWH + CGFloat(rows-1)*WBStatusPhotoMargin
        
        return CGSizeMake(photosW, photosH)
    }
    
    static func WBStatusPhotoMaxCol(count:Int)->Int{
        return count==4 ? 2 : 3
    }
}
