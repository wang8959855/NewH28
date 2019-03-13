//
//  TrajectoryModel.m
//  Bracelet
//
//  Created by panzheng on 2017/5/5.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "TrajectoryModel.h"

@implementation TrajectoryModel

- (NSMutableArray *)locationArray
{
    if (!_locationArray)
    {
        _locationArray = [[NSMutableArray alloc] init];
    }
    return _locationArray;
}

+ (NSString *)VERSION {
    return @"1.0.0";
}

@end
