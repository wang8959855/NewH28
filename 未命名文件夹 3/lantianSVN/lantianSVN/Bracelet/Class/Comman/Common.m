//
//  Common.m
//  Bracelet
//
//  Created by SZCE on 16/1/13.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "Common.h"

@implementation Common

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validatePhoneNumber:(NSString *)number
{
    NSString *phoneRegex = @"^[0-9]+$";
    NSPredicate *phoeText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoeText evaluateWithObject:number];

}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)uploadSleepTimeChangedWithTime:(int)timeSeconds
{
    if (timeSeconds)
    {
        NSString *string = [NSString stringWithFormat:@"%d",timeSeconds];
        [PZSaveDefaluts setObject:string forKey:@"uplosdSleepTime"];
    }
}

+ (NSString *)sleepTime
{
    NSString *string = [PZSaveDefaluts objectForKey:@"uplosdSleepTime"];
    if (string && string.length > 0) {
        return string;
    }else
    return @"0";
}

+ (void)uploadHeartTimeChangedWithTime:(int)timeSeconds
{
    if (timeSeconds)
    {
        NSString *string = [NSString stringWithFormat:@"%d",timeSeconds];
        [PZSaveDefaluts setObject:string forKey:@"uploadHeartTime"];
    }
}

+ (NSString *)heartTime
{
    NSString *string = [PZSaveDefaluts objectForKey:@"uploadHeartTime"];
    if (string && string.length > 0)
    {
        return string;
    }else
        return @"0";
}

+ (void)uploadSportTimeChangedWithTime:(int)timeSeconds
{
    if (timeSeconds)
    {
        NSString *string = [NSString stringWithFormat:@"%d",timeSeconds];
        [PZSaveDefaluts setObject:string forKey:@"uplosdSportTime"];
    }
}

+ (NSString *)sportTime
{
    NSString *string = [PZSaveDefaluts objectForKey:@"uplosdSportTime"];
    if (string && string.length > 0) {
        return string;
    }else
        return @"0";
}

+ (int)nowTime
{
    return [[NSDate date] timeIntervalSince1970];
}


@end
