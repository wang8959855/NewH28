//
//  XXPickerView.m
//  XXPickerView
//
//  Created by wangwendong on 16/1/8.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import "XXPickerView.h"

#define kHEIGHT 50

@interface XXPickerView ()

@property (strong, nonatomic) UIView *mCenterView;

@property (strong, nonatomic) NSLayoutConstraint *mCenterViewHeightConstraint;

@property (strong, nonatomic) UIView *centerMaskView;

@end

@implementation XXPickerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDidInit];
    }
    return self;
}

- (void)setupDidInit {
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _mCenterView = [[UIView alloc] init];
    _mCenterView.backgroundColor = [UIColor clearColor];
    _mCenterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_mCenterView];
    
    _mPickerView = [[UIPickerView alloc] init];
    _mPickerView.backgroundColor = [UIColor clearColor];
    _mPickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_mPickerView];

    _mPickerView.sd_layout.topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .widthIs(ScreenW)
    .bottomEqualToView(self);

    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mCenterView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mCenterView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mCenterView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.f constant:0]];
    _mCenterViewHeightConstraint =[NSLayoutConstraint constraintWithItem:_mCenterView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
    [self addConstraint:_mCenterViewHeightConstraint];
  
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mPickerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mPickerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mPickerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mPickerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource {
    _dataSource = dataSource;
    _mPickerView.dataSource = dataSource;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate {
    _delegate = delegate;
    _mPickerView.delegate = delegate;
    
    if ([_delegate respondsToSelector:@selector(pickerView:rowHeightForComponent:)]) {
        CGFloat height = [_delegate pickerView:_mPickerView rowHeightForComponent:0];
        if (height > 0) {
            _mCenterViewHeightConstraint.constant = height;
        }
    }
}

- (void)setupCenterViewColor:(UIColor *)aColor {
    if (aColor) {
        _mCenterView.backgroundColor = aColor;
    }
}

@end
