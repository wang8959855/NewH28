//
//  YHEditCell.m
//  Bracelet
//
//  Created by xieyingze on 17/1/3.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#import "YHEditCell.h"

@implementation YHEditCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self View1];
        [self View2];
        [self line1];
        [self line2];
    }
    return self;
}
-(void)setModel:(YHEditModel*)model
{
    
    self.typeLable1.text = model.titleArr[0][0];
    self.typeLable2.text = model.titleArr[0][1];
    
    self.icon1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.ImageArr[0][0]]];
    self.icon2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.ImageArr[0][1]]];
    
//    self.statusLable1.text = model.isOn[0][0];
//    self.statusLable2.text = model.isOn[0][1];
}

-(UIButton *)View1
{
    if (!_View1) {
        _View1 = [UIButton new];
        _View1.backgroundColor = [UIColor clearColor];
        [_View1 setBackgroundImage:[self imageWithColor:kmainLightColor] forState:UIControlStateHighlighted];
        
        self.icon1 = [UIImageView new];
        self.icon1.image = [UIImage imageNamed:@"ratre_lightRed"];
        self.icon1.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.View1];
        [self.View1 addSubview:self.icon1];

        self.View1.sd_layout.leftEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .widthIs(ScreenW/2.);
        
        self.icon1.sd_layout.topSpaceToView(_View1, 33 * kX)
        .centerXIs(_View1.width/2.)
        .widthIs(35 * kX)
        .heightIs(35 * kX);

        
        self.typeLable1 = [UILabel new];
        self.typeLable1.textColor = [UIColor whiteColor];
        self.typeLable1.font = [UIFont systemFontOfSize:15];
        self.typeLable1.textAlignment = NSTextAlignmentCenter;
        self.typeLable1.numberOfLines = 2;
        [self.View1 addSubview:self.typeLable1];
        self.typeLable1.sd_layout.topSpaceToView(self.icon1, 11 * kX)
        .centerXIs(_View1.width/2.)
        .widthIs(_View1.width)
        .heightIs(40);
    }
    
    return _View1;
}


-(UIButton *)View2
{
    if (!_View2) {
        _View2 = [UIButton new];
        
        _View2.backgroundColor = [UIColor clearColor];
        [_View2 setBackgroundImage:[self imageWithColor:kmainLightColor] forState:UIControlStateHighlighted];

        self.icon2 = [UIImageView new];
        self.icon2.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_View2];
        [self.View2 addSubview:self.icon2];
        
        self.View2.sd_layout.topEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .widthIs(ScreenW/2.);
        
        self.icon2.sd_layout.topSpaceToView(_View2, 33 * kX)
        .centerXIs(_View2.width/2.)
        .widthIs(35 * kX)
        .heightIs(35 * kX);

        
        self.typeLable2 = [UILabel new];
        self.typeLable2.textColor = [UIColor whiteColor];
        self.typeLable2.font = [UIFont systemFontOfSize:15];
        self.typeLable2.textAlignment = NSTextAlignmentCenter;
        self.typeLable2.numberOfLines = 2;
        [self.View2 addSubview:self.typeLable2];
        self.typeLable2.sd_layout.topSpaceToView(_icon2, 11 * kX)
        .centerXIs(_View2.width/2.)
        .widthIs(_View2.width)
        .heightIs(40);
    }
    return _View2;
}

-(UIView *)line1
{
    if (!_line1) {
        _line1 = [UIView new];
        _line1.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_line1];
        _line1.sd_layout.topEqualToView(self.contentView)
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .heightIs(0.5f);
    }
    
    return _line1;
}
-(UIView *)line2
{
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_line2];
        _line2.sd_layout.topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .widthIs(0.5f)
        .centerXIs(ScreenW/2.);
    }
    return _line2;
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

@end
