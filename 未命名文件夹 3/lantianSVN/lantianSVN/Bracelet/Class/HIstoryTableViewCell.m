//
//  HIstoryTableViewCell.m
//  Bracelet
//
//  Created by panzheng on 2017/6/1.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "HIstoryTableViewCell.h"

@implementation HIstoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"0.00Km";
        label.font = [UIFont systemFontOfSize:20];
        [self addSubview:label];
        label.sd_layout.leftSpaceToView(self, 14 * kX)
        .topSpaceToView(self, 14 * kX)
        .widthIs(self.width)
        .heightIs(20);
        _distanceLabel = label;
    }
    return _distanceLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];

        _timeLabel = label;
    }
    return _timeLabel;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel)
    {
        UIImageView *timeImageView = [[UIImageView alloc] init];
        timeImageView.image = [UIImage imageNamed:@"traTime"];
        timeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:timeImageView];
        timeImageView.sd_layout.leftSpaceToView(self.timeLabel, 0)
        .topEqualToView(_timeLabel)
        .bottomEqualToView(_timeLabel)
        .widthIs(_timeLabel.height*1.8);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        _durationLabel = label;
        
    }
    return _durationLabel;
}


- (UILabel *)speedLabel
{
    if (!_speedLabel)
    {
        UIImageView *timeImageView = [[UIImageView alloc] init];
        timeImageView.image = [UIImage imageNamed:@"traDistance"];
        timeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:timeImageView];
        timeImageView.sd_layout.leftSpaceToView(self.durationLabel, 0)
        .topEqualToView(_durationLabel)
        .bottomEqualToView(_durationLabel)
        .widthIs(_timeLabel.height*2.2);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        _speedLabel = label;
    }
    return _speedLabel;
}

- (void)setModel:(TrajectoryModel *)model{
    _model = model;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@",model.distance/1000.0,@"Km"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.beginTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"dd%@ HH:mm:ss",NSLocalizedString(@"日",nil)]];
    self.timeLabel.text = [formatter stringFromDate:date];
    [self.timeLabel sizeToFit];
    self.timeLabel.sd_layout.bottomSpaceToView(self, 8 * kX)
    .leftSpaceToView(self, 14 * kX)
    .widthIs(self.timeLabel.width)
    .heightIs(self.timeLabel.height);
    
    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",model.duration/3600,model.duration/60,model.duration%60];
    [self.durationLabel sizeToFit];
    self.durationLabel.sd_layout.leftSpaceToView(_timeLabel, _timeLabel.height * 1.8)
    .topEqualToView(_timeLabel)
    .bottomEqualToView(_timeLabel)
    .widthIs(_durationLabel.width);
    
    self.speedLabel.text = [NSString stringWithFormat:@"%.1f",model.distance / model.duration];
    [self.speedLabel sizeToFit];
    self.speedLabel.sd_layout.leftSpaceToView(_durationLabel, _timeLabel.height * 2.2)
    .topEqualToView(_timeLabel)
    .bottomEqualToView(_timeLabel)
    .widthIs(self.speedLabel.width);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
