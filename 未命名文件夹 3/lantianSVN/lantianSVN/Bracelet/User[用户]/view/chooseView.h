//
//  chooseView.h
//  Bracelet
//
//  Created by panzheng on 2017/5/22.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chooseView : UIView
typedef NS_ENUM(int, viewType) {
    viewTypeHeight = 1,
    viewTypeWeight,
    viewTypeGender,
    viewTypeBirthDay,
    viewTypeUnit,
};

typedef void(^buttonClick)(chooseView * view);

@property (nonatomic, assign) viewType type;

@property (nonatomic, weak) UIView *centerView;

@property (nonatomic, weak) UIViewController * delegate;

@property (nonatomic, weak) UILabel * titleLabel;

@property (nonatomic, weak) UILabel * valueLabel;

@property (nonatomic, assign) int value;

@property (nonatomic, copy) buttonClick buttonHandle;

@property (nonatomic, weak) UIButton *maleButton;

@property (nonatomic, weak) UIButton *femaleButton;

@property (nonatomic, weak) UIDatePicker *datePicker;

@property (nonatomic, weak) UIButton *metricButton;

@property (nonatomic, weak) UIButton *imperialButton;

@end
