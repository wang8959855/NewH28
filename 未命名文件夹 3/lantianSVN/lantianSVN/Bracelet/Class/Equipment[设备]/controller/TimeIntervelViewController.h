//
//  TimeIntervelViewController.h
//  Bracelet
//
//  Created by panzheng on 2017/6/27.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^timeBlock)(CGFloat min);

@interface TimeIntervelViewController : BaseViewController

@property (nonatomic, copy) timeBlock block;

@property (nonatomic, assign) int min;



@end
