//
//  WorkOutView.h
//  Bracelet
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "BaseView.h"
#import "TrajectoryModel.h"

@interface WorkOutView : BaseView

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, weak) UILabel *gpsStateLabel;

@property (nonatomic, weak) UILabel *distanceLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UILabel *speedLabel;

@property (nonatomic, strong) UILabel *locus;

@property (nonatomic, weak) UIButton *beginBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) TrajectoryModel *model;

@property (nonatomic, weak) UIView * backView;

@end
