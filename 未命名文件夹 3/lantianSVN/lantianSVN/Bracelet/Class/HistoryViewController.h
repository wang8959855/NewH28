//
//  HistoryViewController.h
//  Bracelet
//
//  Created by panzheng on 2017/6/1.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "BaseViewController.h"
#import "TrajectoryModel.h"

@interface HistoryViewController : BaseViewController

@property (nonatomic, copy) NSDictionary *dictionary;

@property (nonatomic, weak) UILabel *totalDistanceLabel;

@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, weak) UILabel *costLabel;

@property (nonatomic, strong) UITableView *tableView;

@end
