//
//  loginModel.swift
//  swiftProject
//
//  Created by 杨世川 on 2019/12/6.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

import UIKit
import HandyJSON

class loginModel: HandyJSON {
    var access_token: String?
    var account: Int64?
    var open_id: String?
    var refresh_token: String?
    var user_id: String?
    var user_name: Int64?
    required init() {}
}
