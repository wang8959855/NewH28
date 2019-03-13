//
//  SedentaryModel.h
//  Bracelet
//
//  Created by panzheng on 2017/3/27.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SedentaryModel : NSObject

//开始时间的时
@property (nonatomic, assign) int beginHour;

//开始时间的分
@property (nonatomic, assign) int beginMin;

//结束时间的时
@property (nonatomic, assign) int endHour;

//结束时间的分
@property (nonatomic, assign) int endMin;

//久坐多久后开始提醒,单位为分钟
@property (nonatomic, assign) int timeInteval;

//重复,与AlarmModel重复规则相同
@property (nonatomic, assign) int repeats;

@end
