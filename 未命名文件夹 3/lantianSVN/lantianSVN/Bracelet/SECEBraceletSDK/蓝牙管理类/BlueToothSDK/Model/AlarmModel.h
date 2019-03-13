//
//  AlarmModel.h
//  Bracelet
//
//  Created by SZCE on 16/2/2.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmModel : NSObject

/**
 *  闹钟id号 从0 - 7最多8个
 */
@property (nonatomic, assign) int idNum;

/**
 *  小时
 */
@property (nonatomic, assign) int hour;

/**
 *  分钟
 */
@property (nonatomic, assign) int minute;


//闹钟状态 0为关闭,1为开启,2为删除 设置为删除后仍然可以查询,返回状态为2删除
@property (nonatomic, assign) int state;


/**
      日 六 五 四 三 二 一
  重复 0  0  0 0 0  0  0 0 重复值为一个字节,8位最低位默认为0,其他从低位到高位为周一,周二,周三,周四,周五,周六,周日,1为当天开启,0为当天关闭
 */
@property (nonatomic, assign) int repeats;


@end
