//
//  Common.h
//  Bracelet
//
//  Created by SZCE on 16/1/13.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

/**
 *  验证邮箱是否合理
 *
 *  @param email 邮箱字符串
 *
 *  @return yes为合理，no为不合理
 */
+ (BOOL) validateEmail:(NSString *)email;

+ (BOOL)validatePhoneNumber:(NSString *)number;

/**
 *  @brief  根据颜色生成纯色图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (void)uploadSleepTimeChangedWithTime:(int)timeSeconds;

+ (NSString *)sleepTime;

+ (void)uploadHeartTimeChangedWithTime:(int)timeSeconds;

+ (NSString *)heartTime;

+ (void)uploadSportTimeChangedWithTime:(int)timeSeconds;

+ (NSString *)sportTime;

+ (int)nowTime;
@end
