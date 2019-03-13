//
//  UnityTool.h
//  LingQianGuan
//
//  Created by wtjr on 16/6/12.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppHeader.h"

#define kAPP_deviceUUID     @"kAPP_deviceUUID"

@interface UnityTool : NSObject

+ (instancetype)shareInstance;

#pragma mark - 用户信息相关
//获取UUID
- (NSString *)getUUID;

//获取UserID

#pragma mark - MD5加密
//加密字符串
+ (NSString *)md5ForString:(NSString*)str;
//加密data
+ (NSString *)md5ForData:(NSData *)data;

@end
