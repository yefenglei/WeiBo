//
//  CacheTool.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/12/27.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import Foundation

class CacheTool {
    /// 缓存路径
    static let cachesPath=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
    
    /// 图片缓存大小
    static var imgaeCacheSize:Double{
        // 字节大小
        let byteSize=SDImageCache.sharedImageCache().getSize()
        // M大小
        return Double(byteSize)/1000.0/1000.0
    }
    /// 文件缓存大小
    static var fileCacheSize:Double{
        // 字节大小
        let byteSize=calcDirectorySize(cachesPath)
        // M大小
        return byteSize/1000.0/1000.0
    }
    
    /// 清空文件缓存
    static func clearFileCaches(){
        let mgr=NSFileManager.defaultManager()
        if(!mgr.fileExistsAtPath(cachesPath)){
            return
        }
        removeFilesUnderFolder(cachesPath)
        WBStatusTool.removeDatabase()
    }
    /// 清空图片缓存
    static func clearImagesCaches(){
        SDImageCache.sharedImageCache().clearDisk()
    }
    
    /// 清空文件夹下所有文件
    private static func removeFilesUnderFolder(folderPath:String){
        do{
            let contentOfFolder=try NSFileManager.defaultManager().contentsOfDirectoryAtPath(folderPath)
            for filename in contentOfFolder{
                // 拼接文件路径
                let filepath=(folderPath as NSString).stringByAppendingPathComponent(filename)
                do{
                    try NSFileManager.defaultManager().removeItemAtPath(filepath)
                
                }catch{
                    print("清理文件缓存失败，path:\(filepath)")
                }
            }
        }catch{
            print("文件夹打开失败，path:\(folderPath)")
        }
    }
    
    /**
     ["NSFileSystemFileNumber": 18357040, 
     "NSFileExtensionHidden": 0, 
     "NSFileModificationDate": 2015-12-20 07:52:41 +0000, 
     "NSFileGroupOwnerAccountID": 501,
     "NSFileOwnerAccountID": 501, 
     "NSFileSize": 344064, 
     "NSFileOwnerAccountName": mobile,
     "NSFileCreationDate": 2015-12-20 07:52:26 +0000, 
     "NSFileSystemNumber": 16777219,
     "NSFileProtectionKey": NSFileProtectionCompleteUntilFirstUserAuthentication, 
     "NSFilePosixPermissions": 420,
     "NSFileReferenceCount": 1, 
     "NSFileGroupOwnerAccountName": mobile,
     "NSFileType": NSFileTypeRegular]
     */
     
     
    /// 计算文件夹大小
    private static func calcDirectorySize(folderPath:String)->Double{
        var totalSize:Double=0
        if(!NSFileManager.defaultManager().fileExistsAtPath(folderPath)){
            return totalSize
        }
        do{
            let contentOfFolder=try NSFileManager.defaultManager().contentsOfDirectoryAtPath(folderPath)
            for filename in contentOfFolder{
                // 拼接文件路径
                let filepath=(folderPath as NSString).stringByAppendingPathComponent(filename)
                do{
                    let attributes=try NSFileManager.defaultManager().attributesOfItemAtPath(filepath)
                    if((attributes[NSFileType] as! String) != NSFileTypeDirectory){
                        // 是文件
                        let fileSize=attributes[NSFileSize] as! Double
                        totalSize += fileSize
                    }else{
                        // 是文件夹
                        totalSize=totalSize+calcDirectorySize(filepath)
                    }
                    
                }catch{
                    print("获取文件属性失败，path:\(filepath)")
                }
            }
        }catch{
            print("读取文件夹失败，path:\(folderPath)")
        }
 
        return totalSize
    }
    
}