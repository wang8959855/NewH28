//
//  NewSportDetailViewController.m
//  Bracelet
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "NewSportDetailViewController.h"
#import "WeekBackView.h"
#import "HistoryDataModel.h"
#import "sportModel.h"

@interface NewSportDetailViewController ()

@property (nonatomic, weak) UISegmentedControl *segment;

@property (nonatomic, weak) WeekBackView *stepChartBackView;

@property (nonatomic, assign) viewDataType dataType;

@property (nonatomic, weak) UIButton *typeButton;

@end

@implementation NewSportDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavWithTitle:@"运动" backButton:YES shareButton:YES];
    [self loadUI];
}
- (void)loadUI{
    [self segment];
    [self typeButton];
    [self stepChartBackView];
    self.stepChartBackView.dataType = viewDataTypeStep;
    self.stepChartBackView.timeType = viewTimeTypeWeek;
    [self getStepWeekData];
    self.dataType = viewDataTypeStep;
    
    for ( int i = 0 ; i < 12; i ++)
    {
        NSString *string = [NSString stringWithFormat:@"2017%02d01",i+1];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:string];
        adaLog(@"%@",date);
        [formatter setDateFormat:@"MMM"];
        adaLog(@"%d月%@",i + 1,[formatter stringFromDate:date]);
        NSDate *weekDate = [NSDate dateWithTimeIntervalSince1970:kHCH.todayTimeSeconds + KONEDAYSECONDS * i];
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"E"];
        adaLog(@"周%d%@",1 + i,[weekFormatter stringFromDate:weekDate]);
    }
}

- (void)getStepWeekData{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    kWEAKSELF;
    [model getWeekStepDataWithTimeSeconds:kHCH.todayTimeSeconds complition:^(NSArray *array) {
        weakSelf.stepChartBackView.StepArray = array;
    }];
}

-(void)getStepMonthData
{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    kWEAKSELF;
    [model getMonthDataWithTimeSeconds:kHCH.curMonthTimeSeconds completion:^(NSArray *array) {
        weakSelf.stepChartBackView.StepArray = array;
    }];
}

- (void)getStepYearData
{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    kWEAKSELF;
    [model getyeahDataWithTimeSeconds:kHCH.todayTimeSeconds completion:^(NSArray *array) {
        weakSelf.stepChartBackView.StepArray = array;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentValueChanged:(UISegmentedControl *)segment
{
    [self stepChartBackView];
    switch (segment.selectedSegmentIndex)
    {
        case 0:
        {
            self.stepChartBackView.dataType = self.dataType;
            self.stepChartBackView.timeType = viewTimeTypeWeek;
            [self getStepWeekData];
        }
            break;
        case 1:
        {
            self.stepChartBackView.dataType = self.dataType;
            self.stepChartBackView.timeType = viewTimeTypeMonth;
            [self getStepMonthData];
        }
            break;
        case 2:
        {
            self.stepChartBackView.dataType = self.dataType;
            self.stepChartBackView.timeType = viewTimeTypeYear;
            [self getStepYearData];
        }
            break;
        default:
            break;
    }
}

- (UISegmentedControl *)segment
{
    if (!_segment)
    {
        UISegmentedControl *segment = [[UISegmentedControl alloc] init];
        [self.view addSubview:segment];
        [segment insertSegmentWithTitle:NSLocalizedString(@"周",nil) atIndex:0 animated:NO];
        [segment insertSegmentWithTitle:NSLocalizedString(@"月",nil) atIndex:1 animated:NO];
        [segment insertSegmentWithTitle:NSLocalizedString(@"年",nil) atIndex:2 animated:NO];
        [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        [segment setSelectedSegmentIndex:0];
        segment.tintColor = kMainColor;
        segment.sd_layout.xIs(20).topSpaceToView(self.view, 18+64)
        .widthIs(300 * kX)
        .heightIs(35);
        _segment = segment;
        
    }
    return _segment;
}

- (UIButton *)typeButton{
    if (!_typeButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yundong-new"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.sd_layout.rightSpaceToView(self.view, 6 * kX)
        .topSpaceToView(self.view, 15+64)
        .widthIs(44)
        .heightIs(44);
        _typeButton = button;
    }
    return _typeButton;
}

- (WeekBackView *)stepChartBackView
{
    if (!_stepChartBackView)
    {
        WeekBackView *view = [[WeekBackView alloc] init];
        [self.view addSubview:view];
        view.totalStep = self.totalStep;
        view.totalKcal = self.totalKcal;
        view.totalKm = self.totalKm;
        view.sd_layout.topSpaceToView(self.view, 64 + 64)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(ScreenH - 64 - 64);
        _stepChartBackView = view;
    }
    return _stepChartBackView;
}

@end
