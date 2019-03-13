//
//  chooseView.m
//  Bracelet
//
//  Created by panzheng on 2017/5/22.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "chooseView.h"
#import "DYScrollRulerView.h"

@implementation chooseView
- (id)init
{
    if (self = [super init])
    {
        [self addcenterView];
    }
    return self;
}

- (void)addcenterView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    view.sd_layout.centerXIs(ScreenW/2.)
    .widthIs(346 * kX)
    .centerYIs(ScreenH/2.)
    .heightIs(352 * kX);
    view.layer.cornerRadius = 8;
    _centerView = view;
    
}

- (void)setType:(viewType)type
{
    _type = type;
    if (type == viewTypeHeight)
    {
        self.titleLabel.text = NSLocalizedString(@"您的身高",nil);
        self.valueLabel.text = [NSString stringWithFormat:@"%d%@",170,@"cm"];
        
        DYScrollRulerView *rullerView = [[DYScrollRulerView alloc] initWithFrame:CGRectMake(0, 0, _centerView.width, _centerView.height) theMinValue:40 theMaxValue:250 theStep:1 theUnit:@"cm" theNum:10];
        [rullerView setDefaultValue:_value animated:YES];
        self.value = _value;
        rullerView.backgroundColor = [UIColor clearColor];
        rullerView.bgColor = [UIColor whiteColor];
        rullerView.triangleColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        rullerView.delegate = self.delegate;
        rullerView.scrollByHand = YES;
        [_centerView addSubview:rullerView];
        
        [self addSureButton];
    }
    if (type == viewTypeWeight)
    {
        self.titleLabel.text = NSLocalizedString(@"您的体重",nil);
        self.valueLabel.text = [NSString stringWithFormat:@"%d%@",60,@"cm"];
        
        DYScrollRulerView *rullerView = [[DYScrollRulerView alloc] initWithFrame:CGRectMake(0, 0, _centerView.width, _centerView.height) theMinValue:30 theMaxValue:200 theStep:1 theUnit:@"kg" theNum:10];
        [rullerView setDefaultValue:_value animated:YES];
        self.value = _value;
        rullerView.backgroundColor = [UIColor clearColor];
        rullerView.bgColor = [UIColor whiteColor];
        rullerView.triangleColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        rullerView.delegate = self.delegate;
        rullerView.scrollByHand = YES;
        [_centerView addSubview:rullerView];
        
        [self addSureButton];
    }
    if (type == viewTypeGender)
    {
        self.titleLabel.text = NSLocalizedString(@"性别",nil);

        for (int i = 0 ; i < 2; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setTitleColor:kmainBackgroundColor forState:UIControlStateNormal];
            [button setBackgroundImage:[self imageWithColor:kmainBackgroundColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(genderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_centerView addSubview:button];
            button.sd_layout.topSpaceToView(_centerView, 95 * kX + i * 55 * kX)
            .leftEqualToView(_centerView)
            .rightEqualToView(_centerView)
            .heightIs(55 * kX);
            if (i == 0)
            {
                [button setTitle:NSLocalizedString(@"女",nil) forState:UIControlStateNormal];
                _femaleButton = button;
            }else
            {
                [button setTitle:NSLocalizedString(@"男",nil) forState:UIControlStateNormal];
                _maleButton = button;
            }
            if (_value % 2 == i)
            {
                button.selected = YES;
            }
        }
        [self addSureButton];
    }
    if (type == viewTypeBirthDay)
    {
        self.titleLabel.text = NSLocalizedString(@"生日",nil);
        
        UIDatePicker *datePick = [[UIDatePicker alloc] init];
        datePick.datePickerMode = UIDatePickerModeDate;
        datePick.maximumDate = [NSDate date];
        NSString *string = @"19000101";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *minDate = [formatter dateFromString:string];
        
        datePick.minimumDate = minDate;
        [_centerView addSubview:datePick];
        datePick.center = CGPointMake(_centerView.width/2., _centerView.height/2.);
        _datePicker = datePick;
        [self addSureButton];
    }
    if (type == viewTypeUnit)
    {
        self.titleLabel.text = NSLocalizedString(@"单位",nil);
        for (int i = 0 ; i < 2; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setTitleColor:kmainBackgroundColor forState:UIControlStateNormal];
            [button setBackgroundImage:[self imageWithColor:kmainBackgroundColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(genderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_centerView addSubview:button];
            button.sd_layout.topSpaceToView(_centerView, 95 * kX + i * 55 * kX)
            .leftEqualToView(_centerView)
            .rightEqualToView(_centerView)
            .heightIs(55 * kX);
            if (i == 0)
            {
                [button setTitle:NSLocalizedString(@"英制",nil) forState:UIControlStateNormal];
                _femaleButton = button;
                
            }else
            {
                [button setTitle:NSLocalizedString(@"公制",nil) forState:UIControlStateNormal];
                _maleButton = button;
            }
            if (_value % 2 == i)
            {
                button.selected = YES;
            }
        }
        [self addSureButton];
    }

}


- (void)addSureButton
{
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.backgroundColor = kmainBackgroundColor;
    [sureButton setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:sureButton];
    sureButton.sd_layout.bottomSpaceToView(_centerView, 34 * kX)
    .centerXIs(_centerView.width/2.)
    .widthIs(140 * kX)
    .heightIs(35 * kX);
    sureButton.layer.cornerRadius = 5;
    sureButton.clipsToBounds = YES;
}

- (void)genderButtonClick:(UIButton *)button
{
    if (button == _femaleButton)
    {
        _femaleButton.selected = YES;
        _maleButton.selected = NO;
        self.value = 2;
    }else if(button == _maleButton)
    {
        _maleButton.selected = YES;
        _femaleButton.selected = NO;
        self.value = 1;
    }
    
    if (button == _metricButton) {
        _metricButton.selected = YES;
        _imperialButton.selected = NO;
        self.value = 1;
    }else if (button == _imperialButton)
    {
        _imperialButton.selected = YES;
        _metricButton.selected = NO;
        self.value = 2;
    }
    
}

- (void)sureButtonClick
{
    if (self.buttonHandle)
    {
        self.buttonHandle(self);
    }
    [UIView animateWithDuration:0.34 animations:^{
        self.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

- (void)setValue:(int)value
{
    _value = value;
    switch (self.type)
    {
        case viewTypeHeight:
        {
            self.valueLabel.text = [NSString stringWithFormat:@"%d%@",_value,@"cm"];
        }
            break;
        case viewTypeWeight:
        {
            self.valueLabel.text = [NSString stringWithFormat:@"%d%@",_value,@"kg"];
        }
            break;
        default:
            break;
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kmainBackgroundColor;
        label.textAlignment = NSTextAlignmentCenter;
        [_centerView addSubview:label];
        label.sd_layout.topSpaceToView(_centerView, 30 * kX)
        .centerXIs(_centerView.width/2.)
        .widthIs(_centerView.width)
        .heightIs(20);
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kmainBackgroundColor;
        label.textAlignment = NSTextAlignmentCenter;
        [_centerView addSubview:label];
        label.sd_layout.topSpaceToView(_titleLabel, 20 * kX)
        .centerXIs(_centerView.width/2.)
        .widthIs(_centerView.width)
        .heightIs(20);
        _valueLabel = label;
    }
    return _valueLabel;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
