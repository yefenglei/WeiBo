//
//  WBUser.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/26.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation
enum WBUserVerifiedType:Int{
    case HWUserVerifiedTypeNone = -1, // 没有任何认证
    
    HWUserVerifiedPersonal = 0,  // 个人认证
    
    HWUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    HWUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    HWUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    
    HWUserVerifiedDaren = 220 // 微博达人
}
class WBUser:NSObject{
 /// string	字符串型的用户UID
    var idstr:String!
 /// string	友好显示名称
    var name:String!
 /// string	用户头像地址，50×50像素
    var profile_image_url:String!
    private var _mbtype:Int!
 /// 会员类型 > 2代表是会员
    var mbtype:Int!{
        get{
            return self._mbtype
        }
        set{
            self._mbtype=newValue
            self._vip = newValue>2
        }
    }
 /// 会员等级
    private var _mbrank:Int!
    var mbrank:Int!
    
    private var _vip:Bool!
    var vip:Bool!
 /// 认证类型
    var verified_type:WBUserVerifiedType?

}