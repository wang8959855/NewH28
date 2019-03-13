//
//  oneDaySleepModel.h
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/2/28.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface oneDaySleepModel : NSObject

@property (nonatomic ,assign) int beginTime;

@property (nonatomic, assign) int endTime;

@property (nonatomic, strong) NSData *sleepData;

@property (nonatomic, assign) int deepSleepTime;

@property (nonatomic, assign) int lightSleepTime;

@property (nonatomic, assign) int awakeSleepTime;

@property (nonatomic, assign) int totalSleepTime;

@property (nonatomic, assign) int timeSeconds;

@property (nonatomic, strong) NSString * name;

+ (NSString *)VERSION;

@end
