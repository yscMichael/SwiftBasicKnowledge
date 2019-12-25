//
//  AppDelegate.swift
//  swiftProject
//
//  Created by yangshichuan on 2019/12/4.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        //初始化框架
        initFrameworkLaunchWithOptions()
        //设置根控制器
        initRootController()
        return true
    }
    
    //初始化框架
    func initFrameworkLaunchWithOptions() {
        
    }
    
    //MARK:初始化根控制器
    func initRootController() {
        //进入监听网络界面
        let homeCtrl: HomeListController = HomeListController()
        window?.rootViewController = homeCtrl
        window?.makeKeyAndVisible()
        
//        let monitor: MonitorViewController = MonitorViewController()
//        window?.rootViewController = monitor
//        window?.makeKeyAndVisible()
        
        
        
        //测试二维码生成图片
//        let navCtrl = UINavigationController.init(rootViewController: HomeListController())
//        window?.rootViewController = navCtrl
//        window?.makeKeyAndVisible()
        
        //判断是否登陆
//        let defaults = UserDefaults.standard
//        let isLogin = defaults.bool(forKey: "isLogin")
//        if isLogin {//进入首页(要判断token是否过期)
//            let navCtrl = UINavigationController.init(rootViewController: HomeListController())
//            window?.rootViewController = navCtrl
//            window?.makeKeyAndVisible()
//        }else{//登陆界面
//            let navCtrl = UINavigationController.init(rootViewController: LoginController.init())
//            window?.rootViewController = navCtrl
//            window?.makeKeyAndVisible()
//        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

