//
//  XXDeviceInfomation.m
//  Bracelet
//
//  Created by SZCE on 16/1/18.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "XXDeviceInfomation.h"

#define XXDeviceIdentifierString @"XXDeviceIdentifierString"
#define XXDeviceCallSwitch @"XXDeviceCallSwitch"
#define XXMusicControlSwitch @"XXMusicControlState"
#define XXDeviceSMSSwitch @"XXDeviceSMSSwitch"
#define XXDeviceAppRemidSwitch @"XXDeviceAppRemidSwitch"
#define XXDeviceDisturbSwitch @"XXDeviceDisturbSwitch"
#define XXDeviceFindPhoneSwitch @"XXDeviceFindPhoneSwitch"
#define XXDeviceCallSecond @"XXDeviceCallSecond"
#define XXDeviceSittingSwitch @"XXDeviceSittingSwitch"
#define XXDeviceSittingSecond @"XXDeviceSittingSecond"
#define XXDeviceNotifyONRepeat @"XXDeviceNotifyONRepeat"
#define XXdeviceDisturbStartTime @"XXdeviceDisturbStartTime"
#define XXdeviceDisturbOverTime @"XXdeviceDisturbOverTime"
#define XXDeviceSittingRepeat @"XXDeviceSittingRepeat"
#define XXDeviceBind @"XXDeviceBind"
#define XXDeviceAlarmArray @"XXDeviceAlarmArray"
#define XXDeviceVersion @"XXDeviceVersion"
#define XXDeviceEnerge @"XXDeviceEnerge"
#define XXDeviceUpdateTime @"XXDeviceUpdateTime"
#define XXDeviceIsUpdate @"XXDeviceIsUpdate"
#define XXDeviceIsUpdated @"XXDeviceIsUpdated"
#define XXDeviceIsSupportANCS @"XXDeviceIsSupportANCS"

@implementation XXDeviceInfomation

+ (BOOL)isBindDevice
{
    
    BOOL isBindDevice = [[NSUserDefaults standardUserDefaults]boolForKey:XXDeviceBind];
    
    return isBindDevice;
}

+ (void)setIsBindDevice:(BOOL)isBindDevice
{
    [[NSUserDefaults standardUserDefaults] setBool:isBindDevice forKey:XXDeviceBind];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



//设备标识
+ (NSString *)deviceIdentifierString
{
    NSString *bindUUID = [[NSUserDefaults standardUserDefaults]valueForKey:XXDeviceIdentifierString];
    adaLog(@"绑定UUID======%@",bindUUID);
    return [[NSUserDefaults standardUserDefaults]valueForKey:XXDeviceIdentifierString];
}

+ (void)setDeviceIdentifierString:(NSString *)deviceIdentifierString
{
    if (deviceIdentifierString.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:deviceIdentifierString forKey:XXDeviceIdentifierString];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



//电池余量

+ (BOOL)isMusicControl
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:XXMusicControlSwitch];
}
+ (void)setMusicControlState:(BOOL)state
{
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:XXMusicControlSwitch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



//APP提醒开关  AppRemid






+ (void)setDeviceSittingRepeat:(NSMutableDictionary *)deviceSittingrepeat
{
    if (deviceSittingrepeat) {
        
        [[NSUserDefaults standardUserDefaults] setObject:deviceSittingrepeat forKey:XXDeviceSittingRepeat];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//通知提醒开关设置
+ (NSMutableDictionary *)deviceNotifyONRepeat
{
    NSMutableDictionary *deviceNotifyONRepeat = [[NSUserDefaults standardUserDefaults]objectForKey:XXDeviceNotifyONRepeat];
    
    if (!deviceNotifyONRepeat) {
        
        deviceNotifyONRepeat = [NSMutableDictionary dictionary];

        [deviceNotifyONRepeat setObject:@(0xFE) forKey:@"repeat"];
        
        [self setDeviceSittingRepeat:deviceNotifyONRepeat];
        
    }
    return deviceNotifyONRepeat;
}

+ (void)setdeviceNotifyONRepeat:(NSMutableDictionary *)deviceNotifyONRepeat
{
    if (deviceNotifyONRepeat) {
        
        [[NSUserDefaults standardUserDefaults] setObject:deviceNotifyONRepeat forKey:XXDeviceNotifyONRepeat];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



//闹钟信息数组
+ (NSMutableArray *)deviceAlarmArray
{
    return [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:XXDeviceAlarmArray];
}

+ (void)setDeviceAlarmArray:(NSMutableArray *)deviceAlarmArray
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceAlarmArray forKey:XXDeviceAlarmArray];
}


//更新时间
+ (NSString *)deviceUpdateTime
{
    NSString *deviceUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:XXDeviceUpdateTime];
    
    if(!deviceUpdateTime)
    {
        [self setDeviceUpdateTime];
        deviceUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:XXDeviceUpdateTime];
    }
    
    return deviceUpdateTime;
}

+ (void)setDeviceUpdateTime
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YY/MM/dd HH:mm"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    if (locationString) {
        
        [[NSUserDefaults standardUserDefaults] setObject:locationString forKey:XXDeviceUpdateTime];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

//标记是否正在更新数据


+ (BOOL)deviceIsUpdated
{
    BOOL deviceIsUpdating = [[NSUserDefaults standardUserDefaults] boolForKey:XXDeviceIsUpdated];
    
    return deviceIsUpdating;
}

+ (void)setDeviceIsUpdated:(BOOL)deviceIsUpdated
{
    [[NSUserDefaults standardUserDefaults] setBool:deviceIsUpdated forKey:XXDeviceIsUpdated];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//设备是否支持通知中心
+ (BOOL)deviceIsSupportANCS
{
    BOOL deviceIsSupportANCS = [[NSUserDefaults standardUserDefaults] boolForKey:XXDeviceIsSupportANCS];
    
    return deviceIsSupportANCS;
}

+ (void)setDeviceIsSupportANCS:(BOOL)deviceIsSupportANCS
{
    [[NSUserDefaults standardUserDefaults] setBool:deviceIsSupportANCS forKey:XXDeviceIsSupportANCS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
