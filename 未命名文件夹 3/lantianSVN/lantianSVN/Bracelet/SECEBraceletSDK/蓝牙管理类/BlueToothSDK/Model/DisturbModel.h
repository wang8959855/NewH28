//
//  DisturbModel.h
//  Bracelet
//
//  Created by panzheng on 2017/3/29.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisturbModel : NSObject

//勿扰模式开关
@property (nonatomic, assign) BOOL State;

//勿扰模式开始时间时
@property (nonatomic, assign) int beginHour;

//勿扰模式开始时间分
@property (nonatomic, assign) int beginMin;

//勿扰模式结束时间时
@property (nonatomic, assign) int endHour;

//污染模式结束时间分
@property (nonatomic, assign) int endMin;

@end
