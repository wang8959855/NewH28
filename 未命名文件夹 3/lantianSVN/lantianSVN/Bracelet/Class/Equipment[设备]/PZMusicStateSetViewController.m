//
//  PZMusicStateSetViewController.m
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/3/6.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "PZMusicStateSetViewController.h"

@interface PZMusicStateSetViewController ()

@property (nonatomic, weak) UIImageView *musicImageView;

@property (strong, nonatomic) UIView *backView;

@property (strong,nonatomic) UISwitch *stateSwitch;

@end

@implementation PZMusicStateSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kMainColor;
    [self loadUI];
    // Do any additional setup after loading the view.
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"音乐控制",nil) backButton:YES shareButton:NO];
    [self musicImageView];
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = kmaintextGrayColor;
    tipLabel.text = NSLocalizedString(@"请保持蓝牙开启,手环与手机处于连接状态",nil);
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    tipLabel.sd_layout.topSpaceToView(_musicImageView, 135 * kX)
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
    _stateSwitch.on = [XXDeviceInfomation isMusicControl];
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
    tipLabel1.text = NSLocalizedString(@"开启手环控制手机音乐",nil);
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
    tipLabel2.text = NSLocalizedString(@"开启后,可以直接手环控制音乐播放",nil);
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
    [XXDeviceInfomation setMusicControlState:self.stateSwitch.isOn];
    [self judgeShow];
    if (_stateSwitch.isOn) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"music://"]];
    };
}

- (void)judgeShow
{
    if (_stateSwitch.isOn)
    {
        self.musicImageView.image = [UIImage imageNamed:@"musicOpen"];
        self.backView.backgroundColor = kmainBackgroundColor;
    }
    else
    {
        self.musicImageView.image = [UIImage imageNamed:@"musicOff"];
        self.backView.backgroundColor = kmainLightColor;
    }
    
}


- (UIImageView *)musicImageView
{
    if (!_musicImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([XXDeviceInfomation isMusicControl])
        {
            imageView.image = [UIImage imageNamed:@"musicOpen"];
        }else
        {
            imageView.image = [UIImage imageNamed:@"musicOff"];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView.sd_layout.topSpaceToView(self.view, 150 * kX)
        .centerXIs(ScreenW/2.)
        .widthIs(70 * kX)
        .heightIs(70 * kX);
        _musicImageView = imageView;
    }
    return _musicImageView;
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
