//
//  HeartRateManualView.h
//  Bracelet
//
//  Created by apple on 2018/8/12.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "BaseView.h"
#import "HeartRateCircleView.h"

@interface HeartRateManualView : BaseView

@property (nonatomic, strong) HeartRateCircleView *circleView;
@property (nonatomic, strong) UIViewController *controller;

@property (strong, nonatomic) UIButton *targetBtn;

@end
