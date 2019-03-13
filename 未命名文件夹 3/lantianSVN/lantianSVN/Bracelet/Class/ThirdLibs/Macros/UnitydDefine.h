//
//  UnitydDefine.h
//  MasonryDemo
//
//  Created by 谢英泽 on 2016/11/10.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#ifndef UnitydDefine_h
#define UnitydDefine_h

/**
 当前窗口
 */
#define kUI_Window          [UIApplication sharedApplication].keyWindow

/**
 判断手机型号
 */
#define kUI_is_Iphone6p     ([[UIScreen mainScreen] bounds].size.height == 736.0f )
#define kUI_is_Iphone6      ([[UIScreen mainScreen] bounds].size.height == 667.0f )
#define kUI_is_Iphone5      ([[UIScreen mainScreen] bounds].size.height == 568.0f )
#define kUI_is_Iphone4      ([[UIScreen mainScreen] bounds].size.height == 480.0f )

/**
 判断系统版本
 */
#define kUI_is_IOS10        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0f)
#define kUI_is_IOS9         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)
#define kUI_is_IOS8         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define kUI_is_IOS7         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f && [[[UIDevice currentDevice systemVersion] floatValue] <= 7.2f)

/**
 DEBUG模式
 */
#ifdef DEBUG
#define DeBugLog(fmt,...) adaLog((@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define DeBugLog(...)
#endif

#endif /* UnitydDefine_h */
