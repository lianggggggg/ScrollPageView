//
//  ScrollPageContentView.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/30.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

class ScrollPageContentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    fileprivate var segmentView:ScrollPageSegmentView?  //顶部标签栏
    fileprivate var parentViewController:UIViewController? //总父视图
    var collectionView:ScrollPageCollectionView? //内容物展示
    fileprivate var configuration = ScrollPageViewConfiguration() //配置信息
    {
        didSet{
            
        }
    }
    
    var controllerArray:[UIViewController] = [] //子试图集合

    init(frame: CGRect,segmentView:ScrollPageSegmentView,configuration:ScrollPageViewConfiguration,parentViewController:UIViewController,controllerArray:[UIViewController] = []) {
        self.segmentView = segmentView
        self.parentViewController = parentViewController
        self.controllerArray = controllerArray
        self.configuration = configuration
        super.init(frame: frame)
        configSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configSelf()
    }
    
    fileprivate func configSelf(){
        
        collectionView = ScrollPageCollectionView.init(frame: self.bounds)
        collectionView?.configScrollPageCollection(parentViewController:self.parentViewController!,segmentView: self.segmentView, controllerArray: controllerArray)
        collectionView?.backgroundColor = .clear
        self.collectionView?.bounces = configuration.isContentViewBounces
        self.collectionView?.isScrollEnabled = configuration.isScrollContentView
        self.addSubview(collectionView!)
    }
    
    
}

extension ScrollPageContentView{
    
    
    
    
}

