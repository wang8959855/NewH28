//
//  AlarmViewController.h
//  keyBand
//
//  Created by 迈诺科技 on 15/11/20.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController1 : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *alarmTableVIew;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UIViewController *vc;

@end
