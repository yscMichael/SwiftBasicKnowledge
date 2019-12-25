//
//  SPCPortraitLandscapeController.m
//  SkyPiCameraiOSProject
//
//  Created by 杨世川 on 2019/12/14.
//  Copyright © 2019 Eric. All rights reserved.
//

/**
 这里针对的是系统自动翻转(会改变坐标系)、系统自动翻转效果、自适应布局
*/


#import "SPCPortraitLandscapeController.h"
#import "Masonry.h"

#define FirstViewHeight 165

@interface SPCPortraitLandscapeController ()
//第一个View
@property (nonatomic ,strong) UIView *firstView;
//第二个View
@property (nonatomic ,strong) UIView *secondView;
//UIView
@property (nonatomic ,strong) UIView *testView;
//判断当前是不是竖屏
@property (nonatomic ,assign) BOOL isPortrait;
@end

@implementation SPCPortraitLandscapeController
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
    //[self.view addSubview:self.testView];//错误写法，因为是固定高度
    [self.secondView addSubview:self.testView];//正确写法
    
    //自适应布局
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(88);
        make.left.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(FirstViewHeight);
    }];
    //因为firstView的布局会变、所以跟firstView同级的View不能设置固定高度，否则会报布局警告⚠️
    //如果需要设置固定高度，则用一个不需要固定高度的包裹一层(用secondView可以包裹固定高度控件)
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.mas_bottom).with.offset(0);
        make.left.right.bottom.equalTo(self.view).with.offset(0);
    }];
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.secondView).with.offset(0);
        make.height.mas_equalTo(@100);
    }];
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
    //2、设置布局
    [self.firstView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(88);
        make.height.mas_equalTo(FirstViewHeight);
    }];
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
    //3、这里只需要更新布局、不需要添加动画(系统坐标已经改变)
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [self.firstView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(height);
    }];
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

- (UIView *)testView{
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _testView.backgroundColor = [UIColor blueColor];
    }
    return _testView;
}

@end
