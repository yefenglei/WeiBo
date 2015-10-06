//
//  WBIconView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/4.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBIconView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    private var _user:WBUser?
    var user:WBUser?{
        set{
            self._user=newValue
            
            // 1.下载图片
            self.sd_setImageWithURL(NSURL(string: newValue!.profile_image_url), placeholderImage: UIImage(named: "avatar_default_small"))
            
            // 2.设置加V图片
            if let verifiedType=newValue!.verified_type{
                switch(verifiedType){
                case 0: // 个人认证
                    self.verifiedView.hidden=false
                    self.verifiedView.image=UIImage(named: "avatar_vip")
                    break
                case 2,3,5: // 官方认证
                    self.verifiedView.hidden=false
                    self.verifiedView.image=UIImage(named: "avatar_enterprise_vip")
                    break
                case 220: // 微博达人
                    self.verifiedView.hidden=false
                    self.verifiedView.image=UIImage(named: "avatar_grassroot")
                    break
                default:
                    self.verifiedView.hidden=true // 当做没有任何认证
                    break
                }
            }else{
                self.verifiedView.hidden=true // 当做没有任何认证
            }
        }
        get{
            return self._user
        }
    }
    
    private var _verifiedView:UIImageView?
    var verifiedView:UIImageView!{
        get{
            if(self._verifiedView == nil){
                self._verifiedView=UIImageView()
                self.addSubview(self._verifiedView!)
            }
            return self._verifiedView!
        }
        set{
            self._verifiedView=newValue
        }
    }
    
    override func layoutSubviews() {
        if let image=self.verifiedView.image{
            self.verifiedView.size=image.size
        }else{
            self.verifiedView.size=CGSize.zero
        }
        let scale:CGFloat=0.6
        self.verifiedView.x=self.width-self.verifiedView.width*scale
        self.verifiedView.y=self.height-self.verifiedView.height*scale
    }
    
}
