//
//  AlarmModel.m
//  Bracelet
//
//  Created by SZCE on 16/2/2.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "AlarmModel.h"

@implementation AlarmModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //设置默认值
        self.idNum = 0;
        self.hour = 0;
        self.minute = 0;
    }
    return self;
}



/**
 *  重写coder,从二进制转换回来
 *
 *  @param coder <#coder description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idNum = [coder decodeIntForKey:@"idNum"];
        self.hour = [coder decodeIntForKey:@"hour"];
        self.minute = [coder decodeIntForKey: @"minute"];
    }
    return self;
}

/**
 *  NSCoding的代理 将self.xx 转换成2进制
 *
 *  @param aCoder <#aCoder description#>
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.idNum forKey:@"idNum"];
    [aCoder encodeInt:self.hour forKey:@"hour"];
    [aCoder encodeInt:self.minute forKey:@"minute"];
}

@end
