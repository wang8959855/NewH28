//
//  FangdiuViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/20.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "FangdiuViewController.h"

@interface FangdiuViewController ()

@end

@implementation FangdiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleLabel.text = NSLocalizedString(@"防丢提醒", nil);
}
- (void)dealloc
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    WeakSelf;
//    [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:SystemAlarmType_Antiloss StateBlock:^(int index, int state) {
//        if (index == SystemAlarmType_Antiloss)
//        {
//            [weakSelf.fangdiuSwitch setOn:state animated:YES];
//        }
//    }];
}
- (IBAction)swithValueChanged:(UISwitch *)sender
{
//    [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:SystemAlarmType_Antiloss State:sender.isOn];
//    [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:SystemAlarmType_Antiloss StateBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
