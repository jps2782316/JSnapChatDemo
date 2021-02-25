//
//  LeftViewController.swift
//  SnapChatDemo
//
//  Created by jps on 2019/11/5.
//  Copyright © 2019 jps. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    

    private func setUI() {
        self.view.backgroundColor = .red
        
        let btn = UIButton()
        btn.setTitle("left-push", for: .normal)
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.center = self.view.center
        btn.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
    }
    
    
    @objc func btnClick(_ sender: UIButton) {
        let classStr = NSStringFromClass(self.classForCoder)
        print("\(classStr) 点击事件。。。")
        
        let vc = TestViewController()
        vc.title = classStr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
