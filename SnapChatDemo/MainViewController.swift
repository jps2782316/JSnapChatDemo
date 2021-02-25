//
//  MainViewController.swift
//  SnapChatDemo
//
//  Created by jps on 2019/11/6.
//  Copyright © 2019 jps. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        
    }
    
    
    
    private func setUI() {
        self.view.backgroundColor = .purple
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "01d78251c696324173f76cdf6029a59106763b03122be-StWW6D_fw658")
        self.view.addSubview(imageView)
        imageView.frame = self.view.bounds
        
        let btn = UIButton()
        btn.setTitle("center-push", for: .normal)
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
