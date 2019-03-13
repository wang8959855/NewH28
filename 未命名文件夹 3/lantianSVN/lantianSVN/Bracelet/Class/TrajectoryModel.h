//
//  TrajectoryModel.h
//  Bracelet
//
//  Created by panzheng on 2017/5/5.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrajectoryModel : NSObject

@property (nonatomic, assign) int beginTime;

@property (nonatomic, assign) int duration;

@property (nonatomic, strong) NSMutableArray *locationArray;

@property (nonatomic, assign) float distance;

@property (nonatomic, strong) NSData *arrayData;

+ (NSString *)VERSION;

@end
