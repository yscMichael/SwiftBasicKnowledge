//
//  LoginController.swift
//  swiftProject
//
//  Created by yangshichuan on 2019/12/4.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class LoginController: UIViewController {
    //MARK:属性
    //跳转按钮
    private lazy var jumpButton:UIButton = UIButton()
    
    @IBOutlet weak var getCodeButton: UIButton!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("登陆界面")
        //初始化数据
        initData()
        //初始化View
        initViews()
        
    }
    
    //MARK:点击获取验证码接口
    @IBAction func clickGetCodeButton(_ sender: UIButton) {
        clickGetCodeButtonEvent(button: sender);
    }
    
    //MARk:点击登陆接口
    @IBAction func clickLoginButton(_ sender: UIButton) {
        clickLoginButtonEvent(button: sender);
    }
    
    //MARK:跳转界面
    @IBAction func clickJumpButton(_ sender: UIButton) {
        clickJumpButtonEvent(button: sender);
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
    }
}

//MARK:Event
extension LoginController{
    //MARK:点击获取验证码接口
    func clickGetCodeButtonEvent(button :UIButton) {
        //1、测试封装好的接口
        //参数
        let baseURL = "/api/skyworth-northbound/users/captcha"
        let param = ["phone":"19924535784"]
        SPCSwiftNetWorkmanager.sharedNetworkManager.request(urlString: baseURL, methodType: RequestType.POST, parameters: param, success: { (response) in
            print("返回结果-------")
            print(response)
        }) { (error) in
            print("错误结果")
            print(error)
        }
      
//         //2、普通测试
//         //参数
//         let baseURL = "http://58.251.35.131:80/api/skyworth-northbound/users/captcha"
//         let param = ["phone":"19924535784"]
//         //头部信息
//         let headers: HTTPHeaders = [
//             "Accept": "application/json",
//             "Content-Type":"application/json",
//             "Authorization":"Basic c2t5d29ydGhkaWdpdGFsOnNreXdvcnRoZGlnaXRhbF9zZWNyZXQ="
//         ]
//        //请求
//         Alamofire.request(baseURL, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//             print("请求成功")
//             print(response)
//        }
    }
    //MARK:点击登陆接口
    func clickLoginButtonEvent(button:UIButton) {
        //参数
        let baseURL = "http://58.251.35.131:80/api/skyworth-northbound/users/skyworthdigitallogin"
        let param: [String: String] = ["username":"19924535784",
                                       "password":self.codeTextField.text ?? "",
                                       "grant_type":"password",
                                       "scope":"all",
                                       "type":"account"]
        //头部信息
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json",
            "Authorization":"Basic c2t5d29ydGhkaWdpdGFsOnNreXdvcnRoZGlnaXRhbF9zZWNyZXQ="
        ]
        //请求
        Alamofire.request(baseURL, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("请求成功")
            print(response)
        }
    }

    //MARK:点击跳转按钮
    func clickJumpButtonEvent(button:UIButton){
        print("点击跳转按钮")
        self.navigationController?.pushViewController(HomeListController.init(), animated: true)
    }
    
    //MARK:swift调用OC的网络请求
    func swiftUseOCMethod() {
        //测试获取验证码请求(swift调用OC代码)
        //url
        let getCodeString = "/api/skyworth-northbound/users/captcha"
        //参数
        let param = ["phone":"19924535784"]
        let netTool = SPCNetWorkManager.shared()
        //成功block
        let successBlock = {(result : AnyObject) -> () in
            print("成功回调")
            print(result)
        }
        //失败block
        let failureBlock = {(error : Error?) -> () in
            print("失败回调")
            print(error ?? "失败")
        }
        //正式网络请求
        netTool?.startRequest(withUrl: getCodeString, method: HTTPMethod.post, params: param, withSuccessBlock: successBlock as? (Any?) -> Void, withFailurBlock: failureBlock)
    }
}
