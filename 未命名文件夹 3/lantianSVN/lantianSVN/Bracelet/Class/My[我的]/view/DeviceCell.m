//
//  DeviceCell.m
//  Bracelet
//
//  Created by panzheng on 2017/5/19.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "DeviceCell.h"
#import "UILabel+Copy.h"

@implementation DeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsConnected:(BOOL)isConnected
{
    _isConnected = isConnected;
    [self loadUI];
}

- (void)setModel:(PerModel *)model
{
    _model = model;
    NSString *string = model.mac;
    NSMutableString * mutString;
    if (string && string.length > 0)
    {
        string = [string uppercaseString];
        if (string.length > 6)
        {
            mutString = [[NSMutableString alloc] initWithString:[string substringWithRange:NSMakeRange(string.length - 12, 12)]];
        }else
        {
            mutString = [[NSMutableString alloc] initWithString:string];
        }
        
        for (int i = 1; i < 6 ; i ++)
        {
            [mutString insertString:@":" atIndex:12 - 2 * i];
        }
    }
    if (mutString && mutString.length > 0)
    {
        self.macLabel.text = mutString;
    }

    CBPeripheral *per = model.per;
    self.nameLabel.text = per.name;
}

- (void)setPer:(CBPeripheral *)per
{
    self.nameLabel.text = per.name;
    self.macLabel.text = kHCH.mac;
}

- (void)loadUI
{
    [self equipmentView];
    [self nameLabel];
    [self macLabel];
    [self stateLabel];
    [self nameCopyButton];
}

- (UIImageView *)equipmentView
{
    if (!_equipmentView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];

        imageView.sd_layout.leftSpaceToView(self, 10 * kX)
        .centerYIs(self.height/2.)
        .widthIs(30 * kX)
        .heightIs(30 * kX);
        _equipmentView = imageView;
    }
    if (_isConnected)
    {
        _equipmentView.image = [UIImage imageNamed:@"myGreenEquipment"];
    }else
    {
        _equipmentView.image = [UIImage imageNamed:@"myWhiteEquipment"];
    }
    return _equipmentView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        [self addSubview:label];
        label.sd_layout.leftSpaceToView(self, 45 * kX)
        .centerYIs(self.height/4.)
        .widthIs(200)
        .heightIs(20);
        _nameLabel = label;
    }
    return _nameLabel;
}


- (UILabel *)macLabel
{
    if (!_macLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
//        label.isCopyable = YES;

        [self addSubview:label];
        _macLabel = label;
        label.sd_layout.leftSpaceToView(self,45 * kX)
        .centerYIs(self.height/4. * 3)
        .widthIs(200)
        .heightIs(20);
    }
    return _macLabel;
}

- (UIButton *)nameCopyButton
{
    if (!_nameCopyButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button setTitle:@"复制" forState: UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(copyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _nameCopyButton = button;
        [button sizeToFit];
        button.backgroundColor = kmainDarkColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.sd_layout.centerYIs(self.height/2.)
        .rightSpaceToView(_stateLabel, 12)
        .widthIs(button.width + 10)
        .heightIs(button.height);
        button.layer.cornerRadius = 5;
    }
    if (_isConnected)
    {
        _nameCopyButton.hidden = NO;
    }else
    {
        _nameCopyButton.hidden = YES;
    }
    return _nameCopyButton;
}

- (void)copyButtonClick
{
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    if (_macLabel.text)
    {
        pBoard.string = _macLabel.text;
    }
    [self makeToast:@"已复制到剪贴板"];
}

- (UILabel *)stateLabel
{
    if (!_stateLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"点击绑定";
        [label sizeToFit];
        [self addSubview:label];
        label.sd_layout.rightSpaceToView(self, 25 * kX)
        .centerYIs(self.height/2.)
        .widthIs(label.width)
        .heightIs(20);
        _stateLabel = label;
    }
    if (_isConnected)
    {
        _stateLabel.text = NSLocalizedString(@"已绑定",nil);
        _stateLabel.textColor = kmainDarkColor;
    }else
    {
        _stateLabel.text = NSLocalizedString(@"点击绑定",nil);
        _stateLabel.textColor = [UIColor lightGrayColor];
    }
    return _stateLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
