//
//  ScrollPageViewOption.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/28.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

public enum ScrollPageViewOption{
    case isShowCover(Bool)
    case isShowLine(Bool)
    case isShowImage(Bool)
    case isShowExtraButton(Bool)
    case isScaleTitleView(Bool)
    case isScrollTitleView(Bool)
    case isSegmentViewBounces(Bool)
    case isContentViewBounces(Bool)
    case isGradualChangeTitleColor(Bool)
    case isScrollContentView(Bool)
    case isAnimatedContentViewWhenTitleClicked(Bool)
    case isAdjustCoverOrLineWidth(Bool)
    case animationTime(CGFloat)
    case isAutoAdjustTitlesWidth(Bool)
    case isAdjustTitleWhenBeginDrag(Bool)
    case extraBtnBackgroundImageName(String?)
    case scrollLineHeight(CGFloat)
    case scrollLineColor(UIColor)
    case coverBackgroundColor(UIColor)
    case coverCornerRadius(CGFloat)
    case coverHeight(CGFloat)
    case titleViewMargin(CGFloat)
    case titleViewFont(UIFont)
    case titleViewBigScale(CGFloat)
    case normalTitleColor(UIColor)
    case selectedTitleColor(UIColor)
    case segmentHeight(CGFloat)
    case imagePosition(TitleImagePosition?)
    case normalImgColor(UIColor)
    case selectedImgColor(UIColor)
}
