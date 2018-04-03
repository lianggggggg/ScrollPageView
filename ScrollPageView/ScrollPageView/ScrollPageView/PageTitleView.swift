//
//  PageTitleView.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/28.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

class PageTitleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var imagePosition:TitleImagePosition? = nil  //图片的位置
    
    
    var currentTransformSx:CGFloat = 1.0 //放大比例
    {
        didSet{
            self.transform = CGAffineTransform.init(scaleX: currentTransformSx, y: currentTransformSx)
        }
    }
    var text:String = ""{
        didSet{
            self.label.text = text
            let bounds = (text as NSString).boundingRect(with: CGSize.init(width: Double(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.label.font], context: nil)
            self.titleSize = bounds.size
        }
    }
    
    var textColor:UIColor = .black
    {
        didSet{
            self.label.textColor = textColor
        }
    }
    
    var font:UIFont = UIFont.systemFont(ofSize: 14)
    {
        didSet{
            self.label.font = font
        }
    }
    
    var isSelected:Bool = false
    {
        didSet{
            if self.selectedImage != nil {
                self.imageView.isHighlighted = isSelected
            }else{
                self.imageView.image = self.normalImage?.withRenderingMode(.alwaysTemplate)
                if isSelected {
                    self.imageView.tintColor = selectedImgColor
                }else{
                    self.imageView.tintColor = normalImgColor
                }
            }
        }
    }
    

    //点击改变图片的
    var normalImage:UIImage? = nil //默认图片
    {
        didSet{
            guard (normalImage != nil) else {
                return
            }
            self.imageWidth = normalImage!.size.width
            self.imageHeight = normalImage!.size.height
            self.imageView.image = normalImage
        }
    }
    var selectedImage:UIImage? = nil  //选中图片
    {
        didSet{
            self.imageView.highlightedImage = selectedImage
        }
    }
    
    var normalImgColor:UIColor = .blue //默认时颜色
    var selectedImgColor:UIColor = .red //点击后颜色
    
    
    
    fileprivate var titleSize:CGSize = CGSize.zero
    fileprivate var imageWidth:CGFloat = 0
    fileprivate var imageHeight:CGFloat = 0
    fileprivate var isShowImage:Bool = false
    
    lazy var contentView = {() -> UIView in
        let view = UIView()
        return view
    }()
    
    lazy var imageView = {() -> UIImageView in
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy var label = {() -> UILabel in
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = self.font
        lbl.textColor = self.textColor
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    fileprivate func config(){
        self.currentTransformSx = 1.0
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.isShowImage = false
        self.addSubview(label)
    }
    
}

extension PageTitleView{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isShowImage {
            self.label.frame = self.bounds
        }
    }
    
    
    func pageTitleViewWidth() -> CGFloat{
        
        var _width:CGFloat = 0
        
        guard (self.imagePosition != nil) else {
            return self.titleSize.width > 44 ? self.titleSize.width : 44
        }
        switch self.imagePosition! {
        case .left,.right:
            _width = self.imageWidth + titleSize.width
        case .center:
            _width = self.imageWidth
        default:
            _width = self.titleSize.width
        }

        return _width > 44 ? _width : 44
    }
    
    //有图后调整界面
    func adjustSubviewFrame(){
        
        self.isShowImage = true
        
        var contentViewFrame:CGRect = self.bounds
        contentViewFrame.size.width = pageTitleViewWidth()
        contentViewFrame.origin.x = (self.width - contentViewFrame.size.width)/2.0
        self.contentView.frame = contentViewFrame
        self.label.frame = self.contentView.bounds
        
        self.addSubview(self.contentView)
        self.label.removeFromSuperview()
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.imageView)
        
        guard self.imagePosition != nil else {
            return
        }
        
        switch self.imagePosition! {
        case .top:
            var newContentViewFrame:CGRect = self.contentView.frame
            newContentViewFrame.size.height = self.imageHeight + self.titleSize.height
            newContentViewFrame.origin.y = (self.frame.size.height - newContentViewFrame.size.height)/2
            self.contentView.frame = newContentViewFrame
            
            self.imageView.frame = CGRect.init(x: 0, y: 0, width: imageWidth, height: imageHeight)
            var center = self.imageView.center
            center.x = self.label.center.x
            self.imageView.center = center
            
            let labelHeight = self.contentView.frame.size.height - imageHeight
            var labelFrame = self.label.frame
            labelFrame.origin.y = self.imageHeight
            labelFrame.size.height = labelHeight
            self.label.frame = labelFrame
        case .left:
            var newLabelFrame = self.label.frame
            newLabelFrame.origin.x = imageWidth
            newLabelFrame.size.width = self.contentView.frame.size.width - imageWidth
            self.label.frame = newLabelFrame
            
            var imageFrame = CGRect.zero
            imageFrame.size.width = imageWidth
            imageFrame.size.height = imageHeight
            imageFrame.origin.y = (self.contentView.frame.size.height - imageFrame.size.height)/2
            self.imageView.frame = imageFrame
            
        case .right:
            var newLabelFrame = self.label.frame
            newLabelFrame.size.width = self.contentView.frame.size.width - imageWidth
            self.label.frame = newLabelFrame
            
            var imageFrame = CGRect.zero
            imageFrame.origin.x = self.label.frame.maxX
            imageFrame.size.height = imageHeight
            imageFrame.size.width = imageWidth
            imageFrame.origin.y = (self.contentView.frame.size.height - imageFrame.size.height)/2
            self.imageView.frame = imageFrame
            
        case .center:
            self.imageView.frame = self.contentView.bounds
            self.label.removeFromSuperview()
            
        default:
            break
        }
        
        
        
    }
    
    
    
}






