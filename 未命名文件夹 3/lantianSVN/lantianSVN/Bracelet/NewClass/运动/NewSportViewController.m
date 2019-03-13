//
//  NewSportViewController.m
//  Bracelet
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "NewSportViewController.h"
#import "WorkOutView.h"
#import "SportView.h"

@interface NewSportViewController ()

//选择显示类型的view
@property (nonatomic, strong) UIView *selectShowTypeView;
//步数
@property (nonatomic, strong) UIButton *stepButton;
//锻炼
@property (nonatomic, strong) UIButton *workButton;

@property (nonatomic, strong) SportView *sportView;

@property (nonatomic, strong) WorkOutView *workOutView;

@end

@implementation NewSportViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.sportView childrenTimeSecondChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addnavTittle:@"运动" RSSIImageView:YES shareButton:YES];
    [self setBackView];
}

- (void)setBackView{
    _selectShowTypeView = [[UIView alloc] init];
    _selectShowTypeView.frame = CGRectMake(ScreenWidth/2-50, 64+12, 100, 30);
    [self.view addSubview:_selectShowTypeView];
    _selectShowTypeView.layer.borderWidth = 1;
    _selectShowTypeView.layer.borderColor = kColor(210, 210, 210).CGColor;
    _selectShowTypeView.layer.cornerRadius = 15.f;
    _selectShowTypeView.layer.masksToBounds = YES;
    //selectShowTypeView上的button
    _stepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stepButton.frame = CGRectMake(0, 0, 50, 30);
    [_stepButton setTitle:@"步数" forState:UIControlStateNormal];
    [_stepButton setBackgroundColor:kMainColor];
    [_stepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_stepButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_stepButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    _stepButton.selected = YES;
    [_selectShowTypeView addSubview:_stepButton];
    
    _workButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _workButton.frame = CGRectMake(50, 0, 50, 30);
    [_workButton setTitle:@"锻炼" forState:UIControlStateNormal];
    [_workButton setBackgroundColor:[UIColor whiteColor]];
    [_workButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_workButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_workButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    [_selectShowTypeView addSubview:_workButton];
    
    
    CGFloat backScrollViewY = 64+42;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - 64 - 49;
    
    _workOutView = [[WorkOutView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _workOutView.controller = self;
    [self.view addSubview:_workOutView];
    
    _sportView = [[SportView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _sportView.controller = self;
    [self.view addSubview:_sportView];
    
}

//切换视图
- (void)changeShowView:(UIButton *)button{
    [button setBackgroundColor:kMainColor];
    button.selected = YES;
    if (button == _stepButton) {
        _workButton.selected = NO;
        [_workButton setBackgroundColor:[UIColor whiteColor]];
        [self.view bringSubviewToFront:self.sportView];
        [self.sportView childrenTimeSecondChanged];
    }else{
        _stepButton.selected = NO;
        [_stepButton setBackgroundColor:[UIColor whiteColor]];
        [self.view bringSubviewToFront:self.workOutView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
