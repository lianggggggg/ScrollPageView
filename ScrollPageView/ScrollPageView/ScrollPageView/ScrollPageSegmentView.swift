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
    
    
    var configuration = ScrollPageViewConfiguration()
    
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

    init(frame: CGRect,titles:[String],configuration:ScrollPageViewConfiguration,titleDidClick:@escaping TitleBtnOnClickBlock) {
        
        self.titles = titles
        
        self.configuration = configuration
        
        self.titleDidClick = {(titleVeiw,index) -> () in
            titleDidClick(titleVeiw,index)
        }
        
        self.currentIndex = 0
        self.oldIndex = 0
        self.currentWidth = frame.size.width
        
        super.init(frame: frame)
        
        self.configSelfColorRGBA()
        
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
    
    fileprivate func configSelfColorRGBA(){
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
    
    
    //附加按钮事件
    @objc func extraBtnOnClick(){
        extraBtnOnClickblock?()
    }
    
    deinit {
        print("ScrollPageSegmentView------销毁")
    }
    
    
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


//MARK: ---> setUpSubView
extension ScrollPageSegmentView{
    fileprivate func setUpSubView(){
        self.addSubview(self.scrollView)
        if configuration.isShowLine {
            self.scrollView.addSubview(scrollLine!)
        }
        
        if configuration.isShowCover {
            self.scrollView.insertSubview(coverLayer!, at: 0)
        }
        
        if configuration.isShowExtraButton {
            self.addSubview(extraBtn!)
        }
        
        setUpTitles()
        
    }

    fileprivate func setUpTitles(){
        
        guard self.titles.count > 0 else {
            return
        }
        
        for (i,item) in titles.enumerated() {
            let titleView = PageTitleView()
            titleView.tag = i
            titleView.font = configuration.titleViewFont
            titleView.textColor = configuration.normalTitleColor
            titleView.imagePosition = configuration.imagePosition
            titleView.text = item
            
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
    fileprivate func adjustUIWhenBtnOnClickWith(animate:Bool, taped:Bool){
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
    
}
//MARK:---> setUpUI
extension ScrollPageSegmentView{
    
    fileprivate func setUpUI(){
        
        guard self.titles.count > 0 && self.titleViews.count > 0 else {
            return
        }
        
        setupScrollViewAndExtraBtn()
        setUpTitleViewsPosition()
        setupScrollLineAndCover()
        
        if self.configuration.isScrollTitleView {
            var titleVeiw = self.titleViews.last
            if titleVeiw != nil{
                self.scrollView.contentSize = CGSize.init(width: titleVeiw!.frame.maxX + contentSizeXOff, height: 0)
            }
        }
        
    }
    
    //设置附加按钮
    fileprivate func setupScrollViewAndExtraBtn(){
        
        let extraBtnW:CGFloat = 44.0
        let extraBtnY:CGFloat = 5.0
        let scrollW = self.extraBtn != nil ? (currentWidth - extraBtnW) : currentWidth
        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: scrollW, height: self.height)
        
        if (self.extraBtn != nil) {
            self.extraBtn?.frame = CGRect.init(x: scrollW, y: extraBtnY, width: extraBtnW, height: self.height - 2*extraBtnY)
        }
        
    }
    //titleView的配置
    fileprivate func setUpTitleViewsPosition(){
        
        var titleX:CGFloat = 0.0
        var titleY:CGFloat = 0.0
        var titleW:CGFloat = 0.0
        var titleH:CGFloat = self.height - self.configuration.scrollLineHeight
        
        if !configuration.isScaleTitleView { //标题不滚动时，平分所以titleview
            titleW = self.scrollView.width/CGFloat(self.titles.count)
            for (i,item) in self.titleViews.enumerated(){
                titleX = CGFloat(i) * titleW
                item.frame = CGRect.init(x: titleX, y: titleY, width: titleW, height: titleH)
                if self.configuration.isShowImage{
                    item.adjustSubviewFrame()
                }
            }
            
        }else{
            
            var lastLableMaxX:CGFloat = self.configuration.titleViewMargin
            var addedMargin:CGFloat = 0.0
            
            if self.configuration.isAutoAdjustTitlesWidth{ //自适应大小
                var allTitlesWidth:CGFloat = self.configuration.titleViewMargin
                for (i,item) in self.titleViews.enumerated(){
                    allTitlesWidth = allTitlesWidth + self.titleWidths[i] + self.configuration.titleViewMargin
                }
                addedMargin = (allTitlesWidth < self.scrollView.width) ? (self.scrollView.width - allTitlesWidth)/CGFloat(self.titleWidths.count) : 0
            }
            
            for (i,item) in self.titleViews.enumerated(){
                titleW = self.titleWidths[i]
                titleX = lastLableMaxX + addedMargin/2
                lastLableMaxX += (titleW + addedMargin + self.configuration.titleViewMargin)
                item.frame = CGRect.init(x: titleX, y: titleY, width: titleW, height: titleH)
                if self.configuration.isShowImage{
                    item.adjustSubviewFrame()
                }
            }
        }
        
        
        guard currentIndex < self.titleViews.count else {
            return
        }
        
        let titleView = self.titleViews[currentIndex]
        titleView.currentTransformSx = 1.0
        //缩放, 设置初始的label的transform
        if self.configuration.isScaleTitleView {
            titleView.currentTransformSx = self.configuration.titleViewBigScale
        }
        
        // 设置初始状态文字的颜色
        titleView.textColor = self.configuration.selectedTitleColor
        if self.configuration.isShowImage {
            titleView.isSelected = true
        }
        
        
    }
    //滚动条/遮罩层的配置
    fileprivate func setupScrollLineAndCover(){
        
        guard self.titleViews.count > 0 else {
            return
        }
        
        let firstTitleView = self.titleViews.first!
        var coverX:CGFloat = firstTitleView.x
        var coverW:CGFloat = firstTitleView.width
        var coverH:CGFloat = self.configuration.coverHeight
        var coverY:CGFloat = (self.height - coverH)/2
        
        if (self.scrollLine != nil) {
            if self.configuration.isScaleTitleView{
                self.scrollLine?.frame = CGRect.init(x: coverX, y: self.height - configuration.scrollLineHeight, width: coverW, height: configuration.scrollLineHeight)
            }else{
                
                if self.configuration.isAdjustCoverOrLineWidth{
                    coverW = self.titleWidths[currentIndex] + wGap
                    coverX = (firstTitleView.width - coverW)/2
                }
                
                self.scrollLine?.frame = CGRect.init(x: coverX, y: self.height - configuration.scrollLineHeight, width: coverW, height: configuration.scrollLineHeight)
            }
        }
        
        
        if self.coverLayer != nil {
            if self.configuration.isScrollTitleView{
                self.coverLayer?.frame = CGRect.init(x: coverX - xGap, y: coverY, width: coverW + wGap, height: coverH)
            }else{
                if self.configuration.isAdjustCoverOrLineWidth{
                    coverW = self.titleWidths[currentIndex] + wGap
                    coverX = (firstTitleView.width - coverW)/2
                }
                self.coverLayer?.frame = CGRect.init(x: coverX, y: coverY, width: coverW, height: coverH)
            }
        }
    }
}



//MARK:UIScrollViewDelegate
extension ScrollPageSegmentView:UIScrollViewDelegate{
    
    
    
}

//MARK:对外接口
extension ScrollPageSegmentView{
    
    //切换下标的时候根据progress同步设置UI
    func adjustUIWith(progress:CGFloat,oldIndex:Int,currentIndex:Int){
        
        guard oldIndex >= 0 && oldIndex < self.titles.count && currentIndex >= 0 && currentIndex < self.titles.count else {
            return
        }
        
        self.oldIndex = currentIndex
        
        let oldTitleView = self.titleViews[oldIndex]
        let currentTitleView = self.titleViews[currentIndex]

        var xDistance = currentTitleView.x - oldTitleView.x
        var wDistance = currentTitleView.width - oldTitleView.width
        
        if self.scrollLine != nil {
            
            if self.configuration.isScrollTitleView{
                self.scrollLine?.x = oldTitleView.x + xDistance*progress
                self.scrollLine?.width = oldTitleView.width + wDistance*progress
            }else{
                if self.configuration.isAdjustCoverOrLineWidth{
                    
                    let oldScrollLineW = self.titleWidths[oldIndex] + wGap
                    let currentScrollLineW = self.titleWidths[currentIndex] + wGap
                    wDistance = currentScrollLineW - oldScrollLineW
                    
                    let oldScrollLineX = oldTitleView.x + (oldTitleView.width - oldScrollLineW)/2
                    let currentScrollLineX = currentTitleView.x + (currentTitleView.width - currentScrollLineW)/2
                    xDistance = currentScrollLineX - oldScrollLineX
                    
                    self.scrollLine?.x = oldScrollLineX + xDistance*progress
                    self.scrollLine?.width = oldScrollLineW + wDistance*progress
                }else{
                    self.scrollLine?.x = oldTitleView.x + xDistance*progress
                    self.scrollLine?.width = oldTitleView.width + wDistance*progress
                }
            }
        }
        
        if self.coverLayer != nil {
            
            if self.configuration.isScrollTitleView{
                self.coverLayer?.x = oldTitleView.x + xDistance*progress - xGap
                self.coverLayer?.width = oldTitleView.width + wDistance*progress + wGap
            }else{
                if self.configuration.isAdjustCoverOrLineWidth{
                    
                    let oldCoverW = self.titleWidths[oldIndex] + wGap
                    let currentCoverW = self.titleWidths[currentIndex] + wGap
                    wDistance = currentCoverW - oldCoverW
                    
                    let oldCoverX = oldTitleView.x + (oldTitleView.width - oldCoverW)/2
                    let currentCoverX = currentTitleView.x + (currentTitleView.width - currentCoverW)/2
                    xDistance = currentCoverX - oldCoverX
                    
                    self.coverLayer?.x = oldCoverX + xDistance*progress
                    self.coverLayer?.width = oldCoverW + wDistance*progress
                }else{
                    self.coverLayer?.x = oldTitleView.x + xDistance*progress
                    self.coverLayer?.width = oldTitleView.width + wDistance*progress
                }
            }
        }
        
        //颜色渐变
        if self.configuration.isGradualChangeTitleColor {
            oldTitleView.textColor = UIColor.init(red: selectedColorRGBA[0] + deltaRGBA[0]*progress, green: selectedColorRGBA[1] + deltaRGBA[1]*progress, blue: selectedColorRGBA[2] + deltaRGBA[2]*progress, alpha: selectedColorRGBA[3] + deltaRGBA[3]*progress)
            currentTitleView.textColor = UIColor.init(red: normalColorRGBA[0] - deltaRGBA[0]*progress, green: normalColorRGBA[1] - deltaRGBA[1]*progress, blue: normalColorRGBA[2] - deltaRGBA[2]*progress, alpha: normalColorRGBA[3] - deltaRGBA[3]*progress)
        }
        
        guard self.configuration.isScrollTitleView else {
            return
        }
        
        let deltaScale = self.configuration.titleViewBigScale - 1.0
        oldTitleView.currentTransformSx = self.configuration.titleViewBigScale - deltaScale*progress
        currentTitleView.currentTransformSx = 1.0 + deltaScale*progress
   
    }
    
    
    //让选中的标题居中
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
            
            let titleView = self.titleViews[index]
            var offSetX = titleView.center.x - currentWidth/2
            if offSetX < 0{
                offSetX = 0
            }
            
            let extraBtnW:CGFloat = (self.extraBtn != nil) ? self.extraBtn!.width : 0.0
            var maxOffSetX = self.scrollView.contentSize.width - (currentWidth - extraBtnW)
            if maxOffSetX < 0{
                maxOffSetX = 0
            }
            
            if offSetX > maxOffSetX{
                offSetX = maxOffSetX
            }
            
            
            
            self.scrollView.setContentOffset(CGPoint.init(x: offSetX, y: 0), animated: true)
        }
    }

    //设置选中的下标
    func setSelected(index:Int,animated:Bool){
        
        guard index >= 0 && index < self.titles.count else {
            return
        }
        self.currentIndex = index
        self.adjustUIWhenBtnOnClickWith(animate: animated, taped: false)
    }
    
    //重新刷新标题的内容
    func reloadTitlesWithNew(titles:[String]){
        self.scrollView.subviews.forEach({$0.removeFromSuperview()}) //删除所有的子控件
        
        currentIndex = 0
        oldIndex = 0
        self.titleViews = []
        self.titleWidths = []
        self.titles = titles
        
        guard titles.count > 0 else {
            return
        }
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        setUpSubView()
        setUpUI()
        setSelected(index: 0, animated: true)
        
    }
    
    
}


