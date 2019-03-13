//
//  DeviceCell.h
//  Bracelet
//
//  Created by panzheng on 2017/5/19.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerModel.h"

@interface DeviceCell : UITableViewCell

@property (nonatomic, assign) BOOL isConnected;

@property (nonatomic, weak) UIImageView *equipmentView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *macLabel;

@property (nonatomic, weak) UIButton *nameCopyButton;

@property (nonatomic, weak) UILabel *stateLabel;

@property (nonatomic, strong) PerModel *model;

@property (nonatomic, strong) CBPeripheral *per;

@end
