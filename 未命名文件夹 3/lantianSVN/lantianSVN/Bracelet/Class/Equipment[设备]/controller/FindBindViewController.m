//
//  FindBindViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/16.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "FindBindViewController.h"

@interface FindBindViewController ()

@end

@implementation FindBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    self.view.backgroundColor = kMainColor;
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"寻找手环",nil) backButton:YES shareButton:NO];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"findBindUnselected"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"findBindSelected"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(findBind) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.sd_layout.centerXIs(self.view.width / 2.)
    .topSpaceToView(self.view, 200 * kX)
    .widthIs(230 * kX)
    .heightIs(230 * kX);
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = kmaintextGrayColor;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.text = NSLocalizedString(@"请保持蓝牙开启,手环与手机处于连接状态",nil);
    topLabel.font = [UIFont systemFontOfSize:13];
    topLabel.numberOfLines = 0;
    [self.view addSubview:topLabel];
    topLabel.sd_layout.topSpaceToView(button, 45 * kX)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(40);
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = [UIFont systemFontOfSize:15];
    bottomLabel.text = NSLocalizedString(@"点击寻找手环,手环会震动提醒",nil);
    bottomLabel.numberOfLines = 0;
    [self.view addSubview:bottomLabel];
    bottomLabel.sd_layout.topSpaceToView(topLabel, 25 * kX)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(40);
}

- (void)findBind
{
    [[PZBlueToothManager sharedInstance] findBracelet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
