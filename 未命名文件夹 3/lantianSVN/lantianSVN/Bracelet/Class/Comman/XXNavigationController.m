//
//  XXNavigationController.m
//  Bracelet
//
//  Created by SZCE on 16/1/19.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "XXNavigationController.h"

@interface XXNavigationController ()

@end

@implementation XXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0)
    {
        //隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        //设置不透明
        self.navigationBar.translucent = NO;
        
        //文字属性
        [self.navigationBar setBarTintColor:kRGBCOLOR(30, 31, 35, 1.0)];
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
