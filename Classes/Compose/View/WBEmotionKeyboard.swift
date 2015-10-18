//
//  WBEmotionKeyboard.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/8.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//  表情键盘（整体）: HWEmotionListView + HWEmotionTabBar

import UIKit

class WBEmotionKeyboard: UIView,WBEmotionTabBarDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    /** 保存正在显示listView */
    var showingListView:WBEmotionListView?
    /** 表情内容 */
    private var _recentListView:WBEmotionListView?
    var recentListView:WBEmotionListView!{
        get{
            if(self._recentListView == nil){
                self._recentListView = WBEmotionListView()
                // 加载沙盒中的数据
                self._recentListView!.emotions=WBEmotionTool.recentEmotions()
            }
            return self._recentListView!
        }
        set{
            self._recentListView=newValue
        }
    }
    
    private var _defaultListView:WBEmotionListView?
    var defaultListView:WBEmotionListView!{
        get{
            if(self._defaultListView==nil){
                self.defaultListView=WBEmotionListView()
                let path=NSBundle.mainBundle().pathForResource("EmotionIcons/default/info.plist", ofType: nil)
                self._defaultListView!.emotions=WBEmotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: path!))
                
            }
            return self._defaultListView!
        }
        set{
            self._defaultListView=newValue
        }
    }
    
    private var _emojiListView:WBEmotionListView?
    var emojiListView:WBEmotionListView!{
        get{
            if(self._emojiListView == nil){
                self._emojiListView = WBEmotionListView()
                let path=NSBundle.mainBundle().pathForResource("EmotionIcons/emoji/info", ofType: "plist")
                self._emojiListView!.emotions=WBEmotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: path!))
            }
            return self._emojiListView!
        }
        set{
            self._emojiListView=newValue
        }
    }
    private var _lxhListView:WBEmotionListView?
    var lxhListView:WBEmotionListView!{
        get{
            if(self._lxhListView == nil){
                self._lxhListView = WBEmotionListView()
                let path=NSBundle.mainBundle().pathForResource("EmotionIcons/lxh/info.plist", ofType: nil)
                self._lxhListView!.emotions=WBEmotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: path!))
            }
            return self._lxhListView!
        }
        set{
            self._lxhListView=newValue
        }
    }
    /** tabbar */
    var tabBar:WBEmotionTabBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tabBar=WBEmotionTabBar()
        tabBar.delegate=self
        self.addSubview(tabBar)
        self.tabBar=tabBar
        
        // 第一次加载 选择默认
         self.emotionTabBar(self.tabBar,didSelectButton: WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeDefault)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1.tabbar
        self.tabBar.width=self.width
        self.tabBar.height=37
        self.tabBar.x=0
        self.tabBar.y=self.height-self.tabBar.height
        
        // 2.表情内容
        if(self.showingListView != nil){
            self.showingListView!.x=0
            self.showingListView!.y=0
            self.showingListView!.width=self.width
            self.showingListView!.height=self.tabBar.y
        }
    }
    
    func emotionTabBar(tabBar: WBEmotionTabBar, didSelectButton buttonType: WBEmotionTabBarButtonType) {
        // 移除正在显示的listView控件
        if(self.showingListView != nil){
            self.showingListView!.removeFromSuperview()
        }
        
        // 根据按钮类型，切换键盘上面的listview
        switch(buttonType){
        case WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeRecent:
            // 最近
            self.addSubview(self.recentListView)
            break
        case WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeDefault:
            // 默认
            self.addSubview(self.defaultListView)
            break
        case WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeEmoji:
            // Emoji
            self.addSubview(self.emojiListView)
            break
        case WBEmotionTabBarButtonType.WBEmotionTabBarButtonTypeLxh:
            // Lxh
            self.addSubview(self.lxhListView)
            break
        }
        
        // 设置正在显示的listView
        self.showingListView=self.subviews.last as? WBEmotionListView
        
        // 设置frame
        self.setNeedsLayout()
    }
}
