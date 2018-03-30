//
//  ScrollPageView.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/28.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

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
    
    
    
    //Mark:init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configScrollPageView(parentViewController:UIViewController,viewControllers: [UIViewController],pageMenuOptions: [ScrollPageViewOption]?){
        
        self.parentViewController = parentViewController
        self.controllerArray = viewControllers
        
        if let options = pageMenuOptions {
            configureScrollPageView(options: options)
        }
        
    }
    
    
    
}




