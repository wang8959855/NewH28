//
//  HIstoryTableViewCell.h
//  Bracelet
//
//  Created by panzheng on 2017/6/1.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrajectoryModel.h"

@interface HIstoryTableViewCell : UITableViewCell

@property (nonatomic, strong) TrajectoryModel *model;

@property (nonatomic, weak) UILabel *distanceLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UILabel *durationLabel;

@property (nonatomic, weak) UILabel *speedLabel;

@end
