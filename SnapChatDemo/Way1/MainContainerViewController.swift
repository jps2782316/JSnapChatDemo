//
//  MainViewController.swift
//  SnapChatDemo
//
//  Created by jps on 2019/11/5.
//  Copyright © 2019 jps. All rights reserved.
//

import UIKit

/*
 Swift - 侧滑菜单的实现（样例2：仿QQ，菜单带缩放效果）
 https://www.hangge.com/blog/cache/detail_1035.html
 */


let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class MainContainerViewController: UIViewController {
    
    
    var scrollView: UIScrollView!
    
    let mainVC = MainViewController()
    let leftVC = LeftViewController()
    let rightVC = RightViewController()
    
    ///遮罩层
    var maskView: UIView!
    
    
    
    let pageCount: Int = 3
    
    
    ///当前显示页面
    var currentPage: CurrentPage = .main {
        didSet {
            vcLifeCycle()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vcLifeCycle()
    }
    
    
    //MARK:  ------------  UI  ------------

    
    func setUI() {
        self.view.backgroundColor = .white
        
        maskView = UIView()
        maskView.frame = self.view.bounds
        maskView.backgroundColor = .black
        maskView.isUserInteractionEnabled = false
        self.view.addSubview(maskView)
        maskView.alpha = 0
        
        //scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView = JScrollView(frame: UIScreen.main.bounds)
        scrollView.contentSize = CGSize(width: kScreenWidth * CGFloat(pageCount), height: kScreenHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.setContentOffset(CGPoint(x: kScreenWidth, y: 0), animated: false)
        self.view.addSubview(scrollView)
        
        
        self.addChild(mainVC)
        //插到scrollView后面，不然挡住scrollView的滑动
        self.view.insertSubview(mainVC.view, belowSubview: maskView)
        mainVC.view.frame = self.view.bounds
        
        self.addChild(leftVC)
        scrollView.addSubview(leftVC.view)
        leftVC.view.frame = self.view.bounds
        
        self.addChild(rightVC)
        scrollView.addSubview(rightVC.view)
        rightVC.view.frame = CGRect(x: 2*kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight)
    }
    
    
    
    //MARK:  ------------  Other  ------------
    
    /// 根据偏移量, 改变遮罩层颜色
    private func updateMaskColor(offsetX: CGFloat) {
        //是否向左边划
        let isToLeft = offsetX < 0 ? true : false
        
        //绝对值
        let offset_x = CGFloat(fabsf(Float(offsetX)))
        //偏移转为相应的透明度
        let alpha = offset_x / kScreenWidth
        
        maskView.alpha = alpha
        
//        if isToLeftVC {
//            maskView.alpha = alpha
//        }
    }
    
    
    ///根据偏移，标记当前显示的是那一页
    private func updateCurrentPage(offset: CGPoint) {
        let currentIndex = Int(offset.x / kScreenWidth)
        switch currentIndex {
        case 0:
            currentPage = .left
            
        case 1:
            currentPage = .main
            
        case 2:
            currentPage = .right
            
        default:
            break
        }
        
        print("currentIdx:\(currentIndex), currentPage:\(currentPage)")
    }
    
    
    ///显示主页
    func showMainPage() {
        scrollView.setContentOffset(CGPoint(x: kScreenWidth, y: 0), animated: true)
        
        //currentPage = .main
    }
    
    
    ///滑动到左边页
    func showLeftPage() {
        var animated = false
        if currentPage == .main {
            animated = true
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        
        //currentPage = .left
    }
    
    ///滑动到右边页
    func showRightPage() {
        var animated = false
        if currentPage == .main {
            animated = true
        }
        scrollView.setContentOffset(CGPoint(x: kScreenWidth * 2, y: 0), animated: animated)
        
        //currentPage = .right
    }
    
    
    ///调用一下各自的生命周期方法，以便显示某一个页面的时候，重新刷新数据
    private func vcLifeCycle() {
        /*switch currentPage {
        case .left:
            leftPageVC.yl_viewDidAppear()
            
        case .right:
            rightPageVC.yl_viewDidAppear()
            
        case .main:
            self..yl_viewDidAppear()
            
        }*/
        
    }
    
    
}



extension MainContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //偏移量（相对于中间vc而言）
        let offsetX = scrollView.contentOffset.x - kScreenWidth
        print("offsetX: \(offsetX)")
        
        //遮罩层颜色变化
        updateMaskColor(offsetX: offsetX)
        
        //底部按钮变化
        
        //导航栏变化
        
    }
    
    
    //结束减速的时候调用 (拖动的时候才会走)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("结束减速..")
        let offset = scrollView.contentOffset
        updateCurrentPage(offset: offset)
    }
    
    
    //设置scrollview动画，动画结束后调用
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("动画结束..")
        let offset = scrollView.contentOffset
        updateCurrentPage(offset: offset)
    }
    
    
    
}


extension MainContainerViewController {
    
    enum CurrentPage {
        case left
        case main
        case right
    }
    
    
    
    
}
