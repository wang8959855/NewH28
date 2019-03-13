//
//  AlarmCell.h
//  Bracelet
//
//  Created by SZCE on 16/1/21.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmModel.h"

@class AlarmCell;

//点击按钮一个回调
typedef void(^ActionButtonHandle)(UIButton *button, AlarmCell *cell);
//开始滑动回调
typedef void(^BeginSwipeHandle)(AlarmCell *cell);

typedef void(^SwitchButtonHandle)(UISwitch *sw,AlarmCell *cell);

@interface AlarmCell : UITableViewCell


/**
 *  模型数据
 */
@property (nonatomic, strong) AlarmModel *model;
//@property (nonatomic, strong) NSDictionary *dict;

/**
 *  时间标签
 */
@property (nonatomic, weak) UILabel *timeLabel;

/**
 *  周期标签
 */
@property (nonatomic, weak) UILabel *cycleLabel;

/**
 *  开关按钮
 */

/**
 *  设置按钮
 *  @param handle    按钮点击的回调
 */
- (void)addActionButtonHandle:(ActionButtonHandle)handle;

//设置开始拖动的回调
- (void)setBeginSwipeHandle:(BeginSwipeHandle)handle;

- (void)setSwithButtonHandle:(SwitchButtonHandle)handle;
@end
