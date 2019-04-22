//
//  HeartRateSetViewController.m
//  test1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HeartRateSetViewController1.h"
#import "TimeIntervelViewController.h"

@interface HeartRateSetViewController1 ()

@property (weak, nonatomic) IBOutlet UISwitch *switchC;

@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;


@property (nonatomic, assign) CGFloat minute;

@end

@implementation HeartRateSetViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getHeartRateStateWithBlock:^(int number) {
        weakSelf.switchC.on = number;
        if (number) {
            [[PZBlueToothManager sharedInstance] getHeartRateTimeinterverWithBlock:^(int number) {
                weakSelf.minute = number;
                if (number == 3) {
                    weakSelf.minute = 2;
                }
                weakSelf.minuteLabel.text = [NSString stringWithFormat:@"%.1f分钟",weakSelf.minute];
            }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)switchAction:(UISwitch *)sender {
    NSLog(@"on:%d",sender.isOn);
    [[PZBlueToothManager sharedInstance] setHeartRateStateWithState:sender.on];
}

- (IBAction)timeButtonClick
{
    TimeIntervelViewController *timeVC = [[TimeIntervelViewController alloc] init];
    timeVC.min = self.minute;
//    kWEAKSELF;
//    timeVC.block = ^(CGFloat min) {
//        weakSelf.minute = min;
//        if (weakSelf.minute == 3) {
//            weakSelf.minute = 2.5;
//        }
//        weakSelf.minuteLabel.text = [NSString stringWithFormat:@"%.1f分钟",min];
//    };
    [self.vc.navigationController pushViewController:timeVC animated:YES];
}

@end
