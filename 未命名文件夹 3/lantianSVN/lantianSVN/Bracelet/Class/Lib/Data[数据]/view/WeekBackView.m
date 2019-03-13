//
//  WeekBackView.m
//  Bracelet
//
//  Created by panzheng on 2017/5/24.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "WeekBackView.h"
#import "HistoryDataModel.h"
#import "UILabel+Style.h"

@implementation WeekBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    if (self == [super init])
    {
    }
    return self;
}

- (void)setTimeType:(viewTimeType)timeType{

    _timeType = timeType;
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
        self.backView = nil;
        self.bottomView = nil;
    }
    
    [self backView];
    [self bottomView];

}


- (UIView *)backView
{
    if (!_backView)
    {
        
        float yWidth = 0;
        if (self.dataType == viewDataTypeHR)
        {
            yWidth = 20;
        }
        
        UIView *backView = [[UIView alloc] init];
        [self addSubview:backView];
        backView.sd_layout.topSpaceToView(self, 43 * kX)
        .leftSpaceToView(self, 12 * kX + yWidth)
        .rightSpaceToView(self, 12 * kX)
        .heightIs(226 * kX)
        .widthIs(ScreenW - 24 * kX - yWidth);
        _backView = backView;
        
        UIView *horLine = [[UIView alloc] init];
        horLine.backgroundColor = [UIColor grayColor];
        [_backView addSubview:horLine];
        horLine.sd_layout.leftEqualToView(_backView)
        .topEqualToView(_backView)
        .bottomEqualToView(_backView)
        .widthIs(1);
        
        UIView *verLine = [[UIView alloc] init];
        verLine.backgroundColor = [UIColor grayColor];
        [_backView addSubview:verLine];
        verLine.sd_layout.leftEqualToView(_backView)
        .rightEqualToView(_backView)
        .bottomEqualToView(_backView)
        .heightIs(1);
    }
    return _backView;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kmainBackgroundColor;
        [self addSubview:view];
        view.sd_layout.bottomEqualToView(self)
        .leftEqualToView(self)
        .widthIs(ScreenW)
        .heightIs(205 * kX);
        _bottomView = view;
        
        UIView *centerLine = [[UIView alloc] init];
        centerLine.backgroundColor = kmaintextGrayColor;
        [view addSubview:centerLine];
        centerLine.sd_layout.leftSpaceToView(view, 15 * kX)
        .centerYIs(view.height/2.)
        .rightSpaceToView(view, 15 * kX)
        .heightIs(0.5f);
        
        if (self.dataType == viewDataTypeStep)
        {
            [self initStepBottom];

        }else if (self.dataType == viewDataTypeSleep)
        {
            [self initSleepBottom];
        }else if (self.dataType == viewDataTypeHR)
        {
            [self initHRBottom];
        }
    }
    return _bottomView;
}

- (void)setStepArray:(NSArray *)StepArray
{
    _StepArray = StepArray;
    
    if (self.dataType == viewDataTypeStep)
    {
        [self updateStepBottomLabels];
    }else if (self.dataType == viewDataTypeSleep)
    {
        [self updateSleepBottomLabels];
    }else if (self.dataType == viewDataTypeHR)
    {
        for (UIView *view in self.subviews)
        {
            [view removeFromSuperview];
            self.backView = nil;
            self.bottomView = nil;
        }
        [self backView];
        [self bottomView];
        [self DrawHRView];
        [self updateHRBottomLabels];
        return;
    }
    
    if  (self.timeType == viewTimeTypeWeek)
    {
        if (self.dataType == viewDataTypeStep)
        {
            [self drawWeekStep];
        }else if (self.dataType == viewDataTypeSleep)
        {
            [self drawWeekSleep];
        }
    }else if (_timeType == viewTimeTypeMonth)
    {
        if (self.dataType == viewDataTypeStep)
        {
            [self drawMonthStep];
        }else if (self.dataType == viewDataTypeSleep)
        {
            [self drawMonthSleep];
        }
    }else if (_timeType == viewTimeTypeYear)
    {
        if (self.dataType == viewDataTypeStep)
        {
            [self drawYearStep];
        }else if (self.dataType == viewDataTypeSleep)
        {
            [self drawyearSleep];
        }
    }
    
}

- (void)initSleepBottom
{
    NSArray *Array = @[NSLocalizedString(@"今日睡眠",nil),NSLocalizedString(@"总睡眠",nil)];
    for (int i = 0; i < 2; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kmaintextGrayColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = Array[i];
        label.font = [UIFont systemFontOfSize:12];
        [_bottomView addSubview:label];
        label.sd_layout.topSpaceToView(_bottomView, 8 * kX + i * _bottomView.height/2.)
        .leftEqualToView(_bottomView)
        .rightEqualToView(_bottomView)
        .heightIs(12 * kX);
    }
    
    for (int i = 0; i < 6; i ++)
    {
        UIView *horLine = [[UIView alloc] init];
        horLine.backgroundColor = kmaintextGrayColor;
        [_bottomView addSubview:horLine];
        horLine.sd_layout.leftSpaceToView(_bottomView, (i % 3 + 1) * _bottomView.width/4.)
        .topSpaceToView(_bottomView, i/3 * _bottomView.height / 2. + 28 * kX)
        .heightIs(_bottomView.height/2. - 56 * kX)
        .widthIs(0.5);
    }
    NSArray * titleArray = @[NSLocalizedString(@"睡眠",nil),NSLocalizedString(@"深睡",nil),NSLocalizedString(@"浅睡",nil),NSLocalizedString(@"清醒",nil)];
    for (int i = 0; i < 8; i ++)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArray[i%4];
        titleLabel.textColor = kmaintextGrayColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_bottomView addSubview:titleLabel];
        titleLabel.sd_layout.topSpaceToView(_bottomView, i / 4 * _bottomView.height/2. + 0.3 * _bottomView.height)
        .leftSpaceToView(_bottomView, i % 4 * _bottomView.width/4.)
        .widthIs(_bottomView.width/4.)
        .heightIs(0.1 * _bottomView.height);
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = kmaintextGrayColor;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.font = [UIFont systemFontOfSize:13];
        valueLabel.tag = 100 + i;
        [_bottomView addSubview:valueLabel];
        valueLabel.sd_layout.topSpaceToView(_bottomView, i / 4 * _bottomView.height/2. + 0.12 * _bottomView.height)
        .leftSpaceToView(_bottomView, i % 4 * _bottomView.width/4.)
        .widthIs(_bottomView.width/4.)
        .heightIs(0.1 * _bottomView.height);
    }

}

- (void)initHRBottom
{
    for (int i = 0; i < 2; i ++)
    {
        UIView *horLine = [[UIView alloc] init];
        horLine.backgroundColor = kmaintextGrayColor;
        [_bottomView addSubview:horLine];
        horLine.sd_layout.leftSpaceToView(_bottomView, (i % 2 + 1) * _bottomView.width/3.)
        .topSpaceToView(_bottomView, i/2 * _bottomView.height / 2. + 12 * kX)
        .heightIs(_bottomView.height/2. - 24 * kX)
        .widthIs(0.5);
    }
    NSArray * titleArray = @[NSLocalizedString(@"平均心率",nil),NSLocalizedString(@"最高心率",nil),NSLocalizedString(@"最低心率",nil)];
    for (int i = 0; i < titleArray.count; i ++)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = kmaintextGrayColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [_bottomView addSubview:titleLabel];
        titleLabel.sd_layout.topSpaceToView(_bottomView, i / 3 * _bottomView.height/2. + 0.3 * _bottomView.height)
        .leftSpaceToView(_bottomView, i % 3 * _bottomView.width/3.)
        .widthIs(_bottomView.width/3.)
        .heightIs(0.1 * _bottomView.height);
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = kmaintextGrayColor;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.font = [UIFont systemFontOfSize:13];
        valueLabel.tag = 100 + i;
        [_bottomView addSubview:valueLabel];
        valueLabel.sd_layout.topSpaceToView(_bottomView, i / 3 * _bottomView.height/2. + 0.1 * _bottomView.height)
        .leftSpaceToView(_bottomView, i % 3 * _bottomView.width/3.)
        .widthIs(_bottomView.width/3.)
        .heightIs(0.1 * _bottomView.height);
    }

}

- (void)initStepBottom
{
    for (int i = 0; i < 4; i ++)
    {
        UIView *horLine = [[UIView alloc] init];
        horLine.backgroundColor = kmaintextGrayColor;
        [_bottomView addSubview:horLine];
        horLine.sd_layout.leftSpaceToView(_bottomView, (i % 2 + 1) * _bottomView.width/3.)
        .topSpaceToView(_bottomView, i/2 * _bottomView.height / 2. + 12 * kX)
        .heightIs(_bottomView.height/2. - 24 * kX)
        .widthIs(0.5);
    }
    NSArray * titleArray = @[NSLocalizedString(@"今日步数",nil),NSLocalizedString(@"今日路程",nil),NSLocalizedString(@"今日消耗",nil),
                             NSLocalizedString(@"总步数",nil),NSLocalizedString(@"总路程",nil),NSLocalizedString(@"总消耗",nil),];
    for (int i = 0; i < titleArray.count; i ++)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = kmaintextGrayColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.numberOfLines = 2;
        [titleLabel sizeToFit];
        [_bottomView addSubview:titleLabel];
        titleLabel.sd_layout.topSpaceToView(_bottomView, i / 3 * _bottomView.height/2. + 0.3 * _bottomView.height)
        .leftSpaceToView(_bottomView, i % 3 * _bottomView.width/3.)
        .widthIs(_bottomView.width/3.)
        .heightIs(titleLabel.height * 2);
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = kmaintextGrayColor;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.font = [UIFont systemFontOfSize:13];
        valueLabel.tag = 100 + i;
        [_bottomView addSubview:valueLabel];
        valueLabel.sd_layout.topSpaceToView(_bottomView, i / 3 * _bottomView.height/2. + 0.1 * _bottomView.height)
        .leftSpaceToView(_bottomView, i % 3 * _bottomView.width/3.)
        .widthIs(_bottomView.width/3.)
        .heightIs(0.1 * _bottomView.height);
    }
}

- (void)drawWeekSleep
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [[TimeCallManager getInstance] getWeekTime];
    [self addSubview:label];
    [label sizeToFit];
    label.sd_layout.topSpaceToView(self, 11 * kX)
    .leftSpaceToView(self, 11 * kX)
    .widthIs(label.width)
    .heightIs(20);
    
    NSArray *array = @[NSLocalizedString(@"一",nil),NSLocalizedString(@"二",nil),NSLocalizedString(@"三",nil),NSLocalizedString(@"四",nil),NSLocalizedString(@"五",nil),NSLocalizedString(@"六",nil),NSLocalizedString(@"日",nil)];
    for (int i = 0 ; i < 7; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = array[i];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [_backView addSubview:label];
        label.sd_layout.centerXIs(23 * kX + 50 * kX * i)
        .bottomSpaceToView(_backView, - 30 * kX)
        .widthIs(50 * kX)
        .heightIs(20);
    }
    
//    NSArray *colorArray = @[KCOLOR(158, 219, 215),KCOLOR(31, 131, 124),KCOLOR(20, 96, 92)];
    NSArray *colorArray = @[kmainAwakeSleep,kmainLightColor,kmainDeepSleep];


    for (int i = 0 ; i < _StepArray.count; i ++)
    {
        oneDaySleepModel *sleepModel = _StepArray[i];
        if ([sleepModel isKindOfClass:[oneDaySleepModel class]])
        {
            if (sleepModel.totalSleepTime > 0)
            {
                float maxValue = MAX(480, sleepModel.totalSleepTime);
                float sleepTime[3] = {sleepModel.totalSleepTime,sleepModel.lightSleepTime  + sleepModel.deepSleepTime,sleepModel.deepSleepTime};
                
                for (int idx = 0; idx < 3; idx ++)
                {
                    if (sleepModel.totalSleepTime > 0)
                    {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.backgroundColor = colorArray[idx];
                        if (idx == 0)
                        {
                            button.tag = 200 + i;
                        }
                        [self.backView addSubview:button];
                        
                        button.sd_layout.centerXIs(23 * kX + 50 * kX * i)
                        .bottomEqualToView(_backView)
                        .widthIs(15 * kX)
                        .heightIs((sleepTime[idx] / maxValue) * _backView.height);
                        
                        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(15 * kX /2.,15 * kX /2.)];//圆角大小
                        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                        maskLayer.frame = button.bounds;
                        maskLayer.path = maskPath.CGPath;
                        button.layer.mask = maskLayer;
                    }
                }
                
                UIButton *eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
                eventButton.backgroundColor = [UIColor clearColor];
                [_backView addSubview:eventButton];
                eventButton.tag = 100 + i;
                [eventButton addTarget:self action:@selector(valueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                eventButton.sd_layout.leftSpaceToView(_backView, i * _backView.width/7.)
                .bottomEqualToView(_backView)
                .topEqualToView(_backView)
                .widthIs(_backView.width/7.);
            }
        }
    }
    
}

- (void)DrawHRView
{
    PZChart *chartView = [[PZChart alloc] init];
    [_backView addSubview:chartView];
    chartView.sd_layout.topEqualToView(_backView)
    .leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .bottomEqualToView(_backView);
    chartView.heartArray = self.StepArray;
    _chartView = chartView;
    for (int i = 0; i < 8; i ++)
    {
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = [UIColor grayColor];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.text = [NSString stringWithFormat:@"%d",180 - 20 * i];
        valueLabel.font = [UIFont systemFontOfSize:12];
        [_backView addSubview:valueLabel];
        [valueLabel sizeToFit];
        valueLabel.sd_layout.centerYIs(i * _backView.height/8.0)
        .leftSpaceToView(_backView, - 30 - 3 * kX)
        .widthIs(30)
        .heightIs(valueLabel.height);
        [valueLabel alignTop];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [_backView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(_backView, i * _backView.height/8.0)
        .leftEqualToView(_backView)
        .rightEqualToView(_backView)
        .heightIs(0.5);
    }
    for (int i = 0 ; i < 25; i ++)
    {
        if (i%2 == 0)
        {
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.textColor = [UIColor grayColor];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.text = [NSString stringWithFormat:@"%d",i];
            timeLabel.font = [UIFont systemFontOfSize:12];
            [_backView addSubview:timeLabel];
            timeLabel.sd_layout.centerXIs(i * _backView.width/24.)
            .bottomSpaceToView(_backView, - 30 * kX)
            .widthIs(_backView.width/12.)
            .heightIs(20);
        }
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [_backView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(_backView, 0)
        .leftSpaceToView(_backView, i * _backView.width/24.)
        .bottomEqualToView(_backView)
        .widthIs(0.5);

    }
}

- (void)drawWeekStep
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [[TimeCallManager getInstance] getWeekTime];
    [self addSubview:label];
    [label sizeToFit];
    label.sd_layout.topSpaceToView(self, 11 * kX)
    .leftSpaceToView(self, 11 * kX)
    .widthIs(label.width)
    .heightIs(20);
    
    NSArray *array = @[NSLocalizedString(@"一",nil),NSLocalizedString(@"二",nil),NSLocalizedString(@"三",nil),NSLocalizedString(@"四",nil),NSLocalizedString(@"五",nil),NSLocalizedString(@"六",nil),NSLocalizedString(@"日",nil)];
    for (int i = 0 ; i < 7; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = array[i];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [_backView addSubview:label];
        label.sd_layout.centerXIs(23 * kX + 50 * kX * i)
        .bottomSpaceToView(_backView, - 30 * kX)
        .widthIs(50 * kX)
        .heightIs(20);
    }
    
    float maxValue = 10000;
    for (int i = 0 ; i < _StepArray.count; i ++)
    {
        float value = [_StepArray[i] floatValue];
        value = MIN(maxValue, value);
        if (value > 0)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = kmainBackgroundColor;
            button.tag = 200 + i;
            [self.backView addSubview:button];
            
            button.sd_layout.centerXIs(23 * kX + 50 * kX * i)
            .bottomEqualToView(_backView)
            .widthIs(15 * kX)
            .heightIs((value / maxValue) * _backView.height);
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(15 * kX /2.,15 * kX /2.)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = button.bounds;
            maskLayer.path = maskPath.CGPath;
            button.layer.mask = maskLayer;
            
            UIButton *eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
            eventButton.backgroundColor = [UIColor clearColor];
            [_backView addSubview:eventButton];
            eventButton.tag = 100 + i;
            [eventButton addTarget:self action:@selector(valueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            eventButton.sd_layout.leftSpaceToView(_backView, i * _backView.width/7.)
            .bottomEqualToView(_backView)
            .topEqualToView(_backView)
            .widthIs(_backView.width/7.);

        }
    }
}



- (void)drawMonthSleep
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *month = [formatter stringFromDate:date];
    label.text = [NSString stringWithFormat:@"%@ 01-%02lu",month,(unsigned long)_StepArray.count];
    [self addSubview:label];
    [label sizeToFit];
    label.sd_layout.topSpaceToView(self, 11 * kX)
    .leftSpaceToView(self, 11 * kX)
    .widthIs(label.width)
    .heightIs(20);
    
    NSArray *colorArray = @[kmainAwakeSleep,kmainLightColor,kmainDeepSleep];

    for (int i = 0 ; i < _StepArray.count; i ++)
    {
        if (i % 2 == 0)
        {
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"%d",i + 1];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            [_backView addSubview:label];
            label.sd_layout.centerXIs(8 * kX + 11 * kX * i)
            .bottomSpaceToView(_backView, - 30 * kX)
            .widthIs(23 * kX)
            .heightIs(20);
        }
        
        oneDaySleepModel *sleepModel = _StepArray[i];
        if ([sleepModel isKindOfClass:[oneDaySleepModel class]])
        {
            if (sleepModel.totalSleepTime > 0)
            {
                float maxValue = MAX(480, sleepModel.totalSleepTime);
                float sleepTime[3] = {sleepModel.totalSleepTime,sleepModel.lightSleepTime  + sleepModel.deepSleepTime,sleepModel.deepSleepTime};
                
                for (int idx = 0; idx < 3; idx ++)
                {
                    if (sleepModel.totalSleepTime > 0)
                    {
                        
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.backgroundColor = colorArray[idx];
                        if (idx == 0)
                        {
                            button.tag = 200 + i;
                        }
                        [self.backView addSubview:button];
                        
                        button.sd_layout.centerXIs(8 * kX + 11 * kX * i)
                        .bottomEqualToView(_backView)
                        .widthIs(5 * kX)
                        .heightIs((sleepTime[idx] / maxValue) * _backView.height);
                        
                        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(15 * kX /2.,15 * kX /2.)];//圆角大小
                        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                        maskLayer.frame = button.bounds;
                        maskLayer.path = maskPath.CGPath;
                        button.layer.mask = maskLayer;
                    }

                }
                UIButton *eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
                eventButton.backgroundColor = [UIColor clearColor];
                [_backView addSubview:eventButton];
                eventButton.tag = 100 + i;
                [eventButton addTarget:self action:@selector(valueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                eventButton.sd_layout.centerXIs(8 * kX + 11 * kX * i)
                .bottomEqualToView(_backView)
                .topEqualToView(_backView)
                .widthIs(11 * kX);
            }
        }
     }
}

- (void)drawMonthStep
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *month = [formatter stringFromDate:date];
    label.text = [NSString stringWithFormat:@"%@ 01-%02lu",month,(unsigned long)_StepArray.count];
    [self addSubview:label];
    [label sizeToFit];
    label.sd_layout.topSpaceToView(self, 11 * kX)
    .leftSpaceToView(self, 11 * kX)
    .widthIs(label.width)
    .heightIs(20);
    
    for (int i = 0 ; i < _StepArray.count; i ++)
    {
        float maxValue = 10000;
        if (i % 2 == 0)
        {
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"%d",i + 1];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            [_backView addSubview:label];
            label.sd_layout.centerXIs(8 * kX + 11 * kX * i)
            .bottomSpaceToView(_backView, - 30 * kX)
            .widthIs(23 * kX)
            .heightIs(20);
        }
        
        
        float value = [_StepArray[i] floatValue];
        value = MIN(maxValue, value);
        if (value > 0)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = kmainBackgroundColor;
            button.tag = 200 + i;
            [self.backView addSubview:button];
            
            button.sd_layout.centerXIs(8 * kX + 11 * kX * i)
            .bottomEqualToView(_backView)
            .widthIs(5 * kX)
            .heightIs((value / maxValue) * _backView.height);
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(5 * kX /2.,5 * kX /2.)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = button.bounds;
            maskLayer.path = maskPath.CGPath;
            button.layer.mask = maskLayer;
            
            UIButton *eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
            eventButton.backgroundColor = [UIColor clearColor];
            [_backView addSubview:eventButton];
            eventButton.tag = 100 + i;
            [eventButton addTarget:self action:@selector(valueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            eventButton.sd_layout.centerXIs(8 * kX + 11 * kX * i)
            .bottomEqualToView(_backView)
            .topEqualToView(_backView)
            .widthIs(11 * kX);
        }
        
    }
}

- (void)drawyearSleep
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *month = [formatter stringFromDate:date];
    label.text = [NSString stringWithFormat:@"%@-%@",[[TimeCallManager getInstance] getFirstMonthMMM],month];
    [self addSubview:label];
    [label sizeToFit];
    label.sd_layout.topSpaceToView(self, 11 * kX)
    .leftSpaceToView(self, 11 * kX)
    .widthIs(label.width)
    .heightIs(20);
    
    NSArray *array = @[NSLocalizedString(@"一月",nil),NSLocalizedString(@"二月",nil),NSLocalizedString(@"三月",nil),NSLocalizedString(@"四月",nil),
                       NSLocalizedString(@"五月",nil),NSLocalizedString(@"六月",nil),NSLocalizedString(@"七月",nil),NSLocalizedString(@"八月",nil),
                       NSLocalizedString(@"九月",nil),NSLocalizedString(@"十月",nil),NSLocalizedString(@"十一月",nil),NSLocalizedString(@"十二月",nil)];
    NSArray *colorArray = @[kmainAwakeSleep,kmainLightColor,kmainDeepSleep];
    for (int i = 0 ; i < _StepArray.count; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = array[i];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [_backView addSubview:label];
        label.sd_layout.centerXIs(10 * kX + 30 * kX * i)
        .bottomSpaceToView(_backView, - 30 * kX)
        .widthIs(30 * kX)
        .heightIs(20);
        
        oneDaySleepModel *sleepModel = _StepArray[i];
        if ([sleepModel isKindOfClass:[oneDaySleepModel class]])
        {
            if (sleepModel.totalSleepTime > 0)
            {
                float maxValue = MAX(4800, sleepModel.totalSleepTime);
                float sleepTime[3] = {sleepModel.totalSleepTime,sleepModel.lightSleepTime  + sleepModel.deepSleepTime,sleepModel.deepSleepTime};
                
                for (int idx = 0; idx < 3; idx ++)
                {
                    if (sleepModel.totalSleepTime > 0)
                    {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.backgroundColor = colorArray[idx];
                        if (idx == 0) {
                            button.tag = 200 + i;
                        }
                        [self.backView addSubview:button];
                        
                        button.sd_layout.centerXIs(10 * kX + 30 * kX * i)
                        .bottomEqualToView(_backView)
                        .widthIs(10 * kX)
                        .heightIs((sleepTime[idx] / maxValue) * _backView.height);
                        
                        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(15 * kX /2.,15 * kX /2.)];//圆角大小
                        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                        maskLayer.frame = button.bounds;
                        maskLayer.path = maskPath.CGPath;
                        button.layer.mask = maskLayer;
                    }
                    
                }
                UIButton *eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
                eventButton.backgroundColor = [UIColor clearColor];
                [_backView addSubview:eventButton];
                eventButton.tag = 100 + i;
                [eventButton addTarget:self action:@selector(valueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                eventButton.sd_layout.centerXIs(10 * kX + 30 * kX * i)
                .bottomEqualToView(_backView)
                .topEqualToView(_backView)
                .widthIs(30 * kX);
            }
        }
    }
}

- (void)drawYearStep
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *month = [formatter stringFromDate:date];
    label.text = [NSString stringWithFormat:@"%@-%@",[[TimeCallManager getInstance] getFirstMonthMMM],month];
    
    [self addSubview:label];
    [label sizeToFit];
    label.sd_layout.topSpaceToView(self, 11 * kX)
    .leftSpaceToView(self, 11 * kX)
    .widthIs(label.width)
    .heightIs(20);
    
    NSArray *array = @[NSLocalizedString(@"一月",nil),NSLocalizedString(@"二月",nil),NSLocalizedString(@"三月",nil),NSLocalizedString(@"四月",nil),
                       NSLocalizedString(@"五月",nil),NSLocalizedString(@"六月",nil),NSLocalizedString(@"七月",nil),NSLocalizedString(@"八月",nil),
                       NSLocalizedString(@"九月",nil),NSLocalizedString(@"十月",nil),NSLocalizedString(@"十一月",nil),NSLocalizedString(@"十二月",nil)];
    for (int i = 0 ; i < _StepArray.count; i ++)
    {
        float maxValue = 100000;

        UILabel *label = [[UILabel alloc] init];
        label.text = array[i];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [_backView addSubview:label];
        label.sd_layout.centerXIs(10 * kX + 30 * kX * i)
        .bottomSpaceToView(_backView, - 30 * kX)
        .widthIs(30 * kX)
        .heightIs(20);
        
        float value = [_StepArray[i] floatValue];
        value = MIN(maxValue, value);
        if (value > 0)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = kmainBackgroundColor;
            button.tag = 200 + i;
            [self.backView addSubview:button];
            
            button.sd_layout.centerXIs(10 * kX + 30 * kX * i)
            .bottomEqualToView(_backView)
            .widthIs(10 * kX)
            .heightIs((value / maxValue) * _backView.height);
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(4 * kX ,4 * kX)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = button.bounds;
            maskLayer.path = maskPath.CGPath;
            button.layer.mask = maskLayer;
            
            UIButton *eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
            eventButton.backgroundColor = [UIColor clearColor];
            [_backView addSubview:eventButton];
            eventButton.tag = 100 + i;
            [eventButton addTarget:self action:@selector(valueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            eventButton.sd_layout.centerXIs(10 * kX + 30 * kX * i)
            .bottomEqualToView(_backView)
            .topEqualToView(_backView)
            .widthIs(30 * kX);
        }
    }
}

- (void)setToucheX:(float)toucheX
{
    int index = toucheX/(self.chartView.width/_chartView.heartArray.count) ;
    int value = [_chartView.heartArray[index] intValue];
    if (value > 0) {
        float y = (180 - value) * (self.chartView.height)/(180 - 20);
        self.valuePoint.center = CGPointMake(toucheX, y);
        self.valueLabel.text = [NSString stringWithFormat:@"%dbpm",value];
        [self.valueLabel sizeToFit];
        
        self.valueLabel.sd_layout.bottomSpaceToView(self.valuePoint, 0)
        .centerXIs(toucheX)
        .heightIs(self.valueLabel.height)
        .widthIs(self.valueLabel.width + 10);
        
        self.valueLabel.layer.cornerRadius = self.valueLabel.height/2.;
        self.valueLabel.clipsToBounds = YES;
    }else
    {
//        [self.valueLabel removeFromSuperview];
//        self.valueLabel = nil;
    }
}


- (void)valueButtonClick:(UIButton *)button
{
    UIButton *viewButton = [_backView viewWithTag:button.tag + 100];
    if (_dataType == viewDataTypeStep)
    {
        self.valueLabel.text = _StepArray[button.tag - 100];
        self.valueLabel.font = [UIFont systemFontOfSize:14];
        [self.valueLabel sizeToFit];
        self.valueLabel.sd_layout.centerXIs(viewButton.centerX)
        .bottomSpaceToView(viewButton, 2)
        .widthIs(self.valueLabel.width + 10)
        .heightIs(self.valueLabel.height);
        self.valueLabel.layer.cornerRadius = self.valueLabel.height/2.;
        self.valueLabel.clipsToBounds = YES;
        
        self.valuePoint.sd_layout.bottomSpaceToView(viewButton, -2)
        .centerXIs(viewButton.centerX)
        .widthIs(self.valuePoint.width)
        .heightIs(self.valuePoint.height);
    }else if (_dataType == viewDataTypeSleep)
    {
        NSString *textString;

        oneDaySleepModel *model = _StepArray[button.tag - 100];
        textString = [NSString stringWithFormat:@"%@ %dh%dmin\n%@ %dh%dmin\n%@ %dh%dmin",NSLocalizedString(@"深睡", nil),model.deepSleepTime/60,model.deepSleepTime%60,NSLocalizedString(@"浅睡", nil),model.lightSleepTime/60,model.lightSleepTime%60,NSLocalizedString(@"清醒", nil),model.awakeSleepTime/60,model.awakeSleepTime%60];
        self.valueLabel.text = textString;
        self.valueLabel.font = [UIFont systemFontOfSize:14];
        [self.valueLabel sizeToFit];
        float centerX = viewButton.centerX;
        if (centerX < _valueLabel.width/2.) {
            centerX = _valueLabel.width/2.;
        }else if (centerX + _valueLabel.width/2. > _backView.width)
        {
            centerX = _backView.width - _valueLabel.width/2.;
        }
        float bottomDistance = 2;
        if (viewButton.top < self.valueLabel.height)
        {
            bottomDistance = - self.valueLabel.height;
        }
        self.valueLabel.sd_layout.centerXIs(centerX)
        .bottomSpaceToView(viewButton, bottomDistance)
        .widthIs(self.valueLabel.width + 10)
        .heightIs(self.valueLabel.height);
        self.valueLabel.layer.cornerRadius = 5;
        self.valueLabel.clipsToBounds = YES;
        
        self.valuePoint.sd_layout.bottomSpaceToView(viewButton, -2)
        .centerXIs(viewButton.centerX)
        .widthIs(self.valuePoint.width)
        .heightIs(self.valuePoint.height);
    }
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = kmainBackgroundColor;
        label.textColor = [UIColor whiteColor];
        if (self.dataType == viewDataTypeSleep)
        {
            label.numberOfLines = 3;
        }
        [_backView addSubview:label];
        _valueLabel = label;
    }
    return _valueLabel;
}

- (UIView *)valuePoint
{
    if (!_valuePoint)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, 0, 5, 5);
        view.layer.cornerRadius = 2.5;
        view.layer.borderColor = kmainBackgroundColor.CGColor;
        view.layer.borderWidth = 1;
        [_backView addSubview:view];
        _valuePoint = view;
    }
    return _valuePoint;
}

- (void)updateSleepBottomLabels
{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    
    int totalTime = 0;
    int totalDeep = 0;
    int totalLight = 0;
    int totalAwake = 0;
    for (int i = 0; i < _StepArray.count; i ++)
    {
        oneDaySleepModel *model = _StepArray[i];
        if ([model isKindOfClass:[oneDaySleepModel class]])
        {
            totalTime += model.totalSleepTime;
            totalDeep += model.deepSleepTime;
            totalLight += model.lightSleepTime;
            totalAwake += model.awakeSleepTime;
        }
    }
    
    for (int i = 0; i < 8; i ++)
    {
        UILabel *label = (UILabel *)[_bottomView viewWithTag:100 + i];
        switch (100 + i)
        {
            case 100:
            {
                label.text = @"0h0min";
                [model getOneDaySleepWithTimeSeconds:kHCH.todayTimeSeconds Completion:^(oneDaySleepModel *model) {
                    if (model) {
                        label.text = [NSString stringWithFormat:@"%dh%dmin",model.totalSleepTime/60,model.totalSleepTime%60];
                    }
                }];

            }
                break;
            case 101:
            {
                label.text = @"0h0min";
                [model getOneDaySleepWithTimeSeconds:kHCH.todayTimeSeconds Completion:^(oneDaySleepModel *model) {
                    if (model)
                    {
                        label.text = [NSString stringWithFormat:@"%dh%dmin",model.deepSleepTime/60,model.deepSleepTime%60];
                    }
                }];
            }
                break;
            case 102:
            {
                label.text = @"0h0min";
                [model getOneDaySleepWithTimeSeconds:kHCH.todayTimeSeconds Completion:^(oneDaySleepModel *model) {
                    if (model)
                    {
                        label.text = [NSString stringWithFormat:@"%dh%dmin",model.lightSleepTime/60,model.lightSleepTime%60];
                    }
                }];
            }
                break;
            case 103:
            {
                
                label.text = @"0h0min";
                [model getOneDaySleepWithTimeSeconds:kHCH.todayTimeSeconds Completion:^(oneDaySleepModel *model) {
                    if (model)
                    {
                        label.text = [NSString stringWithFormat:@"%dh%dmin",model.awakeSleepTime/60,model.awakeSleepTime%60];
                    }
                }];
            }
                break;
            case 104:
            {
                
                label.text = [NSString stringWithFormat:@"%dh%dmin",totalTime/60,totalTime%60];
                
            }
                break;
            case 105:
            {
                
                label.text = [NSString stringWithFormat:@"%dh%dmin",totalDeep/60,totalDeep%60];
                
            }
                break;
            case 106:
            {
                
                label.text = [NSString stringWithFormat:@"%dh%dmin",totalLight/60,totalLight%60];
                
            }
                break;
            case 107:
            {
                
                label.text = [NSString stringWithFormat:@"%dh%dmin",totalAwake/60,totalAwake%60];
            }
                break;
            default:
                break;
        }
    }
}

- (void)updateHRBottomLabels
{
    int maxValue = 0;
    int minValue = 0;
    int count = 0;
    int totalValue = 0;
    for ( int i = 0 ; i < _StepArray.count; i ++)
    {
        int value = [_StepArray[i] intValue];
        if (value > 0)
        {
            if (minValue == 0)
            {
                minValue = value;
            }
            count ++;
            maxValue = MAX(maxValue, value);
            if (value < minValue)
            {
                minValue = value;
            }
            totalValue += value;
        }
    }
    int avgValue = totalValue/count;
    
    for (int i = 0; i < 3; i ++)
    {
        UILabel *label = (UILabel *)[_bottomView viewWithTag:100 + i];
        switch (100 + i)
        {
            case 100:
            {
                label.text = [NSString stringWithFormat:@"%d",avgValue];
            }
                break;
            case 101:
            {
                label.text = [NSString stringWithFormat:@"%d",maxValue];
            }
                break;
            case 102:
            {
                label.text = [NSString stringWithFormat:@"%d",minValue];
            }
                break;
            default:
                break;
        }
    }
}

- (void)updateStepBottomLabels
{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    float stride = 0.0;
    if ([kHCH.userInfoModel.gender isEqualToString:NSLocalizedString(@"1",nil)])
    {
        stride = (0.415 * [kHCH.userInfoModel.height floatValue]) / 100.0;
    }else if ([kHCH.userInfoModel.gender isEqualToString:NSLocalizedString(@"2",nil)])
    {
        stride = (0.413) * [kHCH.userInfoModel.height floatValue] / 100.0;
    }
    float singleCal = ([kHCH.userInfoModel.weight floatValue] - 15) * 0.000693 + 0.005895;
    
    int totalStep = 0;
    float totalK = 0;
    float totalC = 0;
    for (int i = 0; i < _StepArray.count; i ++)
    {
        totalStep += [_StepArray[i] intValue];
    }
    if (totalStep < self.totalStep) {
        totalStep = self.totalStep;
        totalK = self.totalKm;
        totalC = self.totalKcal;
    }else{
        totalK = totalStep*0.7;
        totalC = totalStep*0.042;
    }
    for (int i = 0; i < 6; i ++)
    {
        UILabel *label = (UILabel *)[_bottomView viewWithTag:100 + i];
        switch (100 + i)
        {
            case 100:
            {
                [model writeDateYearWithTimeSeconds:kHCH.todayTimeSeconds completion:^(userDataModel *dataModel) {
                    label.text = [NSString stringWithFormat:@"%d",self.totalStep];
                }];
            }
                break;
            case 101:
            {
                [model writeDateYearWithTimeSeconds:kHCH.todayTimeSeconds completion:^(userDataModel *dataModel) {
                    label.text = [NSString stringWithFormat:@"%.2f%@",self.totalKm/1000.0,@"km"];
                }];
            }
                break;
            case 102:
            {
                [model writeDateYearWithTimeSeconds:kHCH.todayTimeSeconds completion:^(userDataModel *dataModel) {
                    label.text = [NSString stringWithFormat:@"%d%@",self.totalKcal,@"Kcal" ];
                }];
            }
                break;
            case 103:
            {
                
                label.text = [NSString stringWithFormat:@"%d",totalStep];
                
            }
                break;
            case 104:
            {
                
                label.text = [NSString stringWithFormat:@"%.2f%@", totalK/1000.0,@"km"];
                
            }
                break;
            case 105:
            {
                
                label.text = [NSString stringWithFormat:@"%.0f%@",totalC,@"Kcal" ];
                
            }
                break;
            default:
                break;
        }
    }

}

@end
