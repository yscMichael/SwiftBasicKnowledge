//
//  SPCNetWorkManager.m
//  HYBiPad
//
//  Created by 杨世川 on 2018/7/6.
//  Copyright © 2018年 winwayworld. All rights reserved.
//

#import "SPCNetWorkManager.h"
//网络请求超时时间
static float SPCTimeoutInterval = 30.0;

@interface SPCNetWorkManager ()

@end

@implementation SPCNetWorkManager
#pragma mark - 单例
+ (instancetype)sharedManager
{
    static SPCNetWorkManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:SPCBaseUrl]];
    });
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        //设置超时时间
        self.requestSerializer.timeoutInterval = SPCTimeoutInterval;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        //设置缓存策略(不使用缓存)
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //设置请求格式
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self.requestSerializer setValue:@"Basic c2t5d29ydGhkaWdpdGFsOnNreXdvcnRoZGlnaXRhbF9zZWNyZXQ=" forHTTPHeaderField:@"Authorization"];
        //设置返回格式
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
        //设置安全策略
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

#pragma mark - 发起网络请求
- (void)startRequestWithUrl:(NSString *)url
          method:(HTTPMethod) method
          params:(NSDictionary *)params
withSuccessBlock:(void(^)(NSDictionary *result))success
 withFailurBlock:(void(^)(NSError *error))failure{
    //1、网络请求request
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",self.baseURL,url];
    self.spcRequest = [self dealURLRequestWithUrl:requestURL method:method];
    //2、处理请求参数(判断参数是否为nil)
    //参数不为nil，直接存在body中；参数为nil，暂时不处理
    if (params) {
        //转换为json字符串
        NSString *jsonString = [self dealParamToStringWithDict:params];
        //将对象设置到requestbody中<主要操作>
        [self.spcRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //3、进行网络请求
    WeakSelf;
    [[self dataTaskWithRequest:self.spcRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {//网络请求成功
            NSLog(@"网络请求成功-success = %@",responseObject);
            NSLog(@"request.URL = %@",weakSelf.spcRequest.URL);
            NSLog(@"request.allHTTPHeaderFields = %@",weakSelf.spcRequest.allHTTPHeaderFields);
            NSLog(@"params = %@",params);
            success(responseObject);
        } else {//网络请求失败
            NSLog(@"网络请求失败 = %@",error);
            failure(error);
        }
    }] resume];
}

#pragma mark - 设置request
- (NSMutableURLRequest *)dealURLRequestWithUrl:(NSString *)url method:(HTTPMethod) method{
    //1、请求方法
    NSString *requestMethod;
    if (method == HTTPMethodGet) {
        requestMethod = @"GET";
    }else if (method == HTTPMethodPost){
        requestMethod = @"POST";
    }else{
        requestMethod = @"GET";
    }
    //2、请求request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:requestMethod URLString:url parameters:nil error:nil];
    //设置缓存策略(不使用缓存)
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    //设置超时时长
    request.timeoutInterval= SPCTimeoutInterval;
    //设置上传数据type
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //设置接受数据type
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //3、判断是不是获取验证码和登陆，就要设置请求头Blade-Auth和Authorization
    if (![url containsString:@"/users/captcha"] &&
        ![url containsString:@"/users/skyworthdigitallogin"]) {//非验证码和登陆
        NSString *bladeAuth = [NSString stringWithFormat:@"bearer %@",self.access_token];
        [request setValue:bladeAuth forHTTPHeaderField:@"Blade-Auth"];
        [request setValue:@"Basic c2t5d29ydGhkaWdpdGFsOnNreXdvcnRoZGlnaXRhbF9zZWNyZXQ=" forHTTPHeaderField:@"Authorization"];
    }
    return request;
}

#pragma mark - 处理参数
- (NSString *)dealParamToStringWithDict:(NSDictionary *)params{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
