//
//  SportView.h
//  Wukong
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "BaseView.h"
#import "LMGaugeView1.h"

@interface SportView : BaseView

@property (nonatomic, strong) UIViewController *controller;

@property (strong, nonatomic) UILabel *heartRateLabel;

@property (strong, nonatomic) UILabel *caloriesLabel;

@property (strong, nonatomic) UILabel *distanceLabel;

//平均心率
@property (strong, nonatomic) UILabel *activeTimeLabel;

@property (strong, nonatomic) LMGaugeView1 *circle;

@property (strong, nonatomic) UIScrollView *backScrollView;  //大部分内容在这个上面

//@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIButton *targetBtn;

- (void)childrenTimeSecondChanged;

@end
