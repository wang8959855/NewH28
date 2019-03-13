//
//  AlarmRepeatViewController.h
//  Bracelet
//
//  Created by panzheng on 2017/5/15.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "BaseViewController.h"


@interface AlarmRepeatViewController : BaseViewController

typedef void(^repeatBlock)(int repeat);

@property (nonatomic, copy) repeatBlock block;

@property (nonatomic, assign) int repeat;

@end
