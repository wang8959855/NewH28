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
    self.view.backgroundColor = kMainColor;
}

- (void)setBackView{
    _selectShowTypeView = [[UIView alloc] init];
    [self.view addSubview:_selectShowTypeView];
    _selectShowTypeView.frame = CGRectMake(ScreenWidth/2-100, 64+12+10, 200, 40);
    _selectShowTypeView.backgroundColor = KCOLOR(214, 241, 251);
    _selectShowTypeView.layer.cornerRadius = 20.f;
    _selectShowTypeView.layer.masksToBounds = YES;
    //selectShowTypeView上的button
    _stepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stepButton.frame = CGRectMake(0, 0, 110, 40);
    [_stepButton setTitle:@"步数" forState:UIControlStateNormal];
    [_stepButton setBackgroundColor:KCOLOR(40, 82, 251)];
    [_stepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_stepButton setTitleColor:kMainColor forState:UIControlStateNormal];
    _stepButton.layer.cornerRadius = 20.f;
    _stepButton.layer.masksToBounds = YES;
    [_stepButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    _stepButton.selected = YES;
    [_selectShowTypeView addSubview:_stepButton];
    
    _workButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _workButton.frame = CGRectMake(90, 0, 110, 40);
    _workButton.layer.cornerRadius = 20.f;
    _workButton.layer.masksToBounds = YES;
    [_workButton setTitle:@"锻炼" forState:UIControlStateNormal];
    [_workButton setBackgroundColor:[UIColor clearColor]];
    [_workButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_workButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_workButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    [_selectShowTypeView addSubview:_workButton];
    
    
    CGFloat backScrollViewY = 64+42+20;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - 64 - 49;
    
    _workOutView = [[WorkOutView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _workOutView.controller = self;
    [self.view addSubview:_workOutView];
    
    _sportView = [[SportView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _sportView.controller = self;
    [self.view addSubview:_sportView];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 30, StatusBarHeight + 12, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"step1",@"step2",@"step3",@"step4",@"step5",@"step6"];
    [self.navigationController pushViewController:guide animated:YES];
}

//切换视图
- (void)changeShowView:(UIButton *)button{
    [button setBackgroundColor:KCOLOR(40, 82, 251)];
    button.selected = YES;
    if (button == _stepButton) {
        _workButton.selected = NO;
        [_workButton setBackgroundColor:[UIColor clearColor]];
        [self.view bringSubviewToFront:self.sportView];
        [self.sportView childrenTimeSecondChanged];
    }else{
        _stepButton.selected = NO;
        [_stepButton setBackgroundColor:[UIColor clearColor]];
        [self.view bringSubviewToFront:self.workOutView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
