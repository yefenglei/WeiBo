//
//  WBEmotionListView.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/8.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//  表情键盘顶部的内容:scrollView + pageControl

import UIKit

class WBEmotionListView: UIView,UIScrollViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    /** 表情(里面存放的HWEmotion模型) */
    private var _emotions:NSArray?
    
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    
    /** 根据emotions，创建对应个数的表情 */
    var emotions:NSArray!{
        get{
            return self._emotions == nil ? NSArray():self._emotions!
        }
        set{
            self._emotions=newValue
            let count=(emotions.count + Int(WBConstant.WBEmotionPageSize) - 1)/Int(WBConstant.WBEmotionPageSize)
            // 1.设置页数
            self.pageControl.numberOfPages=count
            if(count == 0){
                return
            }
            
            // 删除之前的控件
            self.scrollView.subviews.forEach { (view:UIView) -> () in
                view.removeFromSuperview()
            }
            // 2.创建用来显示每一项表情的控件
            for i:Int in 0...count-1{
                let pageView=WBEmotionPageView()
                // 计算这一页的表情范围
                var range=NSRange()
                range.location = i * Int(WBConstant.WBEmotionPageSize)
                // left：剩余的表情个数（可以截取的）
                let left=emotions.count-range.location
                if(left >= Int(WBConstant.WBEmotionPageSize)){
                    // 这一页足够20个
                    range.length = Int(WBConstant.WBEmotionPageSize)
                }else{
                    range.length=left
                }
                // 设置这一页的表情
                pageView.emotions = emotions.subarrayWithRange(range)
                self.scrollView.addSubview(pageView)
            }
            
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor=UIColor.whiteColor()
        // 1.UIScrollView
        let sv=UIScrollView()
        sv.pagingEnabled=true
        sv.delegate=self
        // 去除水平方向的滚动条
        sv.showsHorizontalScrollIndicator=false
        // 去除垂直方向的滚动条
        sv.showsVerticalScrollIndicator=false
        self.addSubview(sv)
        self.scrollView=sv
        
        // 2.pageControl
        let pc=UIPageControl()
        // 当只有1页时，自动隐藏pageControl
        pc.hidesForSinglePage=true
        pc.userInteractionEnabled=false
        // 设置内部的圆点图片
        pc.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKeyPath: "pageImage")
        pc.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKeyPath: "currentPageImage")
        self.addSubview(pc)
        self.pageControl=pc
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1.pageControl
        self.pageControl.width = self.width
        self.pageControl.height = 25
        self.pageControl.x = 0
        self.pageControl.y = self.height - self.pageControl.height
        
        // 2.scrollView
        self.scrollView.width=self.width
        self.scrollView.height=self.pageControl.y
        self.scrollView.x = 0
        self.scrollView.y = 0
        
        // 3.设置scrollView内部每一页的尺寸
        let count=self.scrollView.subviews.count
        if(count == 0){
            return
        }
        for i:Int in 0...count-1{
            let pageView=self.scrollView.subviews[i] as! WBEmotionPageView
            pageView.height=self.scrollView.height
            pageView.width=self.scrollView.width
            pageView.x = pageView.width * CGFloat(i)
            pageView.y=0
        }
        //4.设置scrollView的contentSize
        self.scrollView.contentSize=CGSizeMake(CGFloat(count)*self.scrollView.width, 0)
    }
    
    // MARK: scrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageNo:CGFloat=scrollView.contentOffset.x / scrollView.width
        self.pageControl.currentPage=Int(pageNo + 0.5)
    }
}
