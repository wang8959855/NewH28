//
//  BlueToothManager.h
//  TestBlueToothVector
//
//  Created by zhangtan on 14-9-24.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "SedentaryModel.h"
#import "DisturbModel.h"
#import "NotifyModel.h"

#define kState [[[NSUserDefaults standardUserDefaults] objectForKey:kUnitStateKye] intValue]

@protocol BlutToothManagerDelegate <NSObject>

@optional
//蓝牙是否连接，YES表示连接,NO表示断开
- (void)blueToothManagerIsConnected:(BOOL)isConnected connectPeripheral:(CBPeripheral *)peripheral;
- (void)blueToothManagerReceiveNotifyData:(NSData *)Dat;
- (void)blueToothManagerReceiveHeartRateNotify:(NSData *)Dat;
- (void)callbackConnectTimeAlert:(int)TimeAlert;
- (void)callbackCBCentralManagerState:(CBCentralManagerState)state;
@end

@interface BlueToothManager : NSObject

#pragma mark -- block
typedef void (^otaProgressBlock) (int progress);
typedef void(^otaErrorBlock)(NSString *error);

@property (nonatomic, copy) otaProgressBlock progressBlock;

@property (nonatomic, copy) otaErrorBlock errorBlock;

@property (nonatomic, assign) int connectTimeAlert;//是否弹窗了。1为未提示，2为已提示

@property (nonatomic , weak) id<BlutToothManagerDelegate>delegate;
@property (nonatomic , retain) NSString *connectUUID;
@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, retain) NSString *deviceName;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (strong, nonatomic) NSData *sendingData;
@property (nonatomic, assign) int resendCount;
@property (nonatomic, assign) BOOL canPaired;
@property (strong, nonatomic) NSString *romURL;
@property (nonatomic, assign) BOOL isOTAMode;
@property (nonatomic, assign) BOOL isOTAIng;
@property (nonatomic, strong) NSURL *url;

typedef enum {
    UnitStateNone = 1,
    UnitStateBritishSystem,
    UnitStateMetric,
}UnitState;


+ (BlueToothManager *)getInstance;
+ (void)clearInstance;

- (void)ConnectWithUUID:(NSString *)connectUUID;
- (void)ConnectPeripheral:(CBPeripheral *)peripheral;
- (void)disConnectPeripheralWithUuid:(NSString *)uuid;


#pragma mark -- 发送指令

- (void)getBatteryinformation;

- (void)getActualData;

- (void)changeHeartStateWithState:(BOOL)state;

- (void)getHistoryDataWithyeah:(int)yeah month:(int)month day:(int)day andHour:(int)hour ;

- (void)getHardwareVersion;

- (void)getAlarmDataWithID:(int)idnumber;

- (void)setAlarmWithAlarmID:(int)alarmID State:(int)state Hour:(int)hour Minute:(int)minute Repeat:(int)repeat;

- (void)beginOTAWithURL:(NSURL*)url;

- (void)cancelOTA;

- (void)setAlarmNameWithAlarmID:(int)alarmID Name:(NSString *)name;

- (void)getSystemNotify;

- (void)setNotifyWithNotifyModel:(NotifyModel *)notifyModel;

- (void)getSedentaryData;

- (void)setSedentaryWithSedentaryWithSedentaryModel:(SedentaryModel *)model;

- (void)findBracelet;

- (void)changeTakePhoteStateWithState:(BOOL)state;

- (void)getLiftHandState;

- (void)setLiftHandStateWithState:(int)state;

- (void)getHeartRateState;

- (void)getHeartRateTime;

- (void)setHeartRateStateWithState:(int)state;

- (void)getDisturbInformation;

- (void)setDisturbInformationWith:(DisturbModel *)model;

- (void)sendUserInformationWithHeight:(int)height weight:(int)weight gender:(int)gender;

- (void)setBindUnitWith:(int)unit andTimeType:(int)type isEnglish:(BOOL)isEnglish;

- (void)readRSSI;

- (void)setHeartRateTimeIntervel:(int)minites;

/**
 *  获取设备是否已连接
 *
 *  @param device 设备对象
 *
 *  @return YES 已连接  NO 未连接
 */
-(BOOL)readDeviceIsConnect:(CBPeripheral *)device;

//开始扫描
- (void)startScan;


@end
