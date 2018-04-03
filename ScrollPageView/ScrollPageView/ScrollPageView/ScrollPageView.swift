 //
//  ScrollPageView.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/28.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

 class TitleModel: NSObject {
    var title:String = ""
    var image:String? = nil
    override init() {
        
    }
 }
 
 
class ScrollPageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    //MARK:configuration
    var configuration = ScrollPageViewConfiguration()
    
    var parentViewController:UIViewController? = nil //父视图
    var controllerArray:[UIViewController] = [] //子试图集合
    
    var segmentView:ScrollPageSegmentView? //顶部标签view
    var contentView:ScrollPageContentView? //内容物view
    
    fileprivate var titleModels:[TitleModel] = []
    
    var extraBtnOnClickblock:(() -> ())?  //附加按钮的回调
    
    //Mark:init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configScrollPageView(parentViewController:UIViewController,viewControllers: [UIViewController],titleModels:[TitleModel],pageMenuOptions: [ScrollPageViewOption]?){
        
        self.parentViewController = parentViewController
        self.controllerArray = viewControllers
        
        self.titleModels = titleModels
        
        if let options = pageMenuOptions {
            configureScrollPageView(options: options)
        }
        
        setUpUI()
        
    }
    
    
    fileprivate func setUpUI(){

        self.segmentView = ScrollPageSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: configuration.segmentHeight), titles: self.titleModels, configuration: configuration, titleDidClick: { (titleView, index) in
            self.contentView?.collectionView?.setContentOffSet(offSet: CGPoint.init(x: CGFloat(index)*UIScreen.main.bounds.width, y: 0), animation: true)
        })
        
        self.segmentView?.extraBtnOnClickblock = {() -> () in
            self.extraBtnOnClickblock?()
        }

        self.addSubview(self.segmentView!)
        
        self.contentView = ScrollPageContentView.init(frame: CGRect.init(x: 0, y: self.segmentView!.frame.maxY, width: self.width, height: self.height - self.segmentView!.frame.maxY), segmentView: self.segmentView!, configuration: configuration, parentViewController: parentViewController!,controllerArray:controllerArray)
        self.addSubview(contentView!)
                
    }
    
    
    
}




