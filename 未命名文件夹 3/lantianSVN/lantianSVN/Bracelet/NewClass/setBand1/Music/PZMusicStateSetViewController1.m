//
//  PZMusicStateSetViewController.m
//  test1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PZMusicStateSetViewController1.h"

@interface PZMusicStateSetViewController1 ()

@property (weak, nonatomic) IBOutlet UISwitch *switchC;

@end

@implementation PZMusicStateSetViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWEAKSELF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)switchAction:(UISwitch *)sender {
    NSLog(@"on:%d",sender.isOn);
}

@end
