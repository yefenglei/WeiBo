//
//  WBNewFeatureViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/21.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBNewFeatureViewController: UIViewController,UIScrollViewDelegate {
    let newFeatureCount=4
    var pageController:UIPageControl!
    var scrollW:CGFloat!
    var scrollH:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.创建一个scrollView,现实新特性的图片
        let scrollView=UIScrollView()
        scrollView.delegate=self
        scrollView.frame=self.view.bounds
        self.view.addSubview(scrollView)
        
        // 2.添加图片到scrollView中
        scrollW=scrollView.width
        scrollH=scrollView.height
        for i:Int in 0...newFeatureCount-1{
            let imageView=UIImageView()
            imageView.width=scrollW
            imageView.height=scrollH
            imageView.y=0
            imageView.x=CGFloat(i) * scrollW
            // 显示图片
            imageView.image=UIImage(named: "new_feature_\(i+1)")
            scrollView.addSubview(imageView)
        }
        
        // 3.设置scrollView的其他属性
        // 如果某个方向上不能滚动，那么这个方向对应的尺寸为0
        scrollView.contentSize=CGSizeMake(CGFloat(newFeatureCount)*scrollView.width, 0)
        scrollView.pagingEnabled=true
        scrollView.bounces=false
        scrollView.showsHorizontalScrollIndicator=false
        // 4.添加pageControl 分页，展示目前看的是第几页
        pageController=UIPageControl()
        pageController.userInteractionEnabled=false
        pageController.numberOfPages=newFeatureCount
        pageController.centerX=scrollW*0.5
        pageController.centerY=scrollH-50
        pageController.pageIndicatorTintColor=CommonHelper.Color(189, g: 189, b: 189, a: 1)
        pageController.currentPageIndicatorTintColor=CommonHelper.Color(253, g: 98, b: 42, a: 1)
        self.view.addSubview(pageController)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page=Int(scrollView.contentOffset.x/scrollW+0.5)
        self.pageController.currentPage=page
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
