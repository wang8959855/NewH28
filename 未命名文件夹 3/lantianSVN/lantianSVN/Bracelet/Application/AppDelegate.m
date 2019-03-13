//
//  AppDelegate.m
//  Bracelet
//
//  Created by SZCE on 16/1/5.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "AppDelegate.h"
#import "PickerViewController.h"
#import "LXXIntroductionViewController.h"
#import "XXTabBarController.h"

@interface AppDelegate ()

@property(nonatomic,strong)LXXIntroductionViewController *introductionViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLunch"])//手机第一次安装，显示引导页
    {
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstLunch"];
        self.introductionViewController = [[LXXIntroductionViewController alloc]init];
        
        __weak AppDelegate *weakSelf = self;
        [self.introductionViewController setEnterBlock:^{
            
            PickerViewController *parkerVC = [[PickerViewController alloc]init];
            
            [weakSelf.introductionViewController presentViewController:parkerVC animated:YES completion:nil];
        }];
        
        self.window.rootViewController = weakSelf.introductionViewController;
    }
    else
    {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"])//未登录状态
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
            PickerViewController *parkerVC = [[PickerViewController alloc]init];
            self.window.rootViewController = parkerVC;
        }
        else //已经登录状态
        {
            XXTabBarController *tabbar = [[XXTabBarController alloc]init];
            self.window.rootViewController = tabbar;
        }
        
    }

    return YES;
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
