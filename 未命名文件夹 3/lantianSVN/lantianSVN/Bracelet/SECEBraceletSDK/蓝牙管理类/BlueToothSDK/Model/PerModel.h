//
//  PerModel.h
//  Wukong
//
//  Created by 迈诺科技 on 16/5/5.
//  Copyright © 2016年 huichenghe. All rights reserved.
//


#import <Foundation/Foundation.h>

//扫描返回数组内Model

@interface PerModel : NSObject
/**
 *  CBPeripheral对象，per.name可获得设备名称，per.identifier.UUIDString可获得设备UUID，可用于连接设备，断开设备
 */
@property (strong, nonatomic) CBPeripheral *per;

/**
 设备名后拼接后四位设备mac地址用已区分,已配对设备可能perName为nil
 */
@property (nonatomic, copy) NSString *perName;


@property (nonatomic, copy) NSString *mac;

/**
 *  搜索时设备的信号值，RSSI值为负，RSSI值越大，信号强度越好
 */
@property (assign, nonatomic) int RSSI;

@end
