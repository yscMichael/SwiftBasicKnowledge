//
//  LoginController.swift
//  swiftProject
//
//  Created by yangshichuan on 2019/12/4.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

import UIKit
import SnapKit

class LoginController: UIViewController {
    //MARK:属性
    //跳转按钮
    private lazy var jumpButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("登陆界面")
        //初始化数据
        initData()
        //初始化View
        initViews()
    }
}

//MARK:设置UI界面
extension LoginController{
    //初始化数据
    private func initData(){
        print("打印swift的高宽")
        print(AppWidth)
        print("打印oc信息")
        SPCPerson.eat()
    }
    
    //初始化View
    private func initViews() {
        self.title = "登陆界面";
        self.jumpButton.setTitle("跳转界面", for: UIControl.State.normal)
        self.jumpButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
        self.jumpButton.backgroundColor = UIColor.lightText
        self.jumpButton.addTarget(self, action: #selector(clickJumpButton), for: UIControl.Event.touchUpInside)
        self.view.addSubview(self.jumpButton)

        self.jumpButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalTo(self.view)
        }
    }
}

//MARK:Event
extension LoginController{
    //点击跳转按钮
    @objc func clickJumpButton(sender:UIButton){
        print("点击跳转按钮")
        self.navigationController?.pushViewController(HomeListController.init(), animated: true)
    }
}
