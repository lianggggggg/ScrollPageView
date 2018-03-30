//
//  ScrollPageViewDelegate.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/28.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

@objc protocol ScrollPageViewChildVCDelegate {
    @objc optional func childVCWillAppear(For index:Int)
    @objc optional func childVCDidAppear(For Index:Int)
    @objc optional func childVCWillDisappear(For Index:Int)
    @objc optional func childVCDidDisappear(For Index:Int)
    @objc optional func childVCDidLoad(For Index:Int)
}

@objc protocol ScrollPageViewDelegate{
    func numberOfChileVC() -> Int
}
