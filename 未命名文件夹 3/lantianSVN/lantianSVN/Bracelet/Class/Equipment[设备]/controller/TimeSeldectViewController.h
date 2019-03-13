//
//  TimeSeldectViewController.h
//  Bracelet
//
//  Created by panzheng on 2017/5/17.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^timeBlock)(int hour, int min);

@interface TimeSeldectViewController : BaseViewController

@property (nonatomic, copy) timeBlock block;

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, assign) int hour;

@property (nonatomic, assign) int min;

@end
