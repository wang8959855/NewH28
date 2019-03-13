//
//  BaseViewController.h
//  MasonryDemo
//
//  Created by 谢英泽 on 2016/11/11.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppHeader.h"
#import "MJRefresh.h"


#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define PageBtn .0675 * ScreenH //6s下高度45

#define kDY  (ScreenH - 64 - PageBtn) / (667 -64 - PageBtn)

#define kSY   (ScreenH - 64) / (667 - 64)

#define kX    ScreenW / 375.0


@interface BaseViewController : UIViewController


@property (nonatomic, weak) UIActivityIndicatorView *activityView;
/**
 跳转
 */
- (void)modal:(UIViewController *)modal from:(UIViewController*)from;

- (void)push:(UIViewController*)push from:(UINavigationController *)from;

- (void)addnavTittle:(NSString *)title RSSIImageView:(BOOL)RSSI shareButton:(BOOL)shareButton;

/**
 返回按钮相关
 */


- (void)finishNavi;



// 添加移除hud
- (void)addActityIndicatorInView :(UIView *)view labelText : (NSString *)labelString detailLabel : (NSString *)detailString;

- (void)removeActityIndicatorFromView : (UIView *)view;

- (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times;

// frame设置

- (CGRect)setCGRectWithX:(float)x Y:(float)Y Width:(float)width Heigth:(float)height;

- (void)configTextField:(UITextField *)textFiled;

- (void)addNavWithTitle:(NSString *)title backButton:(BOOL)backButton shareButton:(BOOL)shareButton;

- (UIImage *)imageWithColor:(UIColor *)color;

- (UIResponder *)checkNextResponderIsKindOfViewController : (Class)viewClass;

- (void)setButtonWithButton:(UIButton *)button andTitle:(NSString *)string;

- (void)showAlertView:(NSString *)string;

- (BOOL) isUserName:(NSString *)userName;
- (BOOL) isPassWord:(NSString *)passWord;
- (BOOL) checkUserName:(NSString *)userName;
- (BOOL) checkPassWord:(NSString *)passWord;

- (void)getUserInfo;
- (void)loginTimeOut;

@end
