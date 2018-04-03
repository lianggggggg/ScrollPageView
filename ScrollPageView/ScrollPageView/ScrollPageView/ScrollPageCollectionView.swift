//
//  ScrollPageCollectionView.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/4/2.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

class ScrollPageCollectionView: UICollectionView {
    
    fileprivate var parentViewController:UIViewController? //总父视图
    fileprivate var segmentView:ScrollPageSegmentView?  //顶部标签栏
    fileprivate var controllerArray:[UIViewController] = [] //数据源
    
    fileprivate var currentChildVC:UIViewController?
    
    fileprivate var forbidTouchToAdjustPosition:Bool = false //当这个属性设置为 true 的时候 就不用处理 scrollView滚动的计算
    
    fileprivate var scrollOverOnePage:Bool = false  //滚动超过页面(直接设置contentOffSet导致)
    
    fileprivate var currentIndex:Int = 0
    {
        didSet{
            
            guard segmentView != nil else {
                return
            }
            if segmentView!.configuration.isAdjustTitleWhenBeginDrag {
                self.adjustSegmentTitleOffsetTo(currentIndex: currentIndex)
            }
        }
    }
    fileprivate var oldIndex:Int = -1
    
    fileprivate var oldOffSet:CGFloat = 0.0
    
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right:0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = frame.size
        layout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: layout)
        configSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right:0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = bounds.size
        layout.scrollDirection = .horizontal
        self.setCollectionViewLayout(layout, animated: true)
        configSelf()
    }
    
    fileprivate func configSelf(){

        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "iden")
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isDirectionalLockEnabled = true
        self.isPagingEnabled = true
        self.delegate = self
        self.dataSource = self
    }
    
    //配置ScrollPageCollection
    func configScrollPageCollection(parentViewController:UIViewController,segmentView:ScrollPageSegmentView?,controllerArray:[UIViewController] = []){
        self.parentViewController = parentViewController
        self.segmentView = segmentView
        self.controllerArray = controllerArray
        
        currentIndex = 0
        oldIndex = -1
        oldOffSet = 0.0
    }
    
    
}

//对外接口
extension ScrollPageCollectionView{
    
    //滑动到指定位置
    func setContentOffSet(offSet:CGPoint,animation:Bool){
        
        self.forbidTouchToAdjustPosition = true
        
        let currentIndex = Int(offSet.y/UIScreen.main.bounds.width)
        
        oldIndex = currentIndex
        self.currentIndex = currentIndex
        
        let page = labs(self.currentIndex - oldIndex)
        
        if page > 1 {
            self.scrollOverOnePage = true
        }
        self.setContentOffset(offSet, animated: animation)
 
    }
    //刷新
    func reload(){
       
        
        
    }
    
}

extension ScrollPageCollectionView:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.forbidTouchToAdjustPosition == true || scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width {
            return
        }
        
        let tempProgress = scrollView.contentOffset.x / UIScreen.main.bounds.width
        let tempIndex = Int(tempProgress)
        
        var progress = tempProgress - CGFloat(tempIndex)
        let deltaX = scrollView.contentOffset.x - oldOffSet
        
        if deltaX > 0 {
            currentIndex = tempIndex + 1
            oldIndex = tempIndex
        }else if deltaX < 0{
            progress = 1 - progress
            oldIndex = tempIndex + 1
            currentIndex = tempIndex
        }else{
            return
        }
        
        contentViewDidMove(fromIndex: oldIndex, toIndex: currentIndex, progress: progress)
    }
    
    //滚动减速完成时再更新title的位置
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let tempProgress = scrollView.contentOffset.x / UIScreen.main.bounds.width
        
        contentViewDidMove(fromIndex: Int(tempProgress), toIndex: Int(tempProgress), progress: 1.0)
        adjustSegmentTitleOffsetTo(currentIndex: Int(tempProgress))
        
//        currentIndex = Int(tempProgress)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        oldOffSet = scrollView.contentOffset.x
        forbidTouchToAdjustPosition = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let nav = self.parentViewController?.parent
        if nav is UINavigationController {
            (nav as! UINavigationController).interactivePopGestureRecognizer?.isEnabled = true
        }
        
    }
}


//MARK:UICollectionViewDelegate
extension ScrollPageCollectionView:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllerArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: "iden", for: indexPath)
        cell.contentView.subviews.forEach({$0.removeFromSuperview()})
        setupChildVcFor(cell: cell, At: indexPath)
        
        return cell
    }
    
    //将要加载某个Item时调用的方法
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay-----\(indexPath)")
    }
    //已经展示某个Item时触发的方法
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("didEndDisplaying-----\(indexPath)")
    }
    
}

extension ScrollPageCollectionView{
    
    fileprivate func setupChildVcFor(cell:UICollectionViewCell,At indexPath:IndexPath){
        
        self.currentChildVC = self.controllerArray[indexPath.row]
        
        guard !(self.currentChildVC is UINavigationController) else {
            return
        }
        
        self.parentViewController?.addChildViewController(self.currentChildVC!)
        
        self.currentChildVC?.view.frame = cell.contentView.bounds
        
        cell.contentView.addSubview((self.currentChildVC?.view)!)
        
    }
    
    fileprivate func adjustSegmentTitleOffsetTo(currentIndex:Int){
        if self.segmentView != nil && self.forbidTouchToAdjustPosition == false {

            self.segmentView?.adjustTitleOffSetToCurrent(index: currentIndex)
        }
    }
    
    fileprivate func contentViewDidMove(fromIndex:Int,toIndex:Int,progress:CGFloat){
        if self.segmentView != nil {
            self.segmentView?.adjustUIWith(progress: progress, oldIndex: fromIndex, currentIndex: toIndex)
        }
    }
    
}

