//
//  SPCPortraitFixedController.m
//  SkyPiCameraiOSProject
//
//  Created by 杨世川 on 2019/12/14.
//  Copyright © 2019 Eric. All rights reserved.
//

/**
这里针对的是屏幕只有竖屏(不会改变坐标系)、采用旋转动画的方式、固定布局
*/

#import "SPCPortraitFixedController.h"

#define FirstViewHeight 165

@interface SPCPortraitFixedController ()
//第一个View
@property (nonatomic ,strong) UIView *firstView;
//第二个View
@property (nonatomic ,strong) UIView *secondView;
//判断当前是不是竖屏
@property (nonatomic ,assign) BOOL isPortrait;
@end

@implementation SPCPortraitFixedController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

#pragma mark - 初始化数据
- (void)initData{
    //暂时默认竖屏
    self.isPortrait = true;
    //工程配置只有竖屏
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - 初始化View
- (void)initViews{
    [self.view addSubview:self.firstView];
    [self.view addSubview:self.secondView];
    
    //固定布局
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.firstView.frame = CGRectMake(0, 88, width, FirstViewHeight);
    self.secondView.frame = CGRectMake(0,88 + FirstViewHeight, width, height - 88 - FirstViewHeight);
}

#pragma mark - Private Methods
- (void)orientationChanged:(NSNotification *)notification{
    NSLog(@"更新布局了");
    //获取当前设备的方向
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        //竖屏
        case UIDeviceOrientationPortrait:
            NSLog(@"竖屏");
            [self dealPortrait];
            break;
        //左横屏
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"左横屏");
            [self dealRoate];
            break;
        //右横屏
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"右横屏");
            [self dealRoate];
            break;
        //倒立
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"倒立");
            break;
        default:
            break;
    }
}

#pragma mark - 处理竖屏问题
- (void)dealPortrait{
    //判断当前是不是竖屏
    if (self.isPortrait) {
        return;
    }
    self.isPortrait = YES;
    //1、显示导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //2、先执行翻转动画
    //创建transform对象
    CGAffineTransform  transform;
    //设置旋转度数
    transform = CGAffineTransformRotate(self.firstView.transform,-M_PI/2);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:0.5];
    //添加代理
    [UIView setAnimationDelegate:self];
    //设置View的transform
    [self.firstView setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
    //3、设置布局
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.firstView.frame = CGRectMake(0, 88, width, FirstViewHeight);
}

#pragma mark - 处理旋转问题
- (void)dealRoate{
    //判断当前是不是竖屏
    if (!self.isPortrait) {
        return;
    }
    self.isPortrait = false;
    //1、隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //2、将页面提前
    [self.view bringSubviewToFront:self.firstView];
    //3、设置布局
    CGFloat width = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat height = [UIApplication sharedApplication].keyWindow.bounds.size.height;
    //宽高互换
    self.firstView.frame = CGRectMake(0, 0,height, width);
    //设置中心点(锚点)
    CGFloat centerX = CGRectGetMidX([UIApplication sharedApplication].keyWindow.bounds);
    CGFloat centerY = CGRectGetMidY([UIApplication sharedApplication].keyWindow.bounds);
    self.firstView.center = CGPointMake(centerX, centerY);
    //4、执行翻转动画
    //创建transform对象
    CGAffineTransform  transform;
    //设置旋转度数
    transform = CGAffineTransformRotate(self.firstView.transform,M_PI/2);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:0.5];
    //添加代理
    [UIView setAnimationDelegate:self];
    //设置View的transform
    [self.firstView setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
}

#pragma mark - Getter And Setter
- (UIView *)firstView{
    if (!_firstView) {
        _firstView = [[UIView alloc] init];
        _firstView.backgroundColor = [UIColor redColor];
    }
    return _firstView;
}

- (UIView *)secondView{
    if (!_secondView) {
        _secondView = [[UIView alloc] init];
        _secondView.backgroundColor = [UIColor greenColor];
    }
    return _secondView;
}
@end
