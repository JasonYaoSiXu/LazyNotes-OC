//
//  AppDelegate.m
//  LazyNotes
//
//  Created by yaosixu on 2016/9/28.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "iflyMSC/IFlyMSC.h"
#import "ConstValue.h"

//appid: 57eb5414

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    //设置sdk的log等级，log保存在下面设置的工作路径中
//    [IFlySetting setLogFile:LVL_ALL];
//    //打开输出在console的log开关
//    [IFlySetting showLogcat:NO];
//    //设置sdk的工作路径
//    NSArray *paths =     NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [paths objectAtIndex:0];
//    [IFlySetting setLogFilePath:cachePath];
//    // 语音
//    NSString *initString = APPID_VALUE;
//    [IFlySpeechUtility createUtility:initString];
    
    NSString *initString = [NSString stringWithFormat:@"%@=%@", [IFlySpeechConstant APPID], @"57eb5414"];
    [IFlySpeechUtility createUtility:initString];

    [WXApi registerApp:@"wxc5650f664872449d"];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nVc = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    _window.rootViewController = nVc;
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];

    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//MARK WeiXin
-(void)onReq:(BaseReq *)req {
    NSLog(@"++++++++++++++++++++++++++++++");
}

-(void)onResp:(BaseResp *)resp {
    NSLog(@"-----------------------------------------------------");
}

@end
