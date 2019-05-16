//
//  CallViewController.m
//  test1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CallViewController1.h"

@interface CallViewController1 ()

@property (weak, nonatomic) IBOutlet UISwitch *switchC;

@property (nonatomic, strong) NotifyModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation CallViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getNotifyWithBlock:^(NotifyModel *notifyModel) {
        weakSelf.switchC.on =  notifyModel.CallState;
        weakSelf.model = notifyModel;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstraint.constant = SafeAreaTopHeight;
}

- (IBAction)switchAction:(UISwitch *)sender {
    NSLog(@"on:%d",sender.isOn);
    if (!self.model) {
        sender.on = !sender.on;
        return;
    }
    self.model.CallState = sender.on;
    [[PZBlueToothManager sharedInstance] setNotifyWithNotifyModel:self.model];
}


@end
