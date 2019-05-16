//
//  DisturbViewController.m
//  test1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DisturbViewController1.h"
#import "TimeSeldectViewController.h"

@interface DisturbViewController1 ()

@property (weak, nonatomic) IBOutlet UISwitch *switchC;

@property (nonatomic, strong) DisturbModel *model;

@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;


@end

@implementation DisturbViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getDisturbModelWithBlock:^(DisturbModel *disturbModel) {
        weakSelf.model = disturbModel;
        weakSelf.switchC.on = disturbModel.State;
        weakSelf.beginLabel.text = [NSString stringWithFormat:@"%02d:%02d",disturbModel.beginHour,disturbModel.beginMin];
        weakSelf.endLabel.text = [NSString stringWithFormat:@"%02d:%02d",disturbModel.endHour,disturbModel.endMin];
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
    self.model.State = sender.on;
    [[PZBlueToothManager sharedInstance] setDisturbWithDisturbModel:self.model];
}

//开始时间
- (IBAction)beginAction:(UIButton *)sender {
    TimeSeldectViewController *beginVC = [[TimeSeldectViewController alloc] init];
    beginVC.titleString = NSLocalizedString(@"开始",nil);
    beginVC.hour = self.model.beginHour;
    beginVC.min = self.model.beginMin;
    kWEAKSELF;
    beginVC.block = ^(int hour, int min) {
        weakSelf.model.beginHour = hour;
        weakSelf.model.beginMin = min;
        [weakSelf updateTimeLabel];
        [[PZBlueToothManager sharedInstance] setDisturbWithDisturbModel:self.model];
    };
    [self.vc.navigationController pushViewController:beginVC animated:YES];
}

//结束时间
- (IBAction)endAction:(UIButton *)sender {
    TimeSeldectViewController *endVC = [[TimeSeldectViewController alloc] init];
    endVC.titleString = NSLocalizedString(@"结束",nil);
    endVC.hour = self.model.endHour;
    endVC.min = self.model.endMin;
    kWEAKSELF;
    endVC.block = ^(int hour, int min) {
        weakSelf.model.endHour = hour;
        weakSelf.model.endMin = min;
        [weakSelf updateTimeLabel];
        [[PZBlueToothManager sharedInstance] setDisturbWithDisturbModel:self.model];
    };
    [self.vc.navigationController pushViewController:endVC animated:YES];
}

- (void)updateTimeLabel{
    self.beginLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.model.beginHour,self.model.beginMin];
    self.endLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.model.endHour,self.model.endMin];
}

@end
