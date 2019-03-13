//
//  XXUserInformation.m
//  Bracelet
//
//  Created by wangwendong on 16/1/12.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "XXUserInformation.h"

#define XXUserInfoUserName @"XXUserInfoUserName"
#define XXUserInfoUserAge @"XXUserInfoUserAge"
#define XXUserInfoLoginName @"XXUserInfoLoginName"
#define XXUserInfoIsSavePassword @"XXUserInfoIsSavePassword"
#define XXUserInfoPassword @"XXUserInfoPassword"

@implementation XXUserInformation

+ (NSString *)loginName {
    NSString *loginName = [[NSUserDefaults standardUserDefaults] stringForKey:XXUserInfoLoginName];
    
//    if (!loginName) {
//        // 在这里写下你的默认登录名
//        loginName = @"Default user name";
//        
//        [self setLoginName:loginName];
//    }
    
    return loginName;
}

+ (void)setLoginName:(NSString *)loginName {
    if (loginName.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:loginName forKey:XXUserInfoLoginName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)isSavePassword
{
    BOOL isSavePassword = [[NSUserDefaults standardUserDefaults]boolForKey:XXUserInfoIsSavePassword];
    
    return isSavePassword;
}

+ (void)setIsSavePassword:(BOOL)isSavePassword
{
    [[NSUserDefaults standardUserDefaults] setBool:isSavePassword forKey:XXUserInfoIsSavePassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:XXUserInfoPassword];
}

+ (void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults]setValue:password forKey:XXUserInfoPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userName {
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:XXUserInfoUserName];
    
    if (!userName) {
        // 在这里写下你的默认用户名
        userName = @"Default user name";
        
        [self setUserName:userName];
    }
    
    return userName;
}

+ (void)setUserName:(NSString *)userName {
    if (userName.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:userName forKey:XXUserInfoUserName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSNumber *)userAge {
    NSNumber *userAge = [[NSUserDefaults standardUserDefaults] objectForKey:XXUserInfoUserAge];
    
    if (!userAge) {
        // 如果没有保存过，这里是默认的永远18
        userAge = @18;
        
        [self setUserAge:userAge];
    }
    
    return userAge;
}

+ (void)setUserAge:(NSNumber *)userAge {
    if (userAge) {
        [[NSUserDefaults standardUserDefaults] setObject:userAge forKey:XXUserInfoUserAge];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
