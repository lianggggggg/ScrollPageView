//
//  ScrollPageViewConfiguration.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/28.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

public enum TitleImagePosition {
    case left
    case right
    case top
    case bottom
    case center
    case normal
}




//配置管理
public class ScrollPageViewConfiguration {
    open var isShowCover:Bool = false  //是否显示遮挡层
    open var isShowLine:Bool = true  //是否显示滚动线条
    open var isShowImage:Bool = false  //是否显示图片
    open var isShowExtraButton:Bool = false  //是否显示附加按钮
    open var isScaleTitleView:Bool = false //标题是否有缩放效果
    open var isScrollTitleView:Bool = true //是否滚动标题 默认为true 设置为false的时候所有的标题将不会滚动, 并且宽度会平分 和系统的segment效果相似
    open var isSegmentViewBounces:Bool = true  //顶部是否具有弹性
    open var isContentViewBounces:Bool = true //contentView是否具有弹性
    open var isGradualChangeTitleColor:Bool = true  //title颜色是否渐进
    open var isScrollContentView:Bool = true //contentView是否滑动
    open var isAnimatedContentViewWhenTitleClicked:Bool = true //点击标题切换时contentView是否有动画
    open var isAdjustCoverOrLineWidth:Bool = false //当设置 isScrollTitleView = false 的时候标题会平分宽度, 如果你希望在滚动的过程中cover或者scrollLine的宽度随着变化设置这个属性为true 默认为false
    open var isAutoAdjustTitlesWidth:Bool = true  //是否自动调整标题的宽度, 当设置为 true 的时候 如果所有的标题的宽度之和小于segmentView的宽度的时候, 会自动调整title的位置, 达到类似"平分"的效果
    open var isAdjustTitleWhenBeginDrag:Bool = true  //是否在开始滚动的时候就调整标题栏
    open var animationTime:CGFloat = 0.3 //滑动后的动画效果
    open var extraBtnBackgroundImageName:String? = nil //设置附加按钮的背景图片
    open var scrollLineHeight:CGFloat = 2 //滚动条的高度
    open var scrollLineColor:UIColor = UIColor.blue  //滚动条的颜色
    open var coverBackgroundColor:UIColor = UIColor.yellow //遮盖的颜色
    open var coverCornerRadius:CGFloat = 14.0  //遮盖的圆角
    open var coverHeight:CGFloat = 28.0  //遮盖的高度
    open var titleViewMargin:CGFloat = 15.0  //标题之间的宽度
    open var titleViewFont:UIFont = UIFont.systemFont(ofSize: 14) //titleView上字体的大小
    open var titleViewBigScale:CGFloat = 1.3  //titleView的放大倍数
    open var normalTitleColor:UIColor = UIColor.init(red: 51.0/255.0, green: 53.0/255.0, blue: 75/255.0, alpha: 1.0)  //titleView的title的默认颜色
    open var selectedTitleColor:UIColor = UIColor.init(red: 255.0/255.0, green: 0.0/255.0, blue: 121/255.0, alpha: 1.0)  //titleView的title的选中颜色
    open var segmentHeight:CGFloat = 44.0 //segmentView的高度
    
    open var imagePosition:TitleImagePosition? = nil  //标题中图片的位置
    open var normalImgColor:UIColor = UIColor.red //默认时图片的颜色
    open var selectedImgColor:UIColor = UIColor.blue //选中时的图片颜色
    
    public init(){
        
    }
    
    
}
