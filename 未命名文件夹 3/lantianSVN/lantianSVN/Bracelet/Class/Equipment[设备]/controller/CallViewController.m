//
//  CallViewController.m
//  Bracelet
//
//  Created by SZCE on 16/1/19.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "CallViewController.h"
#import "XXDeviceInfomation.h"

@interface CallViewController ()

/**
 *  来电提醒文字标签
 */

/**
 *  开关按钮
 */

/**
 *  显示选择数据的标签
 */
@property (weak, nonatomic)  UILabel *messageLabel;

/**
 *  滑块控件
 */
@property (weak, nonatomic)  UISlider *mySlide;




@property (weak, nonatomic) UIImageView *phoneImageView;

@property (strong,nonatomic) UISwitch *stateSwitch;

@property (strong, nonatomic) UIView *backView;
/**
 *  进度控件
 */

@end

@implementation CallViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self LoadUI];
    self.view.backgroundColor = kMainColor;

    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getNotifyWithBlock:^(NotifyModel *notifyModel) {
        weakSelf.model = notifyModel;
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigation

- (void)setModel:(NotifyModel *)model
{
    _model = model;
    [self loadTipLabelUIWithSecond:self.model.callDelay];
    [self.mySlide setValue:self.model.callDelay animated:YES];
    self.stateSwitch.on = model.CallState;
    [self judgeShow];
}

#pragma mark - action

- (void)clickSure
{
    [[PZBlueToothManager sharedInstance] setNotifyWithNotifyModel:self.model];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchValueChanged
{
    self.model.CallState = self.stateSwitch.isOn;
    [self judgeShow];
}

#pragma mark - 布局
- (void)LoadUI
{
    [self addNavWithTitle:NSLocalizedString(@"来电提醒",nil) backButton:YES shareButton:NO];
    [self phoneImageView];
    [self messageLabel];
    [self mySlide];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    [sureButton sizeToFit];
    [sureButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    sureButton.frame = CGRectMake(ScreenW - sureButton.width - 20, 7 + 20, sureButton.width, 30);

    
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
    tipLabel1.text = NSLocalizedString(@"开启手机来电提醒",nil);
    tipLabel1.textColor = [UIColor whiteColor];
    tipLabel1.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:tipLabel1];
    tipLabel1.numberOfLines = 0;
    [tipLabel1 sizeToFit];
    tipLabel1.sd_layout.leftSpaceToView(_backView, 18 * kX)
    .topSpaceToView(_backView, 0)
    .rightSpaceToView(_stateSwitch, 3)
    .heightIs(_backView.height/2.);
    
    UILabel *tipLabel2 = [[UILabel alloc] init];
    tipLabel2.text = NSLocalizedString(@"开启后,手机来电话时,手环会震动提醒",nil);
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

/**
 *  文字提醒控件
 */
- (void)loadTipLabelUIWithSecond:(int)second
{
    
    NSString *str0 = NSLocalizedString(@"来电", nil);
    NSString *str1 = NSLocalizedString(@"秒后开始震动", nil);
    _messageLabel.text = [NSString stringWithFormat:@"%@%d%@",str0,second,str1];
}

/**
 *  滑块控件
 */

#pragma mark - private

- (void)backBarButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)slideChange:(UISlider *)slide
{
    [self loadTipLabelUIWithSecond:slide.value];
    self.model.callDelay = slide.value;
}

- (void)judgeShow
{
    if (_stateSwitch.isOn)
    {
        self.phoneImageView.image = [UIImage imageNamed:@"phoneOpen"];
        self.mySlide.alpha = 1;
        self.mySlide.userInteractionEnabled = YES;
        self.backView.backgroundColor = kmainBackgroundColor;
    }
    else
    {
        self.phoneImageView.image = [UIImage imageNamed:@"phoneOff"];
        self.mySlide.alpha = 0.5;
        self.mySlide.userInteractionEnabled = NO;
        self.backView.backgroundColor = kmainLightColor;
    }
}


#pragma mark -- GET

- (UIImageView *)phoneImageView
{
    if (!_phoneImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"phoneOpen"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView.sd_layout.topSpaceToView(self.view, 150 * kX)
        .centerXIs(self.view.frame.size.width/2.)
        .widthIs(70 * kX)
        .heightIs(70 * kX);
        _phoneImageView = imageView;
    }
    return _phoneImageView;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:label];
        label.sd_layout.topSpaceToView(_phoneImageView, 59 * kX)
        .centerXIs(self.view.frame.size.width/2.)
        .widthIs(self.view.frame.size.width)
        .heightIs(18);
        _messageLabel = label;
    }
    return _messageLabel;
}

- (UISlider *)mySlide
{
    if (!_mySlide)
    {
        UISlider *slide = [[UISlider alloc] init];
        [slide setThumbImage:[UIImage imageNamed:@"slideButton"] forState:UIControlStateNormal];
        [slide setMinimumTrackImage:[[UIImage imageNamed:@"call_corner_blue"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch] forState:(UIControlStateNormal)];
        [slide setMaximumTrackImage:[[UIImage imageNamed:@"call_corner_gray"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [slide setMaximumValue:30];
        [slide setMinimumValue:0];
        [slide addTarget:self action:@selector(slideChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:slide];
        slide.sd_layout.topSpaceToView(_messageLabel, 35 * kX)
        .rightSpaceToView(self.view, 62 * kX)
        .leftSpaceToView(self.view, 62 * kX)
        .heightIs(20 * kX);
        
        _mySlide = slide;
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.textColor = [UIColor whiteColor];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"0s";
        [leftLabel sizeToFit];
        [self.view addSubview:leftLabel];
        leftLabel.sd_layout.topSpaceToView(_mySlide, 8 * kX)
        .leftEqualToView(_mySlide)
        .widthIs(leftLabel.width)
        .heightIs(18 * kX);
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.text = @"30s";
        [rightLabel sizeToFit];
        [self.view addSubview:rightLabel];
        rightLabel.sd_layout.topSpaceToView(_mySlide, 8 * kX)
        .rightEqualToView(_mySlide)
        .widthIs(rightLabel.width)
        .heightIs(18 * kX);
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = kmaintextGrayColor;
        tipLabel.text = NSLocalizedString(@"请保持蓝牙开启,手环与手机处于连接状态",nil);
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 0;
        
        [self.view addSubview:tipLabel];
        tipLabel.sd_layout.topSpaceToView(leftLabel, 73 * kX)
        .centerXIs(ScreenW/2.)
        .widthIs(ScreenW)
        .heightIs(40);
        

        
    }
    return _mySlide;
}

@end
