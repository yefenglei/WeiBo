//
//  WBLog.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/9.
//  Copyright (c) 2015年 叶锋雷. All rights reserved.
//

import Foundation
class WBLog{
    static func Log(message:String){
        #if DEBUG
            NSLog(message)
        #endif
    }
    
    static func Log(format: String, args: CVarArgType){
        #if DEBUG
            NSLog(format, args)
        #endif
    }
}