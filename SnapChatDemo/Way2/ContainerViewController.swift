//
//  ContainerViewController.swift
//  SnapChatDemo
//
//  Created by jps on 2019/11/6.
//  Copyright © 2019 jps. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    let mainVC = MainViewController()
    let leftVC = LeftViewController()
    let rightVC = RightViewController()
    
    let bottomView = BottomView()
    
    ///遮罩层
    lazy var maskView = UIView()
    
    
   // var currentPage: CurrentPage = .center
    
    var currentIndex: Int = 1 {
        didSet {
            print("当前index: \(currentIndex)")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    

    func setUI() {
        self.view.backgroundColor = .white
        
        //主页
        self.addChild(mainVC)
        mainVC.didMove(toParent: self)
        self.view.addSubview(mainVC.view)
        
        //拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandle(_:)))
        //mainVC.view.addGestureRecognizer(pan)
        self.view.addGestureRecognizer(pan)
        
        //左边页
        self.addChild(leftVC)
        leftVC.didMove(toParent: self)
        self.view.addSubview(leftVC.view)
        leftVC.view.frame = CGRect(x: -kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight)
        
        //右边页
        self.addChild(rightVC)
        rightVC.didMove(toParent: self)
        self.view.addSubview(rightVC.view)
        rightVC.view.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight)
        
        //遮罩
        maskView.backgroundColor = .blue
        maskView.alpha = 0
        maskView.frame = self.view.bounds
        maskView.isUserInteractionEnabled = false
        self.view.insertSubview(maskView, aboveSubview: mainVC.view)
        
        //底部栏
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    
    
    
    //MARK:  ------------  Action  ------------
    
    var targetVC: UIViewController?
    @objc func panHandle(_ pan: UIPanGestureRecognizer) {
        //guard let panView = pan.view else { return }
        
        //location的 x 为触摸控件的中心点
        /*let location = pan.location(in: self.view) //手势的位置
        let x = location.x
        print("locationX: \(x)")*/
        
        
        
        //var centerX = panView.center.x + x2
        //print("offsetX: \(offsetX)")
        
        
        //let targetView = leftVC.view!
        
        switch pan.state {
        case .began:
            //在指定视图的坐标系中平移的速度，以点/秒为单位
            let speed = pan.velocity(in: view)
            // 判断拖动方向
            let isLeftToRight = speed.x > 0
            print("拖动方向isLeftToRight: \(isLeftToRight)")
            
            switch currentIndex {
            case 1:
                targetVC = isLeftToRight ? leftVC : rightVC
                maskView.backgroundColor = targetVC?.view.backgroundColor
                
            case 0:
                targetVC = leftVC
                
            case 2:
                targetVC = rightVC
                
            default:
                break
            }
            
            
        case .changed:
           
            
            
            guard let targetView = targetVC?.view else {
                print("手势移动中，目标试图为nil。。。")
                return
            }
            
            //手势偏移量: 往左为负，往右为正
            let offsetX = pan.translation(in: self.view).x
            
            //目标视图当前的x值
            let targetX = targetView.frame.origin.x
            
            
            
             //误区: 只要手势不抬起，偏移值就会在原来基础上累加，所以不能用下面方法计算坐标。你能用下面计算左标的前提是上一次回调和下一次回调之间的偏移值为两次之间的差。这里很容易转不过弯来。(pan.setTranslation(.zero, in: view)这句话尤为关键)
            
            var maskAlpha: CGFloat = 0
            var x = targetX + offsetX
            if targetVC is LeftViewController {
                maskAlpha = targetView.frame.maxX / kScreenWidth
                if x >= 0 { //划到最左边或者最右边了，则不再划动
                    x = 0
                }
            }else if targetVC is RightViewController {
                maskAlpha = (kScreenWidth - targetView.frame.minX) / kScreenWidth
                if x <= 0 {
                    x = 0
                }
            }
            
            targetView.frame.origin.x = x
            pan.setTranslation(.zero, in: view)
            print("targetX\(targetX) + offsetX: \(offsetX) = \(x)")
            print("alpha: \(maskAlpha)")
            
            //根据偏移，改变遮罩透明度
            maskView.alpha = maskAlpha
            
            //底部栏变化
            bottomView.updatePosition(scale: maskAlpha)
            
        case .ended:
            //根据页面滑动是否过半，判断后面是自动展开还是收缩
            //let isMoreHalf = offsetX >= kScreenWidth / 2.0
            
            guard let targetVC = targetVC else {
                print("手势结束，目标试图为nil。。。")
                return
            }
            
            var finalX: CGFloat = 0
            var finalAlpha: CGFloat = 0
            
            var isMoreHalf: Bool = false
            if targetVC is LeftViewController {
                isMoreHalf = leftVC.view.frame.maxX >= kScreenWidth / 2.0
                finalX = isMoreHalf ? 0 : -kScreenWidth
                finalAlpha = isMoreHalf ? 1 : 0
                if isMoreHalf {
                    currentIndex = 0
                }else {
                    currentIndex = 1
                }
            }
            else if targetVC is RightViewController {
                isMoreHalf = rightVC.view.frame.minX <= kScreenWidth / 2.0
                finalX = isMoreHalf ? 0 : kScreenWidth
                finalAlpha = isMoreHalf ? 1 : 0
                if isMoreHalf {
                    currentIndex = 2
                }else {
                    currentIndex = 1
                }
            }
            
            animated(targetVC: targetVC, finalX: finalX, finalMaskAlpha: finalAlpha)
            
            
            self.targetVC = nil
            
        default:
            break
            
        }
    }
    
    
    
    private func animated(targetVC: UIViewController, finalX: CGFloat, finalMaskAlpha: CGFloat) {
        self.bottomView.updatePosition(scale: finalMaskAlpha, isAnimate: true)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            targetVC.view.frame.origin.x = finalX
            self.maskView.alpha = finalMaskAlpha
        }) { (finished) in
            
        }
    }
    
    
    
    

}


extension ContainerViewController {
    
    ///当前位置
    enum CurrentPage {
        case left
        case center
        case right
    }
    
}
