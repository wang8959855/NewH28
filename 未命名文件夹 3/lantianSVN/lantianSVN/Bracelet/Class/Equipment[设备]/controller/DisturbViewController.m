//
//  DisturbViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/16.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "DisturbViewController.h"
#import "TimeSeldectViewController.h"

@interface DisturbViewController ()

@property (nonatomic, weak) UIImageView *disturbImageView;

@property (strong, nonatomic) UILabel *beginTimeLabel;

@property (strong, nonatomic) UILabel *endTimeLabel;

@property (strong, nonatomic) DisturbModel *model;

@property (strong,nonatomic) UISwitch *stateSwitch;

@property (strong, nonatomic) UIView *backView;
@end

@implementation DisturbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    kWEAKSELF
    [[PZBlueToothManager sharedInstance] getDisturbModelWithBlock:^(DisturbModel *disturbModel) {
        weakSelf.model = disturbModel;
    }];
    [self loaUI];

}

- (void)loaUI
{
    [self addNavWithTitle:NSLocalizedString(@"勿扰模式",nil) backButton:YES shareButton:NO];
    [self disturbImageView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = kmaintextGrayColor;
    tipLabel.text = NSLocalizedString(@"请保持蓝牙开启,手环与手机处于连接状态",nil);
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    tipLabel.sd_layout.topSpaceToView(_disturbImageView, 135 * kX)
    .centerXIs(ScreenW/2.)
    .widthIs(ScreenW)
    .heightIs(40);
    
    for (int i = 0 ; i < 2; i ++)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = kmainBackgroundColor;
        [self.view addSubview:backView];
        backView.sd_layout.topSpaceToView(_disturbImageView, 195 * kX + 60 * kX * i)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(60 * kX);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kmaintextGrayColor;
        [backView addSubview:lineView];
        lineView.sd_layout.topEqualToView(backView)
        .leftEqualToView(backView)
        .rightEqualToView(backView)
        .heightIs(0.5);
        
        if (i == 0)
        {
            _beginTimeLabel = [[UILabel alloc] init];
            _beginTimeLabel.textColor = [UIColor whiteColor];
            _beginTimeLabel.text = @"00:00";
            _beginTimeLabel.font = [UIFont systemFontOfSize:25];
            _beginTimeLabel.textAlignment = NSTextAlignmentRight;
            [backView addSubview:_beginTimeLabel];
            _beginTimeLabel.sd_layout.rightSpaceToView(backView, 65 * kX)
            .centerYIs(backView.height/2.)
            .widthIs(200)
            .heightIs(30);
            
        }
        if (i == 1)
        {
            _endTimeLabel = [[UILabel alloc] init];
            _endTimeLabel.textColor = [UIColor whiteColor];
            _endTimeLabel.text = @"00:00";
            _endTimeLabel.font = [UIFont systemFontOfSize:25];
            _endTimeLabel.textAlignment = NSTextAlignmentRight;
            [backView addSubview:_endTimeLabel];
            _endTimeLabel.sd_layout.rightSpaceToView(backView, 65 * kX)
            .centerYIs(backView.height/2.)
            .widthIs(200)
            .heightIs(30);
        }
       
        
        NSArray *titleArray = @[NSLocalizedString(@"开始",nil),NSLocalizedString(@"结束",nil)];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = titleArray[i];
        [titleLabel sizeToFit];
        [backView addSubview:titleLabel];
        titleLabel.sd_layout.leftSpaceToView(backView, 15)
        .centerYIs(backView.height / 2.)
        .widthIs(titleLabel.width)
        .heightIs(30);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@">" forState:UIControlStateNormal];
        [backView addSubview:button];
        button.sd_layout.rightEqualToView(backView)
        .topEqualToView(backView)
        .leftEqualToView(backView)
        .bottomEqualToView(backView);
    }
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = kmainBackgroundColor;
    [self.view addSubview:_backView];
    _backView.sd_layout.topSpaceToView(_disturbImageView, (195 + 120) * kX)
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
    tipLabel1.text = NSLocalizedString(@"开启勿扰模式",nil);
    tipLabel1.textColor = [UIColor whiteColor];
    tipLabel1.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:tipLabel1];
    [tipLabel1 sizeToFit];
    tipLabel1.sd_layout.leftSpaceToView(_backView, 18 * kX)
    .topSpaceToView(_backView, 0)
    .rightSpaceToView(_stateSwitch, 3)
    .heightIs(_backView.height/2.);
    
    UILabel *tipLabel2 = [[UILabel alloc] init];
    tipLabel2.text = NSLocalizedString(@"开启后,在时间段内,手环不会震动提醒",nil);
    tipLabel2.textColor = kmaintextGrayColor;
    tipLabel2.font = [UIFont systemFontOfSize:13];
    tipLabel2.numberOfLines = 0;
    [tipLabel2 sizeToFit];
    [_backView addSubview:tipLabel2];
    tipLabel2.sd_layout.leftSpaceToView(_backView, 18 * kX)
    .bottomEqualToView(_backView)
    .rightSpaceToView(_stateSwitch, 3)
    .heightIs(_backView.height/2.);
    


    
}

- (void)switchValueChanged
{
    self.model.State = self.stateSwitch.isOn;
    [self judgeShow];
    [[PZBlueToothManager sharedInstance] setDisturbWithDisturbModel:self.model];
}


- (void)buttonClick:(UIButton *)button
{
    switch (button.tag)
    {
        case 100:
        {
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
            [self.navigationController pushViewController:beginVC animated:YES];
        }
            break;
        case 101:
        {
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
            [self.navigationController pushViewController:endVC animated:YES];
        }
            break;
                default:
            break;
    }
}

- (void)setModel:(DisturbModel *)model
{
    _model = model;
    self.stateSwitch.on = model.State;
    [self updateTimeLabel];
    [self judgeShow];
}

- (void)judgeShow
{
    if (_stateSwitch.isOn)
    {
        self.disturbImageView.image = [UIImage imageNamed:@"disturbOpen"];
        self.backView.backgroundColor = kmainBackgroundColor;
    }
    else
    {
        self.disturbImageView.image = [UIImage imageNamed:@"disturbOff"];
        self.backView.backgroundColor = kmainLightColor;
    }
    
}

- (void)updateTimeLabel
{
    self.beginTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.model.beginHour,self.model.beginMin];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.model.endHour,self.model.endMin];
}

- (UIImageView *)disturbImageView
{
    if (!_disturbImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"disturbOpen"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView.sd_layout.topSpaceToView(self.view, 150 * kX)
        .centerXIs(ScreenW/2.)
        .widthIs(70 * kX)
        .heightIs(70 * kX);
        _disturbImageView = imageView;
    }
    return _disturbImageView;
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
