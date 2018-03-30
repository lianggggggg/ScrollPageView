//
//  UIView+Extension.swift
//  BinTuTu
//
//  Created by MrLiang on 2018/1/5.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var newFrame = frame
            newFrame.origin.x = newValue
            frame = newFrame
        }
    }
    
    var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var newFrame = frame
            newFrame.origin.y = newValue
            frame = newFrame
        }
    }
    
    var width:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var newFrame = frame
            newFrame.size.width = newValue
            frame = newFrame
        }
    }
    
    var height:CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var newFrame = frame
            newFrame.size.height = newValue
            frame = newFrame
        }
    }

    @IBInspectable var borderWidth: CGFloat { //边框高
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor { //边框颜色
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat { //圆角+裁剪
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
            if #available(iOS 11.0, *) {
                self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBInspectable var shadowColor:UIColor { //阴影颜色
        get {
            return UIColor.init(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity:Float{ //阴影透明度
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var shadowRadius:CGFloat{ //阴影圆角
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadowOffset:CGSize{ //阴影偏移量
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
}
