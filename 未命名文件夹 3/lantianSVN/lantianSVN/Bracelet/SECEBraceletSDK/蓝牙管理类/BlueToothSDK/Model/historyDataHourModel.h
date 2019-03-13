//
//  historyDataHourModel.h
//  Bracelet
//
//  Created by panzheng on 2017/3/23.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface historyDataHourModel : NSObject


/**
 年的后两位
 */
@property (nonatomic, assign) int yeah;


/**
 月
 */
@property (nonatomic, assign) int month;


/**
 日
 */
@property (nonatomic, assign) int day;

//时
@property (nonatomic, assign) int hour;

//静息心率,当前版本此值无效
@property (nonatomic, assign) int calmHR;

//当前小时总步数
@property (nonatomic, assign) int totalSteps;

//状态数组,1为计步,17为开始睡眠,18为清醒,19为浅睡,20为深睡 每10分钟一个状态,数组内为6个值
@property (nonatomic, strong) NSArray*stateArray;

//心率数组 每小时值为24个,每2.5分钟一个心率值,若心率检测设置为2.5分钟以上检测一次,则中间无值部分补0
@property (nonatomic, strong) NSArray* heartArray;

//收缩压数组,不支持血压的手环此值无效
@property (nonatomic, strong) NSArray * BPHArray;

//舒张压数组,不支持血压的手环此值无效
@property (nonatomic, strong) NSArray * BPLArray;

//计步数组,每10分钟一个值
@property (nonatomic, strong) NSArray *stepArray;

@end
