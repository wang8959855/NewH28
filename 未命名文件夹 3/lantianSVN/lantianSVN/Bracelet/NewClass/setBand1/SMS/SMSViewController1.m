//
//  SMSViewController.m
//  test1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SMSViewController1.h"
#import "YHAppRemidViewController.h"

@interface SMSViewController1 ()

@property (weak, nonatomic) IBOutlet UISwitch *switchC;

@property (nonatomic, strong) NotifyModel *model;

@end

@implementation SMSViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getNotifyWithBlock:^(NotifyModel *notifyModel) {
        weakSelf.switchC.on =  notifyModel.SMSState;
        weakSelf.model = notifyModel;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)switchAction:(UISwitch *)sender {
    NSLog(@"on:%d",sender.isOn);
    if (!self.model) {
        sender.on = !sender.on;
        return;
    }
    self.model.SMSState = sender.on;
    [[PZBlueToothManager sharedInstance] setNotifyWithNotifyModel:self.model];
}

- (IBAction)otherSwitch:(UIButton *)sender {
    YHAppRemidViewController *vc = [[YHAppRemidViewController alloc] init];
    [self.vc.navigationController pushViewController:vc animated:YES];
}


@end
