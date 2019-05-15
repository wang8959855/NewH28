//
//  CositeaBlueTooth.h
//  Mistep
//
//  Created by 迈诺科技 on 16/9/7.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlueToothScan.h"
#import "BlueToothManager.h"
#import "PZBlueToothHeader.h"
#import "ActualDataModel.h"
#import "historyDataHourModel.h"
#import "HardWearVersionModel.h"
#import "AlarmModel.h"
#import "NotifyModel.h"
#import "SedentaryModel.h"
#import "DisturbModel.h"


//定义的notify name,收到手环端发送的下述命令时,会发送此name的通知
//拍照
static NSString *takePhoto = @"takePhoto";
//进入拍照页面
static NSString *beginTakePhoto = @"beginTakePhoto";
//退出拍照页面
static NSString *endTakePhoto = @"endTakePhoto";
//寻找手机
static NSString *findMyPhone = @"findMyPhone";
//上一曲
static NSString *lastSong = @"lastSong";
//下一曲
static NSString *nextSong = @"nextSong";
//暂停音乐播放
static NSString *pauseMusic = @"pauseMusic";
//开始音乐播放
static NSString *playMusic = @"playMusic";
//发送SOS信息
static NSString *sendSOS = @"sendSOS";
//实时心率
static NSString *nowHeartRate = @"nowHeartRate";

//@protocol CositeaBlueToothManagerDelegate <NSObject>
//@end
@interface PZBlueToothManager : NSObject

#pragma mark -- blocks


typedef void (^arrayBlock)(NSArray *array);

typedef void (^connectStateChanged)(BOOL isConnect, CBPeripheral *peripheral);

typedef void (^actualDataBlock)(ActualDataModel* model);

typedef void (^intBlock)(int number);
typedef void (^floatBlock)(CGFloat number);

typedef void (^doubleIntBlock)(int number1,int number2);

typedef void (^historyDataBlock)(historyDataHourModel *model);

typedef void (^hardVersionBlock)(HardWearVersionModel *model);

typedef void (^alarmModelBlock)(AlarmModel *alarmModel);

typedef void (^notifyModelBlock)(NotifyModel *notifyModel);

typedef void (^sedentaryModelBlock)(SedentaryModel *sedentaryModel);

typedef void (^disturbModelBlock)(DisturbModel *disturbModel);


#pragma mark -- 全局变量


#pragma mark -- methods

/**
 获取实例
 
 @return 返回PZBlueToothManager 单例对象
 */
+ (PZBlueToothManager *)sharedInstance;

#pragma mark -- 扫描方法


/**
 开始扫描设备

 @param deviceArrayBlock 返回为数组,数组内为PerModel
 */
- (void)scanDevicesWithBlock:(arrayBlock)deviceArrayBlock;


#pragma mark -- 连接方法

/**
 连接设备

 @return 第一参数为设备的UUID, 第二个为perName,perName传递perMOdel内的perName,也可以为nil
 */

- (void)connectWithUUID:(NSString *)UUID perName:(NSString *)perName Mac:(NSString *)mac;

/**
 连接状态已改变
 
 @param connectStateBlock 蓝牙已连接/断开连接等蓝牙连接状态改变时会执行次方法回调 状态改变为已连接时会返回已连接的CBPeripheral对象
 */
- (void)connectStateChangedWithBlock:(connectStateChanged)connectStateBlock;

#pragma mark -- 断开连接


/**
 断开当前连接的设备
 */
- (void)disConnectedPeripheral;


#pragma mark -- 请求数据


/**
 获取设备电量

 @param battery block返回int值为剩余电量百分比
 */
- (void)getHardBatteryInformation:(intBlock)battery;


/**
 获取当前数据

 @param modelBlock 返回当天的ActualDataModel;
 */
- (void)getActualDataWithDataBlockWithBlock:(actualDataBlock)modelBlock;


/**
 开启或关闭心率检测状态

 @param state YES为打开心率检测 NO为关闭心率检测 通过此接口打开心率检测,不发送关闭的话,手环会检测5分钟后自动关闭
 @param actualHeartBlock block返回两个int值 number1为状态,1打开,0关闭,number2为实时心率值,打开状态时此block会多次持续调用
 */
- (void)switchActualHeartStateWithState:(BOOL)state andActualHeartBlock:(doubleIntBlock)actualHeartBlock;


/**
 获取历史数据

 @param yeah 年份后两位, 如2017年传入17
 @param month 查询日期的月
 @param day 查询日期的 日
 @param hour 查询日期的小时, 0 - 23
 @param modelBlock block返回historyDataHourModel
 */
- (void)getHistoryDataWithYeah:(int)yeah Month:(int)month Day:(int)day andHour:(int)hour DataBlock:(historyDataBlock)modelBlock;


/**
 获取硬件版本

 @param hardVersionModelBlock block回调HardWearVersionModel
 */
- (void)getHardWearVersionWithHardVersionBlock:(hardVersionBlock)hardVersionModelBlock;


/**
 获取闹钟

 @param alarmID 闹钟的id, 从0 - 7最多8个
 @param block block返回AlarmModel
 */
- (void)getAlarmWithAlarmID:(int)alarmID andAlarmModelBlock:(alarmModelBlock)block;


/**
 设置闹钟

 @param alarmID 闹钟的id, 从0 - 7最多8个
 @param state 闹钟状态 0为关闭,1为开启,2为删除 设置为删除后仍然可以查询,返回状态为2删除
 @param hour 闹钟时间的时 0 - 23
 @param minute 闹钟时间的分钟 0 - 59
                   日 六 五 四 三 二 一
 @param repeat 重复 0  0  0 0 0  0  0 0 重复值为一个字节,8位最低位默认为0,其他从低位到高位为周一,周二,周三,周四,周五,周六,周日,1为当天开启,0为当天关闭
 */
- (void)setAlarmWithAlarmID:(int)alarmID State:(int)state Hour:(int)hour Minute:(int)minute Repeat:(int)repeat;


/**
 设置闹钟名

 @param alarmID 闹钟id
 @param name 闹钟名称,带字库手环可显示,name最长为16字节
 */
- (void)setAlarmNameWithAlarmID:(int)alarmID Name:(NSString *)name;


/**
 获取来电提醒,短信提醒,APP提醒等信息

 @param notify block返回NotifyModel
 */
- (void)getNotifyWithBlock:(notifyModelBlock)notify;


/**
 设置提醒

 @param model 传入一个设置完成的NotifyModel
 */
- (void)setNotifyWithNotifyModel:(NotifyModel *)model;


/**
 获取久坐提醒设置信息

 @param block 返回SedentaryModel 
 */
- (void)getSedentaryWithSedentaryModelBlock:(sedentaryModelBlock)block;


/**
 设置久坐提醒

 @param model 传入SedentaryModel
 */
- (void)setSedentaryWithSedentaryModel:(SedentaryModel *)model;


/**
 寻找手环,发送此命令后手环会震动
 */
- (void)findBracelet;


/**
 开启/关闭手环控制拍照模式

 @param state YES为开启,NO为关闭
 */
- (void)changetakePhoteStateWithState:(BOOL)state;


/**
 获取抬腕亮屏的状态
 
 @param block 1为开启,0为关闭
 */
- (void)getLiftHandStateWithBlock:(intBlock)block;


/**
 设置抬腕亮屏
 
 @param State 1为开启,0为关闭
 */
- (void)setLiftHandStateWithState:(int)State;



/**
 查询心率检测开关状态

 @param block 1为开启, 0为关闭
 */
- (void)getHeartRateStateWithBlock:(intBlock)block;


/**
 查询心率检测时间间隔,心率监测为开启状态时有效
 
 @param block 返回值为 bumber分钟
 */
- (void)getHeartRateTimeinterverWithBlock:(intBlock)block;



/**
 设置手环自动监测心率的时间间隔

 @param minites 单位为分钟 仅可传入3,5,10,30,60,120共6种选择,其他时间传入无效
 */
- (void)setHeartRateTimeWithTime:(int)minites;


/**
 设置心率检测状态

 @param state 1为开启, 0 为关闭
 */
- (void)setHeartRateStateWithState:(int)state;


/**
 查询勿扰模式状态

 @param block 返回DisturbModel
 */
- (void)getDisturbModelWithBlock:(disturbModelBlock)block;

/**
 设置勿扰模式状态
 
 @param model 传入DisturbModel
 */
- (void)setDisturbWithDisturbModel:(DisturbModel *)model;


/**
 发送用户信息到手环

 @param height 身高 单位cm
 @param weight 体重,单位kg
 @param gender 性别 0为女性 1为男性
 */
- (void)sendUserInformationWithHeight:(int)height weight:(int)weight gender:(int)gender;

/**
 发送用户信息到手环
 
 @param bph 血压高压
 @param bpl 血压低压
 @param glu 血糖值 单位为0.1豪摩尔/升，如血糖值为7.8则发送78
 @param spo1 血氧值 血氧整数位（0-99）
 @param spo2 血氧值 血氧小数位（0-9）
 */
- (void)sendUserBph:(int)bph bpl:(int)bpl glu:(int)glu spo1:(int)spo1 spo2:(int)spo2;

/**
 设置手环

 @param unit 手环显示单位 0为公制 1为英制
 @param timeType 设置手环时间显示方式 0为24小时制 1为12小时制
 @param isEnglish 设置手环语言 0为汉语 1为英语
 */
- (void)setBindUnit:(int)unit andTimeType:(int)timeType isEnglish:(BOOL)isEnglish;


/**
 测试用方法,已废弃

 @param url 手环固件空升包的本地路径
 */
- (void)localOTAWithURL:(NSString *)url;




#pragma mark -- 固件升级


/**
 开始固件升级 保证为已连接状态时调用此方法空升手环

 @param path 手环固件包的本地地址
 @param progress 回调返回当前progress
 @param error 升级错误返回error
 */
- (void)startDFUWithFirmWarePath:(NSString *)path andProgressBlock:(void (^) (int progress))progress errorBlock:(void(^)(NSString *error))error;


/**
 升级过程中打断升级
 */
- (void)cancelDFU;

#pragma mark -- 蓝牙接受到需要处理数据


@end
