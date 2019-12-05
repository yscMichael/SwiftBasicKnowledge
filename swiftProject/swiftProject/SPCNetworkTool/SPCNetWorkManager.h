//
//  SPCNetWorkManager.h
//  HYBiPad
//
//  Created by 杨世川 on 2018/7/6.
//  Copyright © 2018年 winwayworld. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef NS_ENUM (NSInteger, HTTPMethod){
    HTTPMethodGet,//get请求
    HTTPMethodPost,//post请求
};

@interface SPCNetWorkManager : AFHTTPSessionManager
//token(其它接口-设置请求头)、token有效期是2小时
@property(nonatomic,copy) NSString *access_token;
//为了拿到最新的token、refresh_token有效期是20天
@property(nonatomic,copy) NSString *refresh_token;
//请求
@property(nonatomic,strong) NSMutableURLRequest *spcRequest;

//单例
+ (instancetype)sharedManager;

- (void)sendRequestWithParam:(NSString *)string withURL:(NSString *)url;

//发起业务网络请求
- (void)startRequestWithUrl:(NSString *)url
                     method:(HTTPMethod) method
                     params:(NSDictionary *)params
           withSuccessBlock:(void(^)(id result))success
            withFailurBlock:(void(^)(NSError *error))failure;
@end
