//
//  XXUserInformation.h
//  Bracelet
//
//  Created by wangwendong on 16/1/12.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface XXUserInformation : NSObject




//昵称


//邮箱
+ (NSString *)email;
+ (void)setEmail:(NSString *)email;




//生日_年

//年龄

//运动目标
+ (NSString *)userSportTarget;
+ (void)setUserSportTarget:(NSString *)userSportTarget;

//睡眠目标_小时
+ (NSString *)userSleepHourTarget;
+ (void)setUserSleepHourTarget:(NSString *)userSleepHourTarget;

//睡眠目标_分
+ (NSString *)userSleepMinuteTarget;
+ (void)setUserSleepMinuteTarget:(NSString *)userSleepMinuteTarget;

//单位
+ (NSString *)userUnit;
+ (void)setUserUnit:(NSString *)userUnit;

//标记是否已经设置过基本信息
+ (BOOL)userIsFirstLogin;
+ (void)setUserIsFirstLogin:(BOOL)isFirstLogin;


@end
