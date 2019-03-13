//
//  JiuzuoSetViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "JiuzuoSetViewController1.h"
#import "AlarmRepeatViewController.h"

@interface JiuzuoSetViewController1 ()

@end

@implementation JiuzuoSetViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setXibLabels];
}

- (void)setXibLabels
{
    _titleLabel.text = NSLocalizedString(@"久坐提醒", nil);
    _kBeginTimeLabel.text = NSLocalizedString(@"开始久坐时间", nil);
    _kEndTimeLabel.text = NSLocalizedString(@"结束久坐时间", nil);
    _kTImeDurationLabel.text = NSLocalizedString(@"时间间隔提醒", nil);
    [_saveBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    _kTextTipLabel.text = NSLocalizedString(@"开启久坐提醒后，您的设备将增加一定的耗电量", nil);
    [self repeatValueChanged:self.model.repeats];
    [self.beginTimeBtn setTitle:[NSString stringWithFormat:@"%02d:%02d",self.model.beginHour,self.model.beginMin] forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:[NSString stringWithFormat:@"%02d:%02d",self.model.endHour,self.model.endMin] forState:UIControlStateNormal];
}


#pragma mark -- ButtonAction
- (IBAction)TimeAction:(UIButton *)sender {
    [self setPickerView];
    sender.selected = YES;
    _nowBtn = sender;
}

//重复
- (IBAction)durationBtnClick:(UIButton *)sender {
    AlarmRepeatViewController *repeatVC = [[AlarmRepeatViewController alloc] init];
    repeatVC.repeat = self.model.repeats;
    [self.navigationController pushViewController:repeatVC animated:YES];
    kWEAKSELF;
    repeatVC.block = ^(int repeat) {
        weakSelf.model.repeats = repeat;
        [weakSelf repeatValueChanged:repeat];
    };
}


- (IBAction)goBackButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveChangeAction:(UIButton *)sender {
    if (self.jiuzuoBlock) {
        self.jiuzuoBlock(self.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)repeatValueChanged:(int)repeat{
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
    self.durationLabel.text = repeatString;
}

- (void)setPickerView
{
    _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 246)];
    [_backView addSubview:_animationView];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,ScreenWidth, 216)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_animationView addSubview:_datePicker];
    
    
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = [UIColor whiteColor];
    [_animationView addSubview:buttonView];
    buttonView.sd_layout.leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .heightIs(30)
    .bottomSpaceToView(_datePicker,0);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonView addSubview:button];
    button.frame = CGRectMake(ScreenWidth-80, 0, 80, 40);
    [button addTarget:self action:@selector(dateSureClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btnImageView.image = [UIImage imageNamed:@"hook"];
    btnImageView.center = button.center;
    [buttonView addSubview:btnImageView];
    
    [UIView animateWithDuration:0.23 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _animationView.frame = CGRectMake(0, ScreenHeight-246,ScreenWidth, 246);
    }];
}

- (void)dateSureClick {
    NSDate *pickDate = _datePicker.date;
    NSDateFormatter *formates = [[NSDateFormatter alloc]init];
    [formates setDateFormat:@"HH:mm"];
    NSString *dayString = [formates stringFromDate:pickDate];
    [_nowBtn setTitle:dayString forState:UIControlStateNormal];
    [_nowBtn setTitle:dayString forState:UIControlStateSelected];
    [_nowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [formates setDateFormat:@"HH"];
    NSString *HString = [formates stringFromDate:pickDate];
    [formates setDateFormat:@"mm"];
    NSString *MString = [formates stringFromDate:pickDate];
    if (_nowBtn == self.beginTimeBtn) {
        self.model.beginHour = HString.intValue;
        self.model.beginMin = MString.intValue;
    }else{
        self.model.endHour = HString.intValue;
        self.model.endMin = MString.intValue;
    }
    
    [self hiddenDateBackView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenDateBackView];
    if (_tableViewBackView)
    {
        [_tableViewBackView removeFromSuperview];
        self.tableViewBackView = nil;
        self.durationTableView = nil;
    }
}

- (void)hiddenDateBackView
{
    _nowBtn.selected = NO;
    self.nowBtn = nil;
    [UIView animateWithDuration:0.23 animations:^{
        _animationView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 246);
    } completion:^(BOOL finished) {
        
        [_backView removeFromSuperview];
        _backView = nil;
        [_datePicker removeFromSuperview];
        _datePicker = nil;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
