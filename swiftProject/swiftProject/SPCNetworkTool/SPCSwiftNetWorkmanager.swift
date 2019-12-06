//
//  SPCSwiftNetWorkmanager.swift
//  swiftProject
//
//  Created by 杨世川 on 2019/12/6.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

import UIKit
import Alamofire

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
    func request(urlString: String, methodType: RequestType, parameters: [String: String], success: @escaping (_ result: [String : Any]?) -> (), failure: @escaping (_ error: String?) -> ()) -> () {
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
    func sendGetRequest(urlString: String, parameters: [String: String], success: @escaping (_ result: [String : Any]?) -> (), failure: @escaping (_ error: String?) -> ()) {
        
    }
    
    //MARK:POST方法
    func sendPostRequest(urlString: String, parameters: [String: String], success: @escaping (_ result: [String : Any]?) -> (), failure: @escaping (_ error: String?) -> ()) {
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
            print("网络请求")
            //1、判断返回结果是否为nil、不为nil就强制解包为字典
            guard let value = response.result.value else{
                failure("数据请求失败")
                return
            }
            let dictionary = value as! [String: Any]
            print(dictionary)
            //2、判断code是否存在、存在就强制解包
            guard let code = dictionary["code"] else{
                failure("数据请求失败")
                return
            }
            let codeString = code as! NSNumber
            //3、判断code是否是200
            guard codeString == 200 else{
                failure("数据请求失败")
                return
            }
            //4、code码正常、返回强制解包的数据
            success(dictionary)
        }
    }
}
