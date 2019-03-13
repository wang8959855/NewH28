//
//  XXUserInformation.h
//  Bracelet
//
//  Created by wangwendong on 16/1/12.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXUserInformation : NSObject

//@property (nonatomic, copy) NSString *loginName;
//
//@property (nonatomic, copy) NSString *userName;
//
//@property (nonatomic) NSNumber *userAge;

+ (NSString *)loginName;
+ (void)setLoginName:(NSString *)loginName;

+ (BOOL)isSavePassword;
+ (void)setIsSavePassword:(BOOL)isSavePassword;

+ (NSString *)password;
+ (void)setPassword:(NSString *)password;

+ (NSString *)userName;
+ (void)setUserName:(NSString *)userName;

+ (NSNumber *)userAge;
+ (void)setUserAge:(NSNumber *)userAge;

@end
