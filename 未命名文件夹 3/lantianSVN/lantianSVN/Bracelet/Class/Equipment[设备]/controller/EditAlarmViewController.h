//
//  EditAlarmViewController.h
//  Bracelet
//
//  Created by SZCE on 16/1/21.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmModel.h"
#import "BaseViewController.h"

@interface EditAlarmViewController : BaseViewController

/**
 *  选择的行数
 */

@property (nonatomic ,strong) AlarmModel *alarmModel;

@end
