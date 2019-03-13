//
//  AppDelegate.h
//  Bracelet
//
//  Created by SZCE on 16/1/5.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL isNetworking;

@property (assign, nonatomic) BOOL isBackground;

@property (nonatomic, strong) UITabBarController *mainTabBarController;

@property (strong, nonatomic) UIButton *coverBtn;//覆盖按钮  用于侧滑的覆盖右侧

@end

