//
//  ActualDataModel.h
//  Bracelet
//
//  Created by panzheng on 2017/3/23.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActualDataModel : NSObject


/**
 当天步数
 */
@property (nonatomic ,assign) int steps;


/**
 当天心率
 */
@property (nonatomic, assign) int hr;


/**
 收缩压 无血压功能手环此值无效
 */
@property (nonatomic, assign) int bph;

/**
 舒张压 无血压功能手环此值无效
 */
@property (nonatomic, assign) int bpl;


/**
 运动距离,单位为米
 */
@property (nonatomic, assign) int distance;


/**
 卡路里小号,单位为Kcal
 */
@property (nonatomic, assign) int calories;

@end
