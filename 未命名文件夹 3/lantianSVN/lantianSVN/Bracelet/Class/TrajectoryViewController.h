//
//  TrajectoryViewController.h
//  Bracelet
//
//  Created by panzheng on 2017/5/4.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "BaseViewController.h"
#import "TrajectoryModel.h"

@interface TrajectoryViewController : BaseViewController

@property (nonatomic, weak) UILabel *gpsStateLabel;

@property (nonatomic, weak) UILabel *distanceLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UILabel *speedLabel;

@property (nonatomic, weak) UIButton *beginBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) TrajectoryModel *model;

@property (nonatomic, weak) UIView * backView;

@end
