//
//  BottomView.swift
//  SnapChatDemo
//
//  Created by jps on 2019/11/8.
//  Copyright © 2019 jps. All rights reserved.
//

import UIKit
import SnapKit //报错: No such module 'SnapKit', clean一下Xcode(重启Xcode也没用), 再编译就好了


class BottomView: UIView {
    
    let safeBottom = 34
    
    
    
    lazy var contentView = UIView()
    
    var backgroundImageView: UIImageView!
    
    var chatBtn: UIButton!
    
    var discoverBtn: UIButton!
    
    var centerBtn: UIButton!
    var centerDetailBtn: UIButton!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUI()
    }
    
    
    
    
    
    func setUI() {
        
        let bgImageView = UIImageView()
        bgImageView.alpha = 0
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "bg_list_bottom")
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundImageView = bgImageView
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-safeBottom)
        }
        
        //中间大按钮
        let centerBtn = UIButton()
        centerBtn.layer.borderColor = UIColor.purple.cgColor
        centerBtn.layer.borderWidth = 4
        centerBtn.layer.cornerRadius = 40
        contentView.addSubview(centerBtn)
        centerBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        self.centerBtn = centerBtn
        
        //中间小按钮
        let centerDetailBtn = UIButton()
        centerDetailBtn.layer.borderColor = UIColor.purple.cgColor
        centerDetailBtn.layer.borderWidth = 4
        centerDetailBtn.layer.cornerRadius = 5
        contentView.addSubview(centerDetailBtn)
        centerDetailBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 50))
        }
        self.centerDetailBtn = centerDetailBtn
        
        //聊天
        let chatBtn = UIButton()
        chatBtn.setTitle("聊天", for: .normal)
        chatBtn.setTitleColor(.purple, for: .normal)
        chatBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView.addSubview(chatBtn)
        chatBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(centerDetailBtn.snp.leading).offset(-100)
            make.bottom.equalToSuperview()
        }
        self.chatBtn = chatBtn
        
        //发现
        let discoverBtn = UIButton()
        discoverBtn.setTitle("发现", for: .normal)
        discoverBtn.setTitleColor(.purple, for: .normal)
        discoverBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView.addSubview(discoverBtn)
        discoverBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(centerDetailBtn.snp.trailing).offset(100)
            make.bottom.equalToSuperview()
        }
        self.discoverBtn = discoverBtn
        
        
        
        
    }
    
    
    
    func updatePosition(scale: CGFloat, isAnimate: Bool = false) {
        var top = 50 * scale
        if top > 100 {
            top = 100
        }
        centerBtn.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(top)
        }
        self.backgroundImageView.alpha = 1 * scale
        
        if isAnimate {
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded() //按钮位置动画
            }
        }
//        else {
//            UIView.animate(withDuration: 0.25) {
//                self.backgroundImageView.alpha = 1 * scale //透明度
//            }
//        }
    }
    
    
    

}
