//
//  TaiwanViewController.m
//  test1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TaiwanViewController1.h"

@interface TaiwanViewController1 ()

@property (weak, nonatomic) IBOutlet UISwitch *switchC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation TaiwanViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getLiftHandStateWithBlock:^(int number) {
        weakSelf.switchC.on = number;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstraint.constant = SafeAreaTopHeight;
}

- (IBAction)switchAction:(UISwitch *)sender {
    NSLog(@"on:%d",sender.isOn);
    [[PZBlueToothManager sharedInstance] setLiftHandStateWithState:sender.on];
}

@end
