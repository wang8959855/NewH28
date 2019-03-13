//
//  XXUserInformation.m
//  Bracelet
//
//  Created by wangwendong on 16/1/12.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "XXUserInformation.h"

#define XXUserInfoUserName @"XXUserInfoUserName"
#define XXUserInfoLoginName @"XXUserInfoLoginName"
#define XXUserInfoIsSavePassword @"XXUserInfoIsSavePassword"
#define XXUserInfoPassword @"XXUserInfoPassword"
#define XXUserInfoEmail @"XXUserInfoEmail"
#define XXUserInfoSex @"XXUserInfoSex"
#define XXUserInfoWeight @"XXUserInfoWeight"
#define XXUserInfoStrid @"XXUserInfoStrid"
#define XXUserInfoHeight @"XXUserInfoHeight"
#define XXUserInfoYear @"XXUserInfoYear"
#define XXUserInfoMonth @"XXUserInfoMonth"
#define XXUserInfoDay @"XXUserInfoDay"
#define XXUserInfoUserAge @"XXUserInfoUserAge"
#define XXUserInfoUserSportTarget @"XXUserInfoUserSportTarget"
#define XXUserInfoUserSleepHourTarget @"XXUserInfoUserSleepHourTarget"
#define XXUserInfoUserSleepMinuteTarget @"XXUserInfoUserSleepMinuteTarget"
#define XXUserInfoUserUnit @"XXUserInfoUserUnit"
#define XXUserInfoIsFirstLogin @"XXUserInfoIsFirstLogin"


@implementation XXUserInformation


+ (NSString *)email
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoEmail];
    
    return [[NSUserDefaults standardUserDefaults]valueForKey:key];
}

+ (void)setEmail:(NSString *)email
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoEmail];
    
    if (email.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:email forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


//体重




//身高


//生日_年


//运动目标
+ (NSString *)userSportTarget
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoUserSportTarget];
    
    NSString *userSportTarget = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (!userSportTarget) {
        // 如果没有保存过，这里是默认的-1
        userSportTarget = @"10000";
        
        [self setUserSportTarget:userSportTarget];
    }
    
    return userSportTarget;
}

+ (void)setUserSportTarget:(NSString *)userSportTarget
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoUserSportTarget];
    
    if (userSportTarget) {
        [[NSUserDefaults standardUserDefaults] setObject:userSportTarget forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//睡眠目标_小时
+ (NSString *)userSleepHourTarget
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoUserSleepHourTarget];
    
    NSString *userSleepHourTarget = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (!userSleepHourTarget) {
        // 如果没有保存过，这里是默认的-1
        userSleepHourTarget = @"7";
        
        [self setUserSleepHourTarget:userSleepHourTarget];
    }
    
    return userSleepHourTarget;
}

+ (void)setUserSleepHourTarget:(NSString *)userSleepHourTarget
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoUserSleepHourTarget];
    
    if (userSleepHourTarget) {
        [[NSUserDefaults standardUserDefaults] setObject:userSleepHourTarget forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//睡眠目标_分
+ (NSString *)userSleepMinuteTarget
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoUserSleepMinuteTarget];
    
    NSString *userSleepMinuteTarget = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (!userSleepMinuteTarget) {
        // 如果没有保存过，这里是默认的-1
        userSleepMinuteTarget = @"0";
        
        [self setUserSleepMinuteTarget:userSleepMinuteTarget];
    }
    
    return userSleepMinuteTarget;
}

+ (void)setUserSleepMinuteTarget:(NSString *)userSleepMinuteTarget
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoUserSleepMinuteTarget];
    
    if (userSleepMinuteTarget) {
        [[NSUserDefaults standardUserDefaults] setObject:userSleepMinuteTarget forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)userUnit {
    
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoUserUnit];
    
    NSString *userUnit = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (!userUnit) {
        // 如果没有保存过，这里是默认的
        userUnit = @"1";
        
        [self setUserUnit:userUnit];
    }
    
    return userUnit;
}

+ (void)setUserUnit:(NSString *)userUnit {
    
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoUserUnit];
    
    if (userUnit) {
        [[NSUserDefaults standardUserDefaults] setObject:userUnit forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//标记是否已经设置过基本信息
+ (BOOL)userIsFirstLogin
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoIsFirstLogin];
    
    BOOL userIsFirstLogin = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    return userIsFirstLogin;
}

+ (void)setUserIsFirstLogin:(BOOL)isFirstLogin
{
    NSString *key = [NSString stringWithFormat:@"%@%@",kHCH.userInfoModel.name,XXUserInfoIsFirstLogin];
    [[NSUserDefaults standardUserDefaults] setBool:isFirstLogin forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
