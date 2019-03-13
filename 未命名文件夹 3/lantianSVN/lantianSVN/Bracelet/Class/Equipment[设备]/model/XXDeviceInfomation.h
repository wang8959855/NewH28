//
//  XXDeviceInfomation.h
//  Bracelet
//
//  Created by SZCE on 16/1/18.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXDeviceInfomation : NSObject



//是否允许控制音乐播放
+ (BOOL)isMusicControl;
+ (void)setMusicControlState:(BOOL)state;



//设备标识
+ (NSString *)deviceIdentifierString;
+ (void)setDeviceIdentifierString:(NSString *)deviceIdentifierString;


//电话


+ (void)setIsBindDevice:(BOOL)isBindDevice;










//闹钟信息数组
+ (NSMutableArray *)deviceAlarmArray;
+ (void)setDeviceAlarmArray:(NSMutableArray *)deviceAlarmArray;

//更新时间
+ (NSString *)deviceUpdateTime;
+ (void)setDeviceUpdateTime;



//标记是否已经结束刷新
+ (BOOL)deviceIsUpdated;
+ (void)setDeviceIsUpdated:(BOOL)deviceIsUpdated;

//设备是否支持通知中心
+ (BOOL)deviceIsSupportANCS;
+ (void)setDeviceIsSupportANCS:(BOOL)deviceIsSupportANCS;
@end
