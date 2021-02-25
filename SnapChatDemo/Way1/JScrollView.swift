//
//  JScrollView.swift
//  SnapChatDemo
//
//  Created by jps on 2019/11/6.
//  Copyright © 2019 jps. All rights reserved.
//

import UIKit

class JScrollView: UIScrollView, UIGestureRecognizerDelegate {

    // 重写下面方法,为了让Scrollview可以识别多个手势
    // 此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.state.rawValue != 0 ? true : false
    }
    
}
