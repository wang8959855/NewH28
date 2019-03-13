//
//  MainPageCollectionReusableView.h
//  Bracelet
//
//  Created by panzheng on 2017/5/10.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMGaugeView.h"
#import "ActualDataModel.h"

@interface MainPageCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) LMGaugeView *circleView;

@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, strong) ActualDataModel *model;

@property (nonatomic, strong) UILabel *stepsLabel;

@property (nonatomic, strong) UILabel * targetLabel;

@property (nonatomic, strong) UILabel * calLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, assign) int maxValue;

@end
