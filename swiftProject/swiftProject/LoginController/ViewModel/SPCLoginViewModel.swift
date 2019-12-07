//
//  SPCLoginViewModel.swift
//  swiftProject
//
//  Created by 杨世川 on 2019/12/6.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

import UIKit
import HandyJSON

//获取验证码
let SPCGetVerificationCode = "/api/skyworth-northbound/users/captcha"
//登陆
let SPCLogin = "/api/skyworth-northbound/users/skyworthdigitallogin"
//刷新token
let SPCRefreshToken = "/api/skyworth-northbound/users/refreshToken"

class SPCLoginViewModel: NSObject {

}

extension SPCLoginViewModel{
    //MARK:获取验证码
    func getGetVerificationCode(parameters: [String: String], success: @escaping (_ success: String?) -> (), failure: @escaping (_ error: String?) -> ()) {
        SPCSwiftNetWorkmanager.sharedNetworkManager.request(urlString: SPCGetVerificationCode, methodType: RequestType.POST, parameters: parameters, success: { (response) in
            //1、解析code码
            guard let code = response["code"] else{
                failure("网络请求失败")
                return;
            }
            //2、判断code码是否正常
            guard (code as! Int) == 200 else{
                //取出具体错误
                guard let msg = response["msg"] else{
                    failure("网络请求失败")
                    return
                }
                failure(msg as? String)
                return;
            }
            //3、提示发送成功
            success("验证码发送成功")
        }) { (error) in
            failure("网络请求失败")
        }
    }
    
    //MARK:登陆
    func loginRequest(parameters: [String: String], success: @escaping (_ model: loginModel) -> (), failure: @escaping (_ error: String?) -> ())  {
        SPCSwiftNetWorkmanager.sharedNetworkManager.request(urlString: SPCLogin, methodType: RequestType.POST, parameters: parameters, success: { (response) in
            //1、解析code码
            guard let code = response["code"] else{
                failure("网络请求失败")
                return;
            }
            //2、判断code码
            guard (code as! Int) == 200 else{
                //取出具体错误
                guard let msg = response["msg"] else{
                    failure("网络请求失败")
                    return
                }
                failure(msg as? String)
                return;
            }
            //3、解析data
            guard let data = response["data"] else{
                //提示数据解析失败
                failure("数据解析失败")
                return
            }
            //4、data尝试强转Dictionary
            guard let dataDict = (data as? Dictionary<String, Any>) else{
                failure("数据格式不正确")
                return;
            }
            //5、将dataDict转模型
            guard let loginModel = loginModel.deserialize(from: dataDict) else{
                failure("模型解析失败")
                return;
            }
            //6、成功回调
            success(loginModel)
        }) { (error) in
            failure("网络请求失败")
        }
    }
}
