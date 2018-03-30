//
//  ScrollPageView+Extension.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/28.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

extension ScrollPageView{
    
    func configureScrollPageView(options: [ScrollPageViewOption]){
        
        for option in options {
            switch option{
            case let .isShowCover(value):
                configuration.isShowCover = value
            case let .isShowLine(value):
                configuration.isShowLine = value
            case let .isShowImage(value):
                configuration.isShowImage = value
            case let .isShowExtraButton(value):
                configuration.isShowExtraButton = value
            case let .isScaleTitleView(value):
                configuration.isScaleTitleView = value
            case let .isScrollTitleView(value):
                configuration.isScrollTitleView = value
            case let .isSegmentViewBounces(value):
                configuration.isSegmentViewBounces = value
            case let .isContentViewBounces(value):
                configuration.isContentViewBounces = value
            case let .isGradualChangeTitleColor(value):
                configuration.isGradualChangeTitleColor = value
            case let .isScrollContentView(value):
                configuration.isScrollContentView = value
            case let .isAnimatedContentViewWhenTitleClicked(value):
                configuration.isAnimatedContentViewWhenTitleClicked = value
            case let .isAdjustCoverOrLineWidth(value):
                configuration.isAdjustCoverOrLineWidth = value
            case let .isAutoAdjustTitlesWidth(value):
                configuration.isAutoAdjustTitlesWidth = value
            case let .isAdjustTitleWhenBeginDrag(value):
                configuration.isAdjustTitleWhenBeginDrag = value
            case let .extraBtnBackgroundImageName(value):
                configuration.extraBtnBackgroundImageName = value
            case let .scrollLineHeight(value):
                configuration.scrollLineHeight = value
            case let .scrollLineColor(value):
                configuration.scrollLineColor = value
            case let .coverBackgroundColor(value):
                configuration.coverBackgroundColor = value
            case let .coverCornerRadius(value):
                configuration.coverCornerRadius = value
            case let .coverHeight(value):
                configuration.coverHeight = value
            case let .titleViewMargin(value):
                configuration.titleViewMargin = value
            case let .titleViewFont(value):
                configuration.titleViewFont = value
            case let .titleViewBigScale(value):
                configuration.titleViewBigScale = value
            case let .normalTitleColor(value):
                configuration.normalTitleColor = value
            case let .selectedTitleColor(value):
                configuration.selectedTitleColor = value
            case let .segmentHeight(value):
                configuration.segmentHeight = value
            case let .imagePosition(value):
                configuration.imagePosition = value
            case let .animationTime(value):
                configuration.animationTime = value
            }
        }
        
    }
}
