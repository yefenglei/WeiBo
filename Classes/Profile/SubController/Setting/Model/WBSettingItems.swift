//
//  WBSettingItems.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/12/27.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class WBSettingItems{
    
    static private var _dataList:[CellGroup]?
    static var dataList:[CellGroup]{
        get{
            self._dataList=[CellGroup]()
            // 0组
            let group=CellGroup()
            let itemClearCache=CellItem(title: "清空全部缓存", icon: nil)
            let fileCacheSize=CacheTool.fileCacheSize
            itemClearCache.option={[weak itemClearCache]()->Void in
                MBProgressHUD.showMessage("正在清空缓存...")
                CacheTool.clearFileCaches()
                MBProgressHUD.hideHUD()
                itemClearCache!.subTitle=NSString(format: "%0.1fM", CacheTool.fileCacheSize) as String
            }
            itemClearCache.subTitle=NSString(format: "%0.1fM", fileCacheSize) as String
            let itemClearImageCache=CellItem(title: "清空图片缓存", icon: nil)
            let imageCacheSize=CacheTool.imgaeCacheSize
            itemClearImageCache.subTitle=NSString(format: "%0.1fM", imageCacheSize) as String
            itemClearImageCache.option={[weak itemClearImageCache]()->Void in
                MBProgressHUD.showMessage("正在清空缓存...")
                CacheTool.clearImagesCaches()
                MBProgressHUD.hideHUD()
                itemClearImageCache!.subTitle=NSString(format: "%0.1fM", CacheTool.imgaeCacheSize) as String
            }
            group.addCellItem(itemClearCache)
            group.addCellItem(itemClearImageCache)
    
            self._dataList!.append(group)
            return self._dataList!
        }
        set{
            self._dataList=newValue
        }
    }
}