//
//  HeartRateSetViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/6/6.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "HeartRateSetViewController.h"
#import "TimeIntervelViewController.h"

@interface HeartRateSetViewController ()

@property (weak, nonatomic) UIImageView *HRImageView;

@property (strong,nonatomic) UISwitch *stateSwitch;

@property (strong, nonatomic) UIView *backView;

@property (assign, nonatomic) float timeIntervel;

@property (weak, nonatomic) UIView *timeBackView;

@property (weak, nonatomic) UILabel *timeLabel;

@end

@implementation HeartRateSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
    self.view.backgroundColor = kMainColor;
    
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getHeartRateStateWithBlock:^(int number) {
        weakSelf.stateSwitch.on = number;
        [weakSelf judgeShow];
    }];

}

- (void)loadUI {
    [self addNavWithTitle:NSLocalizedString(@"实时心率",nil) backButton:YES shareButton:NO];
    [self HRImageView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = kmaintextGrayColor;
    tipLabel.text = NSLocalizedString(@"请保持蓝牙开启,手环与手机处于连接状态",nil);
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    tipLabel.sd_layout.topSpaceToView(_HRImageView, 135 * kX)
    .centerXIs(ScreenW/2.)
    .widthIs(ScreenW)
    .heightIs(40);
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = kmainBackgroundColor;
    [self.view addSubview:_backView];
    _backView.sd_layout.bottomSpaceToView(self.view, 75 * kX)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(76);
    
    _stateSwitch = [[UISwitch alloc] init];
    _stateSwitch.onTintColor = kmainLightColor;
    [_stateSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
    [_backView addSubview:_stateSwitch];
    _stateSwitch.sd_layout.rightSpaceToView(_backView, 20 * kX)
    .centerYIs(_backView.height/2.)
    .widthIs(50 * kX)
    .heightIs(30 * kX);
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = kmaintextGrayColor;
    [_backView addSubview:topLine];
    topLine.sd_layout.topEqualToView(_backView)
    .leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .heightIs(0.5);
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = kmaintextGrayColor;
    [_backView  addSubview:bottomLine];
    bottomLine.sd_layout.bottomEqualToView(_backView)
    .leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .heightIs(0.5);
    
    UILabel *tipLabel1 = [[UILabel alloc] init];
    tipLabel1.text = NSLocalizedString(@"开启自动检测心率",nil);
    tipLabel1.textColor = [UIColor whiteColor];
    tipLabel1.font = [UIFont systemFontOfSize:15];
    tipLabel1.numberOfLines = 0;
    [_backView addSubview:tipLabel1];
    [tipLabel1 sizeToFit];
    tipLabel1.sd_layout.leftSpaceToView(_backView, 18 * kX)
    .topSpaceToView(_backView, 0)
    .rightSpaceToView(_stateSwitch, 3)
    .heightIs(_backView.height/2.);
    
    UILabel *tipLabel2 = [[UILabel alloc] init];
    tipLabel2.text = NSLocalizedString(@"开启后,手环会自动检测心率",nil);
    tipLabel2.textColor = kmaintextGrayColor;
    tipLabel2.font = [UIFont systemFontOfSize:13];
    [tipLabel2 sizeToFit];
    tipLabel2.numberOfLines = 0;
    [_backView addSubview:tipLabel2];
    tipLabel2.sd_layout.leftSpaceToView(_backView, 18 * kX)
    .bottomEqualToView(_backView)
    .rightSpaceToView(_stateSwitch, 3)
    .heightIs(_backView.height/2.);
    

}

- (void)switchValueChanged
{
    [self judgeShow];
    [[PZBlueToothManager sharedInstance] setHeartRateStateWithState:_stateSwitch.isOn];
}

- (void)judgeShow
{
    if (_stateSwitch.isOn)
    {
        self.HRImageView.image = [UIImage imageNamed:@"HROpen"];
        self.backView.backgroundColor = kmainBackgroundColor;
        _timeBackView.backgroundColor = kmainBackgroundColor;
        _timeBackView.userInteractionEnabled = YES;
        [self queryHeartTime];

    }
    else
    {
        self.HRImageView.image = [UIImage imageNamed:@"HROff"];
        self.backView.backgroundColor = kmainLightColor;
        _timeBackView.backgroundColor = kmainLightColor;
        _timeBackView.userInteractionEnabled = NO;
    }
}

- (void)setTimeIntervel:(float)timeIntervel
{
    if (timeIntervel == 3)
    {
        _timeIntervel = 2.5;
    }else
    {
        _timeIntervel = timeIntervel;
    }
    
    if (_stateSwitch.isOn) {
        [self timeBackView];
        self.timeLabel.text = [NSString stringWithFormat:@"%g %@",_timeIntervel,NSLocalizedString(@"分钟", nil)];
        [self.timeLabel sizeToFit];
        self.timeLabel.sd_layout.widthIs(self.timeLabel.width)
        .heightIs(self.timeLabel.height);
    }
}

- (UIView *)timeBackView
{
    if (!_timeBackView)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kmainBackgroundColor;
        [self.view addSubview:view];
        _timeBackView = view;
        _timeBackView.sd_layout.bottomSpaceToView(_backView, 0)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(56 * kX);
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = kmaintextGrayColor;
        [view addSubview:topLine];
        topLine.frame = CGRectMake(0, 0, ScreenW, 0.5);
        
        UILabel * label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = NSLocalizedString(@"测试频率", nil);
        [label sizeToFit];
        [view addSubview:label];
        label.sd_layout.leftSpaceToView(_timeBackView, 18 * kX)
        .centerYIs(_timeBackView.height/2.)
        .widthIs(label.width);
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.text = @">";
        [rightLabel sizeToFit];
        [view addSubview:rightLabel];
        rightLabel.sd_layout.rightSpaceToView(view, 20 * kX)
        .centerYIs(view.height/2.)
        .widthIs(rightLabel.width)
        .heightIs(rightLabel.height);
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:timeLabel];
        timeLabel.sd_layout.rightSpaceToView(rightLabel, 8)
        .centerYIs(view.height/2.);
        _timeLabel = timeLabel;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(timeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        button.sd_layout.topEqualToView(view)
        .leftEqualToView(view)
        .rightEqualToView(view)
        .bottomEqualToView(view);
    }
    return _timeBackView;
}

- (void)timeButtonClick{
    TimeIntervelViewController *timeVC = [[TimeIntervelViewController alloc] init];
    kWEAKSELF;
    timeVC.block = ^(CGFloat min) {
        weakSelf.timeIntervel = min;
    };
    [self.navigationController pushViewController:timeVC animated:YES];
}

- (void)queryHeartTime
{
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getHeartRateTimeinterverWithBlock:^(int number) {
        weakSelf.timeIntervel = number;
    }];
}

- (UIImageView *)HRImageView
{
    if (!_HRImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"HROpen"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView.sd_layout.topSpaceToView(self.view, 150 * kX)
        .centerXIs(ScreenW/2.)
        .widthIs(70 * kX)
        .heightIs(70 * kX);
        _HRImageView = imageView;
    }
    return _HRImageView;
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
