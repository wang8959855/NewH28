//
//  MainPageCollectionReusableView.m
//  Bracelet
//
//  Created by panzheng on 2017/5/10.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "MainPageCollectionReusableView.h"

@implementation MainPageCollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self dateLabel];
    [self circleView];
    
    UIImageView *centerImageView = [[UIImageView alloc] init];
    centerImageView.image = [UIImage imageNamed:@"steps"];
    centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.circleView addSubview:centerImageView];
    centerImageView.sd_layout.topSpaceToView(self.circleView, 43*kX)
    .centerXIs(self.circleView.width/2.)
    .widthIs(70 * kX)
    .heightIs(28 * kX);
    
    _stepsLabel = [[UILabel alloc] init];
    _stepsLabel.text = @"0";
    _stepsLabel.textColor = [UIColor whiteColor];
    _stepsLabel.textAlignment = NSTextAlignmentCenter;
    _stepsLabel.font = [UIFont systemFontOfSize:30];
    [self.circleView addSubview:_stepsLabel];
    _stepsLabel.sd_layout.topSpaceToView(centerImageView, 15 * kX)
    .centerXIs(self.circleView.width/2.)
    .widthIs(self.width)
    .heightIs(28 * kX);
    
    _targetLabel = [[UILabel alloc] init];
    _targetLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"目标:",nil),[XXUserInformation userSportTarget]];
    _targetLabel.textAlignment = NSTextAlignmentCenter;
    _targetLabel.font = [UIFont systemFontOfSize:13];
    _targetLabel.textColor = [UIColor whiteColor];
    [self.circleView addSubview:_targetLabel];
    _targetLabel.sd_layout.topSpaceToView(_stepsLabel, 11 * kX)
    .widthIs(self.width)
    .centerXIs(self.circleView.width/2.)
    .heightIs(20);
    
    UIImageView *calImageView = [[UIImageView alloc] init];
    calImageView.image = [UIImage imageNamed:@"calImage"];
    calImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:calImageView];
    calImageView.sd_layout.leftSpaceToView(self, 28 * kX)
    .bottomSpaceToView(self, 13 * kX)
    .widthIs(21 * kX)
    .heightIs(30 * kX);
    
    _calLabel = [[UILabel alloc] init];
    _calLabel.text = @"0 Kcal";
    _calLabel.textColor = [UIColor whiteColor];
    [self addSubview:_calLabel];
    _calLabel.sd_layout.leftSpaceToView(calImageView, 13* kX)
    .bottomEqualToView(calImageView)
    .widthIs(self.width/2.)
    .heightIs(20 *kX);
    
    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.text = [NSString stringWithFormat:@"0 %@",[self getUnit]];
    _distanceLabel.textColor = [UIColor whiteColor];
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_distanceLabel];
    _distanceLabel.sd_layout.rightSpaceToView(self, 10*kX)
    .bottomEqualToView(calImageView)
    .widthIs(80)
    .heightIs(20 * kX);
    
    UIImageView *distanceImageView = [[UIImageView alloc] init];
    distanceImageView.image = [UIImage imageNamed:@"distance"];
    distanceImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:distanceImageView];
    distanceImageView.sd_layout.rightSpaceToView(_distanceLabel, 4)
    .bottomEqualToView(calImageView)
    .widthIs(35 * kX)
    .heightIs(30 * kX);
    
}

- (NSString *)getUnit
{
    NSString *unit;
    if ([[XXUserInformation userUnit] isEqualToString:@"1"]) {
        unit = @"Km";
    }else if ([[XXUserInformation userUnit] isEqualToString:@"2"]){
        unit = @"mile";
    }
    return unit;
}

- (void)setModel:(ActualDataModel *)model
{
    if (model)
    {
        self.circleView.value = model.steps;
        self.stepsLabel.text = [NSString stringWithFormat:@"%d",model.steps];
        self.calLabel.text = [NSString stringWithFormat:@"%d Kcal",model.calories];
        kWEAKSELF;
        if ([[XXUserInformation userUnit] isEqualToString:@"1"]) {
            weakSelf.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@",model.distance/1000.0,@"Km"];
        }else if ([[XXUserInformation userUnit] isEqualToString:@"2"]){
            weakSelf.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@",model.distance*0.6214/1000.0,@"mile"];
        }
        _model = model;
    }
}


- (void)setMaxValue:(int)maxValue
{
    _maxValue = maxValue;
    _circleView.maxValue = maxValue;
    _targetLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"目标:",nil),[XXUserInformation userSportTarget]];
}
- (LMGaugeView *)circleView
{
    if (!_circleView)
    {
        LMGaugeView *lgmView = [[LMGaugeView alloc] init];
        lgmView.frame = CGRectMake(0, 0, 185 * kX, 185 * kX);
        lgmView.center = CGPointMake(ScreenW/2., self.height/2.);
        lgmView.value = 0;
        lgmView.startAngle = 3./2 * M_PI + M_PI/3600.;
        lgmView.endAngle = 3./2 * M_PI;
        lgmView.ringThickness = 7 *kX;
        lgmView.ringBackgroundColor = kmainDarkColor;
        lgmView.maxValue = [[XXUserInformation userSportTarget] intValue];

        [self addSubview:lgmView];
        _circleView = lgmView;
    }
    return _circleView;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"今天",nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(0, 0, ScreenW, 30);
        [self addSubview:label];
        _dateLabel = label;
    }
    return _dateLabel;
}

@end
