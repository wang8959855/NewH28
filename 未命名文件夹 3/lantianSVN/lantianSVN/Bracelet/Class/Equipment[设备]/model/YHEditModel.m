//
//  YHEditModel.m
//  Bracelet
//
//  Created by xieyingze on 17/1/3.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "YHEditModel.h"

@implementation YHEditModel
-(instancetype)init
{
    if (self = [super init]) {
        
        self.ImageArr = [NSMutableArray array];
        
        self.titleArr = [NSMutableArray array];
        
//        self.isOn = [NSMutableArray array];
    }
    return self;
}
@end
