//
//  SittingViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/17.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "SittingViewController.h"
#import "AlarmRepeatViewController.h"
#import "TimeSeldectViewController.h"

@interface SittingViewController ()

@property (nonatomic, weak) UIImageView *sittingImageView;

@property (weak, nonatomic)  UILabel *messageLabel;

@property (weak, nonatomic)  UISlider *mySlide;

@property (strong, nonatomic) SedentaryModel *model;

@property (strong, nonatomic) UILabel *beginTimeLabel;

@property (strong, nonatomic) UILabel *endTimeLabel;

@property (strong, nonatomic) UILabel *repeatLabel;



@end

@implementation SittingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getSedentaryWithSedentaryModelBlock:^(SedentaryModel *sedentaryModel) {
        weakSelf.model = sedentaryModel;
    }];
    
    [self loadUI];
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"久坐提醒",nil) backButton:YES shareButton:NO];
    [self sittingImageView];
    [self messageLabel];
    [self mySlide];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    [sureButton sizeToFit];
    [sureButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    sureButton.frame = CGRectMake(ScreenW - sureButton.width - 20, 7 + 20, sureButton.width, 30);
    
    for (int i = 0 ; i < 3; i ++)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = kmainBackgroundColor;
        [self.view addSubview:backView];
        backView.sd_layout.topSpaceToView(_mySlide, 76 * kX + 60 * kX * i)
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
        if (i == 2)
        {
            UIView *bottomView = [[UIView alloc] init];
            bottomView.backgroundColor = kmaintextGrayColor;
            [backView addSubview:bottomView];
            bottomView.sd_layout.bottomEqualToView(backView)
            .leftEqualToView(backView)
            .rightEqualToView(backView)
            .heightIs(0.5);
            
            _repeatLabel = [[UILabel alloc] init];
            _repeatLabel.textColor = [UIColor whiteColor];
            _repeatLabel.textAlignment = NSTextAlignmentRight;
            _repeatLabel.font = [UIFont systemFontOfSize:13];
            _repeatLabel.text = NSLocalizedString(@"从不",nil);
            [backView addSubview:_repeatLabel];
            _repeatLabel.sd_layout.rightSpaceToView(backView, 65 * kX)
            .leftEqualToView(backView)
            .centerYIs(backView.height/2.)
            .heightIs(30);
        }
        
        NSArray *titleArray = @[NSLocalizedString(@"开始",nil),NSLocalizedString(@"结束",nil),NSLocalizedString(@"重复",nil)];
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

}

- (void)setModel:(SedentaryModel *)model
{
    _model = model;
    if (_model.timeInteval < 30)
    {
        _model.timeInteval = 30;
    }
    [self loadTipLabelUIWithSecond:self.model.timeInteval];
    [self repeatValueChanged:self.model.repeats];
    [self updateTimeLabel];
    [self.mySlide setValue:self.model.timeInteval animated:YES];
    
}

- (void)updateTimeLabel
{
    self.beginTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.model.beginHour,self.model.beginMin];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.model.endHour,self.model.endMin];
}

- (void)repeatValueChanged:(int)repeat
{
    NSMutableString *repeatString = [NSMutableString string];
    if ((repeat & 0xFE) == 0xFE) {
        
        [repeatString appendString:NSLocalizedString(@"每天", nil)];
    }
    else if (repeat == 0x00 || repeat == 0x01){
        
        [repeatString appendString:NSLocalizedString(@"从不", nil)];
    }
    else
    {
        
        NSArray * array = @[NSLocalizedString(@"周一",nil),NSLocalizedString(@"周二",nil),NSLocalizedString(@"周三",nil),NSLocalizedString(@"周四",nil),NSLocalizedString(@"周五",nil),NSLocalizedString(@"周六",nil),NSLocalizedString(@"周日",nil)];

        for (int i = 1; i < 8; i++) {
            NSUInteger selectedValue = (repeat >> i) & 0x01;
            if (selectedValue) {
                [repeatString appendString:array[i - 1]];
                    [repeatString appendString:@" "];
            }
        }
    }
    self.repeatLabel.text = repeatString;
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
            };
            [self.navigationController pushViewController:endVC animated:YES];
        }
            break;
        case 102:
        {
            AlarmRepeatViewController *repeatVC = [[AlarmRepeatViewController alloc] init];
            repeatVC.repeat = self.model.repeats;
            [self.navigationController pushViewController:repeatVC animated:YES];
            kWEAKSELF;
            repeatVC.block = ^(int repeat) {
                weakSelf.model.repeats = repeat;
                [weakSelf repeatValueChanged:repeat];
            };
        }
            break;

        default:
            break;
    }
}

- (void)clickSure
{
    [[PZBlueToothManager sharedInstance] setSedentaryWithSedentaryModel:self.model];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)slideChange:(UISlider *)slide
{
    [self loadTipLabelUIWithSecond:slide.value];
    self.model.timeInteval = slide.value;
}

- (void)loadTipLabelUIWithSecond:(int)second
{
    
    NSString *str0 = NSLocalizedString(@"久坐", nil);
    NSString *str1 = NSLocalizedString(@"分钟后开始震动", nil);
    _messageLabel.text = [NSString stringWithFormat:@"%@%d%@",str0,second,str1];
}


- (UIImageView *)sittingImageView
{
    if (!_sittingImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"sittingOpen"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView.sd_layout.topSpaceToView(self.view, 150 * kX)
        .centerXIs(ScreenW/2.)
        .widthIs(70 * kX)
        .heightIs(70 * kX);
        _sittingImageView = imageView;
    }
    return _sittingImageView;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        label.sd_layout.topSpaceToView(_sittingImageView, 35 * kX)
        .centerXIs(ScreenW/2.)
        .widthIs(ScreenW)
        .heightIs(40);
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
        [slide setMaximumValue:180];
        [slide setMinimumValue:30];
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
        leftLabel.text = @"30min";
        leftLabel.font = [UIFont systemFontOfSize:13];
        [leftLabel sizeToFit];
        [self.view addSubview:leftLabel];
        leftLabel.sd_layout.topSpaceToView(_mySlide, 8 * kX)
        .leftEqualToView(_mySlide)
        .widthIs(leftLabel.width)
        .heightIs(18 * kX);
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.text = @"180min";
        rightLabel.font = [UIFont systemFontOfSize:13];
        [rightLabel sizeToFit];
        [self.view addSubview:rightLabel];
        rightLabel.sd_layout.topSpaceToView(_mySlide, 8 * kX)
        .rightEqualToView(_mySlide)
        .widthIs(rightLabel.width)
        .heightIs(18 * kX);
        
//        UILabel *tipLabel = [[UILabel alloc] init];
//        tipLabel.textColor = kmaintextGrayColor;
//        tipLabel.text = NSLocalizedString(@"请保持蓝牙开启,手环与手机处于连接状态");
//        tipLabel.font = [UIFont systemFontOfSize:13];
//        tipLabel.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:tipLabel];
//        tipLabel.sd_layout.topSpaceToView(leftLabel, 73 * kX)
//        .centerXIs(ScreenW/2.)
//        .widthIs(ScreenW)
//        .heightIs(20);
        
    }
    return _mySlide;
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
