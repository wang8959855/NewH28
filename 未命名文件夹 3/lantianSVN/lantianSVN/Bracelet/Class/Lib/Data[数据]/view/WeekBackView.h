//
//  WeekBackView.h
//  Bracelet
//
//  Created by panzheng on 2017/5/24.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PZChart.h"

typedef enum : NSUInteger {
    viewTimeTypeWeek = 2,
    viewTimeTypeMonth,
    viewTimeTypeYear,
} viewTimeType;
typedef enum : NSUInteger {
    viewDataTypeStep = 5,
    viewDataTypeSleep,
    viewDataTypeHR,
    viewDataTypeBP,
} viewDataType;

@interface WeekBackView : UIView

@property (nonatomic, assign) viewTimeType timeType;

@property (nonatomic, assign) viewDataType dataType;

@property (nonatomic, copy) NSArray * StepArray;

@property (nonatomic, weak) UIView *backView;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) UILabel *valueLabel;

@property (nonatomic, weak) UIView *valuePoint;

@property (nonatomic, weak) PZChart *chartView;

@property (nonatomic, assign) float toucheX;

@property (nonatomic, assign) int totalStep;
@property (nonatomic, assign) int totalKcal;
@property (nonatomic, assign) int totalKm;

@end
