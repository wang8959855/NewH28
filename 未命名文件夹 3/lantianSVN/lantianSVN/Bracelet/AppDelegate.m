//
//  AppDelegate.m
//  Bracelet
//
//  Created by SZCE on 16/1/5.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LXXIntroductionViewController.h"
#import "XXDeviceInfomation.h"
#import <CoreTelephony/CTCallCenter.h>
//音乐播放
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import <UMSocialCore/UMSocialCore.h>

#import "PSDrawerManager.h"
#import "HomeView.h"

#import "userDataModel.h"
#import "StartUpViewController.h"

@import CoreTelephony;

@interface AppDelegate ()


@property(nonatomic,strong)LXXIntroductionViewController *introductionViewController;

/**
 *  标志是否处于后台
 */

/**
 *  请求后台任务
 */
@property (unsafe_unretained, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation AppDelegate



void uncaughtExceptionHandler(NSException*exception){
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UITabBar appearance] setTranslucent:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58e466049f06fd6528000470"];
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = YES;
    [self configUSharePlatforms];
    
    [self getAppStoreVersion];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser_Info];
    if (dic.allKeys.count > 0) {
        [self changeMainState];
    }else{
        [self changeLoginState];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMainState) name:changeMainNofication object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginState) name:changeLoginNofication object:nil];
    
    //网络状态监听
    [self networking];
    
    return YES;
}
//切换到未登录状态
- (void)changeLoginState{
    [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:LastLoginUser_Info];
    StartUpViewController *loginVC = [[StartUpViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = loginNav;
    [self.window makeKeyAndVisible];
}
//切换到登录状态
- (void)changeMainState{
    [[[BaseViewController alloc] init] getUserInfo];
    XXTabBarController *tabbar = [[XXTabBarController alloc]init];
    self.mainTabBarController = tabbar;
    HomeView *leftView = [[HomeView alloc]init];
    leftView.frame = CGRectMake(0, 0, 250*WidthProportion, CurrentDeviceHeight);
    [[PSDrawerManager instance] installCenterViewController:tabbar leftView:leftView];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
}


#pragma mark -- U盟设置
- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106082322" appSecret:nil redirectURL:@"www.czjk-lingyue.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"434473176891404"  appSecret:@"89602d9cadb2b9f2b3b6bbf310b21dab" redirectURL:@"www.czjk-lingyue.com"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"Hc2teX4dzmK719IPwpUASRUUS"  appSecret:@"qiGEIIIjCultl1EEKUdN5yobFhBHSyuzVYUhXXzDcXzLW9yOh0" redirectURL:nil];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx2bf972970efd43ba" appSecret:@"4f14b0366eb6fdf9699e84c0354f2ab6" redirectURL:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

//关闭横屏
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)applicationWillResignActive:(UIApplication *)application {

    //后台支持接收远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //核心代码
    _isBackground = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
        [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
            
        }];
    
    _isBackground = YES;
    
    [self getAppStoreVersion];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    adaLog(@"enter foregroud");

    _isBackground = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    _isBackground = NO;
    

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    _isBackground = YES;
}


#pragma mark - private selector


#pragma mark - function



//获取appStore版本
- (void)getAppStoreVersion{
    NSString *urlStr = @"http://itunes.apple.com/lookup?id=1319730997";
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:urlStr ParametersDictionary:nil Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        NSString * version      = responseObject[@"results"][0][@"version"];//线上最新版本
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion       = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//当前用户版本
        BOOL result = [currentVersion compare:version] == NSOrderedAscending;
        if (result) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"updeateVersion"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"updeateVersion"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVersion" object:nil];
    }];
}



/**
 *  网络监听
 */
- (void)networking{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
               _isNetworking = NO;
                break;
            case AFNetworkReachabilityStatusUnknown:
                _isNetworking = NO;
                break;
            default:
                _isNetworking = YES;
                break;
        }
    }];
    
    [manager startMonitoring];
}

/**
 *  是否支持通知中心
 *
 *  return 是否支持通知中心YES or NO
 */

@end
