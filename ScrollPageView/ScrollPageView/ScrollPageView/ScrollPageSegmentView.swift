//
//  ScrollPageSegmentView.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/29.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit


typealias TitleBtnOnClickBlock = ((_ titleVeiw:PageTitleView?,_ index:Int) -> ())


class ScrollPageSegmentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var extraBtnOnClickblock:(() -> ())? //附加按钮点击事件
    
    var titles:[String] = [] //标题集合
    
    var titleViews:[PageTitleView] = [] //缓存所有标题label
    var titleWidths:[CGFloat] = []  //缓存计算出来的每个标题的宽度
    
    
    var configuration = ScrollPageViewConfiguration(){
        didSet{
            self.normalColorRGBA = getColorRGBA(color: configuration.normalTitleColor)
            self.selectedColorRGBA = getColorRGBA(color: configuration.selectedTitleColor)
            
            if normalColorRGBA.count > 0 && selectedColorRGBA.count > 0 {
                let deltaR = normalColorRGBA[0] - selectedColorRGBA[0]
                let deltaG = normalColorRGBA[1] - selectedColorRGBA[1]
                let deltaB = normalColorRGBA[2] - selectedColorRGBA[2]
                let deltaA = normalColorRGBA[3] - selectedColorRGBA[3]
                
                self.deltaRGBA = NSArray.init(objects: deltaR,deltaG,deltaB,deltaA) as? [CGFloat] ?? []
            }
            
        }
    }
    
    var titleDidClick:TitleBtnOnClickBlock?
    
    // 用于懒加载计算文字的rgba差值, 用于颜色渐变的时候设置
    var deltaRGBA:[CGFloat] = []
    var selectedColorRGBA:[CGFloat] = []
    var normalColorRGBA:[CGFloat] = []
    
    
    fileprivate var currentWidth:CGFloat = 0
    fileprivate var currentIndex:Int = 0
    fileprivate var oldIndex:Int = 0
    
    let xGap:CGFloat = 5.0
    let wGap:CGFloat = 10.0
    let contentSizeXOff:CGFloat = 20
    
    //滚动条
    lazy var scrollLine = {() -> UIView? in
        guard configuration.isShowLine else {
            return nil
        }
        let line = UIView()
        line.isHidden = false
        line.backgroundColor = configuration.scrollLineColor
        return line
    }()
    
    //遮罩
    lazy var coverLayer = {() -> UIView? in
        
        guard configuration.isShowCover else {
            return nil
        }
        
        let cover = UIView()
        cover.backgroundColor = configuration.coverBackgroundColor
        cover.layer.masksToBounds = true
        cover.layer.cornerRadius = configuration.coverCornerRadius
        return cover
    }()
    
//    var coverLayer = UIView()  //遮罩
//    {
//        didSet{
//            guard configuration.isShowCover else {
//                coverLayer.isHidden = true
//                return
//            }
//            coverLayer.backgroundColor = configuration.coverBackgroundColor
//            coverLayer.layer.masksToBounds = true
//            coverLayer.layer.cornerRadius = configuration.coverCornerRadius
//        }
//    }
    
    //滚动的scrollview
    lazy var scrollView = {() -> UIScrollView in
      
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.scrollsToTop = false
        scroll.bounces = configuration.isSegmentViewBounces
        scroll.isPagingEnabled = false
        scroll.delegate = self
        return scroll
    }()
    //背景
    lazy var backgroundImageView = {() -> UIImageView in
      
        let imageView = UIImageView()
        imageView.frame = self.bounds
        self.insertSubview(imageView, at: 0)
        return imageView
    }()

    
    lazy var extraBtn = {() -> UIButton? in
        guard configuration.isShowExtraButton else {
            return nil
        }
        
        let extra = UIButton()
        
        extra.addTarget(self, action: #selector(extraBtnOnClick), for: .touchUpInside)
        extra.setImage(UIImage.init(named: configuration.extraBtnBackgroundImageName != nil ? configuration.extraBtnBackgroundImageName! : ""), for: .normal)
        extra.backgroundColor = .clear
        return extra
    }()
    
    
//    var extraBtn = UIButton()  //附加的按钮
//    {
//        didSet{
//            guard configuration.isShowExtraButton else {
//                extraBtn.isHidden = true
//                return
//            }
//
//            extraBtn.addTarget(self, action: #selector(extraBtnOnClick), for: .touchUpInside)
//            extraBtn.setImage(UIImage.init(named: configuration.extraBtnBackgroundImageName != nil ? configuration.extraBtnBackgroundImageName! : ""), for: .normal)
//            extraBtn.backgroundColor = .clear
//        }
//    }
    
    
    
    
    init(frame: CGRect,titles:[String],configuration:ScrollPageViewConfiguration,titleDidClick:@escaping TitleBtnOnClickBlock) {
        
        self.titles = titles
        
        self.configuration = configuration
        
        self.titleDidClick = titleDidClick
        
        self.currentIndex = 0
        self.oldIndex = 0
        self.currentWidth = frame.size.width
        
        super.init(frame: frame)
        
        if !configuration.isScrollTitleView {// 不能滚动的时候就不要把缩放和遮盖或者滚动条同时使用, 否则显示效果不好
            configuration.isScrollTitleView = !(configuration.isShowLine || configuration.isShowCover)
        }

        //设置其他控件的frame等
        setUpSubView()
        setUpUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //附加按钮事件
    @objc func extraBtnOnClick(){
        extraBtnOnClickblock?()
    }
    
    deinit {
        print("ScrollPageSegmentView------销毁")
    }
    
}


extension ScrollPageSegmentView{
    func setUpSubView(){
        self.addSubview(self.scrollView)
        if configuration.isShowLine {
            self.addSubview(scrollLine!)
        }
        
        if configuration.isShowCover {
            self.insertSubview(coverLayer!, at: 0)
        }
        
        if configuration.isShowExtraButton {
            self.addSubview(extraBtn!)
        }
        
        setUpTitles()
        
    }
    
    func setUpUI(){
        
    }
    
    
    func setUpTitles(){
        
        guard self.titles.count > 0 else {
            return
        }
        
        for (i,item) in titles.enumerated() {
            let titleView = PageTitleView()
            titleView.tag = i
            titleView.text = item
            titleView.font = configuration.titleViewFont
            titleView.textColor = configuration.normalTitleColor
            titleView.imagePosition = configuration.imagePosition
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(titleViewOnClick(tap:)))
            titleView.addGestureRecognizer(tap)
            
            self.titleWidths.append(titleView.pageTitleViewWidth())
            self.titleViews.append(titleView)
            self.scrollView.addSubview(titleView)
        }
    }
    
    
    //点击标题view
    @objc func titleViewOnClick(tap:UITapGestureRecognizer){
        
        var view = tap.view
        
        guard (view != nil) else {
            return
        }
        
        self.currentIndex = (view as! PageTitleView).tag
        
        adjustUIWhenBtnOnClickWith(animate: true, taped: true)
    }
    
    //点击后动画效果
    func adjustUIWhenBtnOnClickWith(animate:Bool, taped:Bool){
        guard !(currentIndex == oldIndex && taped) else {
            return
        }
        
        let oldTitleView = self.titleViews[oldIndex]
        let currentTitleView = self.titleViews[currentIndex]
        
        let animationTime:CGFloat = animate ? configuration.animationTime : 0.0
        
        
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            
            oldTitleView.textColor = self.configuration.normalTitleColor
            oldTitleView.isSelected = false
            currentTitleView.textColor = self.configuration.selectedTitleColor
            currentTitleView.isSelected = true
            
            if self.configuration.isScaleTitleView{
                oldTitleView.currentTransformSx = 1.0
                currentTitleView.currentTransformSx = self.configuration.titleViewBigScale
            }
            
            if self.scrollLine != nil{
                if self.configuration.isScrollTitleView{
                    self.scrollLine?.x = currentTitleView.x
                    self.scrollLine?.width = currentTitleView.width
                }else{
                    if self.configuration.isAdjustCoverOrLineWidth{
                        let scrollLineW = self.titleWidths[self.currentIndex] + self.wGap
                        let scrollLineX = currentTitleView.x + (currentTitleView.width - scrollLineW)/2
                        self.scrollLine?.x = scrollLineX
                        self.scrollLine?.width = scrollLineW
                    }else{
                        self.scrollLine?.x = currentTitleView.x
                        self.scrollLine?.width = currentTitleView.width
                    }
                }
            }
            
            if self.coverLayer != nil{
                if self.configuration.isScrollTitleView{
                    self.coverLayer?.x = currentTitleView.x - self.xGap
                    self.coverLayer?.width = currentTitleView.width + self.wGap
                }else{
                    if self.configuration.isAdjustCoverOrLineWidth{
                        let coverW = self.titleWidths[self.currentIndex] + self.wGap
                        let coverX = currentTitleView.x + (currentTitleView.width - coverW)/2
                        self.coverLayer?.x = coverX
                        self.coverLayer?.width = coverW
                    }else{
                        self.coverLayer?.x = currentTitleView.x
                        self.coverLayer?.width = currentTitleView.width
                    }
                }
            }
        }) { (finished) in
            self.adjustTitleOffSetToCurrent(index: self.currentIndex)
        }
        
        self.titleDidClick?(currentTitleView,currentIndex)
        
        self.oldIndex = self.currentIndex
        
    }
     // 重置渐变/缩放效果附近其他item的缩放和颜色
    func adjustTitleOffSetToCurrent(index:Int){
        
        self.oldIndex = index
        
        for (i,item) in self.titleViews.enumerated() {
            
            if i != index{
                item.textColor = self.configuration.normalTitleColor
                item.currentTransformSx = 1.0
                item.isSelected = false
            }else{
                item.textColor = self.configuration.selectedTitleColor
                if self.configuration.isScrollTitleView{
                    item.currentTransformSx = self.configuration.titleViewBigScale
                }
                item.isSelected = true
            }
        }
        
        // 需要滚动
        if scrollView.contentSize.width != (self.scrollView.frame.size.width + contentSizeXOff) {
            
            let titleView = self.titleViews[currentIndex]
            var offSetX = titleView.center.x - currentWidth/2
            if offSetX < 0{
                offSetX = 0
            }
            
            let extraBtnW:CGFloat = (self.extraBtn != nil) ? self.extraBtn!.width : 0.0
            var maxOffSetX = self.scrollView.contentSize.width - (currentWidth - extraBtnW)
            
            
            
        }
        
        
    }
    
}

//MARK:UIScrollViewDelegate
extension ScrollPageSegmentView:UIScrollViewDelegate{
    
}


extension ScrollPageSegmentView{
    
    func getColorRGBA(color:UIColor) -> [CGFloat]{
        
        let numOfcomponents = color.cgColor.numberOfComponents
        
        var returnArr:[CGFloat] = []
        
        if numOfcomponents == 4 {
            var components = color.cgColor.components
            
            returnArr = NSArray.init(objects: components![0],components![1],components![2],components![3]) as! [CGFloat]
        }
        
        return returnArr
    }
}


