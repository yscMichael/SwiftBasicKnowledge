//
//  MonitorViewController.m
//  swiftProject
//
//  Created by 杨世川 on 2019/12/10.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "MonitorViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface MonitorViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locManager;

@property (weak, nonatomic) IBOutlet UILabel *wifiSsidTf;
@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locManager = [[CLLocationManager alloc] init];
    [self testWifiList];
    [self getcurrentLocation];
}



#pragma mark - 获取wifi列表
- (void)testWifiList{
    
}

#pragma mark - 获取当前位置权限
- (void)getcurrentLocation {
//    if (@available(iOS 13.0, *)) {
        //用户明确拒绝，可以弹窗提示用户到设置中手动打开权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //使用下面接口可以打开当前应用的设置页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            //弹框提示用户是否开启位置权限
            [self.locManager requestWhenInUseAuthorization];
        }
//    }
}

#pragma mark - 位置权限获取以后才能正确获取到SSID
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        //再重新获取ssid
        self.wifiSsidTf.text = [self wifSsid];
    }else{
        NSLog(@"您点击了不允许，将不能获取wifi哦");
    }
}

#pragma mark - 获取SSID方法
- (NSString*)wifSsid
{
    NSArray *interfaces = (__bridge_transfer NSArray*)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    for (NSString *ifname in interfaces) {
        info = (__bridge_transfer NSDictionary*)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        //这里可以获取SSID和BSSID
        NSLog(@"信息 = %@",info);
        if (info && [info count]) {
            break;
        }
        info = nil;
    }
    
    NSString *ssid = nil;
    
    if ( info ){
        ssid = [info objectForKey:@"SSID"];
    }
    info = nil;
    return ssid? ssid:@"";
}




- (void)test{
    NSDictionary *dict = [self wifiInfo];
    NSLog(@"dictdictdict = %@",dict);
    
    NSString *ssid = [self getWifiSsid];
    NSLog(@"ssidssidssid = %@",ssid);
}

- (NSDictionary *)wifiInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"interfaces:%@",ifs);
    NSDictionary *info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        NSLog(@"%@ => %@",ifname,info);
    }
    return info;
}

- (NSString*) getWifiSsid {
    if (@available(iOS 13.0, *)) {
        //用户明确拒绝，可以弹窗提示用户到设置中手动打开权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            NSLog(@"User has explicitly denied authorization for this application, or location services are disabled in Settings.");
            //使用下面接口可以打开当前应用的设置页面
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            return nil;
        }
        CLLocationManager* cllocation = [[CLLocationManager alloc] init];
        if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            //弹框提示用户是否开启位置权限
            [cllocation requestWhenInUseAuthorization];
            usleep(50);
            //递归等待用户选选择
            //return [self getWifiSsidWithCallback:callback];
            return @"test--12313";
        }
    }
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));

        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }

    CFRelease(wifiInterfaces);
    return wifiName;
}

@end
