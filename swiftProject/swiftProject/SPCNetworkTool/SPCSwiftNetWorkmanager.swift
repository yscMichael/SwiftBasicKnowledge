//
//  SPCSwiftNetWorkmanager.swift
//  swiftProject
//
//  Created by 杨世川 on 2019/12/6.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

// 定义枚举类型
enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

let BaseUrl = "http://58.251.35.131:80"

class SPCSwiftNetWorkmanager: NSObject {
    //MARK:属性
    //token(其它接口-设置请求头)、token有效期是2小时
    var access_token: String?
    //为了拿到最新的token、refresh_token有效期是20天
    var refresh_token: String?
    //网络请求
    var alamofire: SessionManager?

    //MARK:单例(let是线程安全的)
    static let sharedNetworkManager: SPCSwiftNetWorkmanager = {
       let share = SPCSwiftNetWorkmanager()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30//时间超时
        share.alamofire = Alamofire.SessionManager(configuration: configuration)
       return share
    }()
}

extension SPCSwiftNetWorkmanager{
    //MARK:请求方法
    func request(urlString: String, methodType: RequestType, parameters: [String: String], success: @escaping (_ result: Dictionary<String, Any>) -> (), failure: @escaping (_ error: String?) -> ()) -> () {
        switch methodType {
        case .GET:
            sendGetRequest(urlString: urlString, parameters: parameters, success: success, failure: failure)
            break;
        case .POST:
            sendPostRequest(urlString: urlString, parameters: parameters, success: success, failure: failure)
            break;
        default:
            break
        }
    }

    //MARK:GET方法(暂时没有用到)
    private func sendGetRequest(urlString: String, parameters: [String: String], success: @escaping (_ result: Dictionary<String, Any>) -> (), failure: @escaping (_ error: String?) -> ()) {
        
    }
    
    //MARK:POST方法
    private func sendPostRequest(urlString: String, parameters: [String: String], success: @escaping (_ result: Dictionary<String, Any>) -> (), failure: @escaping (_ error: String?) -> ()) {
        //1、请求头
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json",
            "Authorization":"Basic c2t5d29ydGhkaWdpdGFsOnNreXdvcnRoZGlnaXRhbF9zZWNyZXQ="
        ]
        //除了验证码/登陆接口、其它接口要加上Blade-Auth
        if !urlString.contains("/users/captcha") && !urlString.contains("/users/skyworthdigitallogin") {
            let bladeAuth = "bearer " + (self.access_token ?? "")
            headers["Blade-Auth"] = bladeAuth
            print("当前不是登陆/验证码接口")
        }else{
            print("当前是登陆/验证码接口")
        }
        //2、网络请求
        let requestString = BaseUrl + urlString
        self.alamofire?.request(requestString, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("返回结果-------")
            print(response)
            if response.result.isSuccess {//网络请求成功
                //判断是否为空
                guard let value = response.result.value else{
                    failure("网络请求失败")
                    return
                }
                //数据传递过去
                success(value as! Dictionary<String, Any>)
            }else{//网络请求失败
                failure("网络请求失败")
            }
        }
    }
}
