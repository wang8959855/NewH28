//
//  BTHomeContentsCell.m
//  XYZBluetooth
//
//  Created by 谢英泽 on 2016/11/27.
//  Copyright © 2016年 谢英泽. All rights reserved.
//

#import "BTHomeContentsCell.h"
#import "UILabel+Style.h"

@interface BTHomeContentsCell ()

@property (nonatomic, weak) UIImageView *picImageView;

@property (nonatomic, weak) UILabel *contentsLabel;

@property (nonatomic, weak) UIView *rightLine;

@end

@implementation BTHomeContentsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:kCOLOR_white];
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView
{
    
    UIView *topLine = [[UIView alloc] init];
    topLine.frame = CGRectMake(0, 0, self.width, 0.5);
    topLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.frame = CGRectMake(0, self.height, self.width, 0.5);
    bottomLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomLine];
}

- (void)setRow:(int)row
{
    _row = row;
    if (row % 2)
    {
        [self.rightLine removeFromSuperview];
        self.rightLine = nil;
    }else
    {
        UIView *view = [[UIView alloc] init];
        _rightLine = view;
        _rightLine.frame = CGRectMake(self.contentView.width - 0.5, 0, 0.5, self.height);
        _rightLine.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_rightLine];

    }
    [self contentsLabel];
    [self picImageView];

}

#pragma mark - Setter && Getter



- (UIImageView *)picImageView
{
    NSArray *imageArray = @[@"mainSport",@"mainHR",@"mainSleep",@"mainPhoto",@"mainMap",@"mainBlood"];

    NSArray *myImageArray = @[@"myEquipment",@"myInfo",@"myTarget",@"myOTA",@"myPen",@"myAbout",@"myLogOut"];
    if (!_picImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 30 * kX, self.width, 35*kX);
        [self.contentView addSubview:imageView];
        
        _picImageView = imageView;
        _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    if (!_isMy)
    {
        _picImageView.image = [UIImage imageNamed:imageArray[_row]];
    }else
    {
        _picImageView.image = [UIImage imageNamed:myImageArray[_row]];
    }
    return _picImageView;
}

- (UILabel *)contentsLabel
{
    NSArray * titleArray = @[NSLocalizedString(@"运动",nil),NSLocalizedString(@"心率",nil),NSLocalizedString(@"睡眠",nil),NSLocalizedString(@"拍照",nil),NSLocalizedString(@"轨迹",nil),NSLocalizedString(@"血压",nil)];

    NSArray *myTitleArray = @[NSLocalizedString(@"我的设备",nil),NSLocalizedString(@"我的资料",nil),NSLocalizedString(@"个人目标",nil),NSLocalizedString(@"手环固件升级",nil),NSLocalizedString(@"意见反馈",nil),NSLocalizedString(@"关于",nil),NSLocalizedString(@"退出登录",nil)];
    
    NSString *title;
    if (!_contentsLabel) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 85 * kX, self.width, 20);
        [self.contentView addSubview:label];
        _contentsLabel = label;
        [_contentsLabel setLabelStyle:title textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:18] texrAlignment:NSTextAlignmentCenter];
    }
    
    if (!_isMy)
    {
        title = titleArray[_row];
    }else
    {
        title = myTitleArray[_row];
    }
    _contentsLabel.text = title;

    return _contentsLabel;
}

@end

