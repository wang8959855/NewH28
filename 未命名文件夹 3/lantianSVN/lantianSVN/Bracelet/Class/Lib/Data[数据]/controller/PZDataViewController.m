//
//  PZDataViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/24.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "PZDataViewController.h"
#import "HistoryDataModel.h"
#import "sportModel.h"

@interface PZDataViewController ()

@property (nonatomic, weak) UISegmentedControl *segment;

@property (nonatomic, weak) WeekBackView *stepChartBackView;

@property (nonatomic, assign) viewDataType dataType;

@property (nonatomic, weak) UIButton *typeButton;

@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, assign) int selectedTimeSeconds;

@end

@implementation PZDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
    
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
//        TimeCallManager
        NSDate *weekDate = [NSDate dateWithTimeIntervalSince1970:kHCH.todayTimeSeconds + KONEDAYSECONDS * i];
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"E"];
        adaLog(@"周%d%@",1 + i,[weekFormatter stringFromDate:weekDate]);
        
    }
}

- (void)loadUI
{
    [self addnavTittle:nil RSSIImageView:YES shareButton:NO];
    [self segment];
    [self typeButton];

}

- (void)getSleepWeekData
{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    kWEAKSELF;
    [model getWeekSleepDataWithTimeSeconds:kHCH.todayTimeSeconds complition:^(NSArray *array) {
        weakSelf.stepChartBackView.StepArray = array;
    }];

}

- (void)getStepWeekData{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    kWEAKSELF;
    [model getWeekStepDataWithTimeSeconds:kHCH.todayTimeSeconds complition:^(NSArray *array) {
        weakSelf.stepChartBackView.StepArray = array;
    }];
}

- (void)getSleepMonthData
{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    kWEAKSELF;

    [model getMonthSleepWithTimeSeconds:kHCH.curMonthTimeSeconds completion:^(NSArray *array) {
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

- (void)getSleepYearData
{
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    kWEAKSELF;
    [model getyearSleepWithTimeSeconds:kHCH.todayTimeSeconds completion:^(NSArray *array) {
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

- (void)dataTypeChanged:(UIButton *)button
{
    [self.segment setSelectedSegmentIndex:0];
    if (self.dataType == viewDataTypeStep)
    {
        self.dataType = viewDataTypeSleep;
        [button setImage:[UIImage imageNamed:@"dataSleep"] forState:UIControlStateNormal];
        self.stepChartBackView.dataType = viewDataTypeSleep;
        self.stepChartBackView.timeType = viewTimeTypeWeek;
        [self getSleepWeekData];
    }else if (self.dataType == viewDataTypeSleep)
    {
        [self.segment removeFromSuperview];
        self.segment = nil;
        [self dateLabel];
        
        self.dataType = viewDataTypeHR;
        [button setImage:[UIImage imageNamed:@"dataHR"] forState:UIControlStateNormal];
        self.stepChartBackView.dataType = viewDataTypeHR;
        [self changeDayWithtimeSeconds:self.selectedTimeSeconds];
        
    }else if (self.dataType == viewDataTypeHR)
    {
        
        [self.dateLabel removeFromSuperview];
        self.dateLabel = nil;
        [self segment];
        
        self.dataType = viewDataTypeStep;
        [button setImage:[UIImage imageNamed:@"dataStep"] forState:UIControlStateNormal];
        self.stepChartBackView.dataType = viewDataTypeStep;
        self.stepChartBackView.timeType = viewTimeTypeWeek;
        [self getStepWeekData];
    }else if (self.dataType == viewDataTypeBP)
    {
        self.dataType = viewDataTypeStep;
        [button setImage:[UIImage imageNamed:@"dataStep"] forState:UIControlStateNormal];
        self.stepChartBackView.dataType = viewDataTypeStep;
        self.stepChartBackView.timeType = viewTimeTypeWeek;
        [self getStepWeekData];
    }
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
            if (self.dataType == viewDataTypeStep)
            {
                [self getStepWeekData];
            }else if (self.dataType == viewDataTypeSleep)
            {
                [self getSleepWeekData];
            }
        }
            break;
        case 1:
        {
            self.stepChartBackView.dataType = self.dataType;
            self.stepChartBackView.timeType = viewTimeTypeMonth;
            if (self.dataType == viewDataTypeStep)
            {
                [self getStepMonthData];
            }else if (self.dataType == viewDataTypeSleep)
            {
                [self getSleepMonthData];
            }
        }
            break;
        case 2:
        {
            self.stepChartBackView.dataType = self.dataType;
            self.stepChartBackView.timeType = viewTimeTypeYear;
            if (self.dataType == viewDataTypeStep)
            {
                [self getStepYearData];
            }else if (self.dataType == viewDataTypeSleep)
            {
                [self getSleepYearData];
            }
        }
            break;
        default:
            break;
    }
}

- (void)dateChangeClick:(UIButton *)button
{
    if (button.tag == 1)
    {
        self.selectedTimeSeconds -= KONEDAYSECONDS;
    }else
    {
        if (self.selectedTimeSeconds == kHCH.todayTimeSeconds)
        {
            return;
        }else
        {
            self.selectedTimeSeconds += KONEDAYSECONDS;
        }
    }
    
    _dateLabel.text = [self changeDateTommddeWithSeconds:self.selectedTimeSeconds];
    [self changeDayWithtimeSeconds:self.selectedTimeSeconds];
}

- (void)changeDayWithtimeSeconds:(int)timeSeconds
{
    
    HistoryDataModel *model = [[HistoryDataModel alloc]init];
    
    [model writeDateYearWithTimeSeconds:timeSeconds completion:^(userDataModel *dataModel) {
        if (dataModel)
        {
            sportModel *sportM = [NSKeyedUnarchiver unarchiveObjectWithData:dataModel.userData];
            self.stepChartBackView.StepArray = sportM.heartArray;
        }else{
            self.stepChartBackView.StepArray = nil;
        }
    }];
}

- (UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.selectedTimeSeconds = kHCH.todayTimeSeconds;
        label.text = [self changeDateTommddeWithSeconds:kHCH.todayTimeSeconds];
        label.font = [UIFont systemFontOfSize:14];
        label.userInteractionEnabled = YES;
        [self.view addSubview:label];
        label.sd_layout.centerXIs(self.view.width/2.)
        .topSpaceToView(self.view, 27)
        .widthIs(235 * kX)
        .heightIs(30);
        _dateLabel = label;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setImage:[UIImage imageNamed:@"lastDay"] forState:UIControlStateNormal];
        leftButton.tag = 1;
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftButton addTarget:self action:@selector(dateChangeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_dateLabel addSubview:leftButton];
        leftButton.sd_layout.leftSpaceToView(_dateLabel, 15 * kX)
        .topEqualToView(_dateLabel)
        .bottomEqualToView(_dateLabel)
        .widthIs(40);
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"nextDay"] forState:UIControlStateNormal];
        rightButton.tag = 2;
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightButton addTarget:self action:@selector(dateChangeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_dateLabel addSubview:rightButton];
        rightButton.sd_layout.rightSpaceToView(_dateLabel, 15 * kX)
        .topEqualToView(_dateLabel)
        .bottomEqualToView(_dateLabel)
        .widthIs(40);
        
    }
    return _dateLabel;
}

- (WeekBackView *)stepChartBackView
{
    if (!_stepChartBackView)
    {
        WeekBackView *view = [[WeekBackView alloc] init];
        [self.view addSubview:view];
        view.sd_layout.topSpaceToView(self.view, 64)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(ScreenH - 64 - self.tabBarController.tabBar.height);
        _stepChartBackView = view;
    }
    return _stepChartBackView;
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
        segment.tintColor = [UIColor whiteColor];
        segment.sd_layout.centerXIs(self.view.width/2)
        .topSpaceToView(self.view, 27)
        .widthIs(235 * kX)
        .heightIs(30);
        _segment = segment;
        
    }
    return _segment;
}

- (UIButton *)typeButton
{
    if (!_typeButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"dataStep"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dataTypeChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.sd_layout.rightSpaceToView(self.view, 6 * kX)
        .topSpaceToView(self.view, 22)
        .widthIs(44)
        .heightIs(44);
        _typeButton = button;
    }
    return _typeButton;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.dataType == viewDataTypeHR)
    {
        UITouch *touche = [touches anyObject];
        CGPoint touchePoint = [touche locationInView:self.stepChartBackView.chartView];
        if (CGRectContainsPoint(self.stepChartBackView.chartView.bounds, touchePoint))
        {

            self.stepChartBackView.toucheX = touchePoint.x;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.dataType == viewDataTypeHR)
    {
        UITouch *touche = [touches anyObject];
        CGPoint touchePoint = [touche locationInView:self.stepChartBackView.chartView];
        if (CGRectContainsPoint(self.stepChartBackView.chartView.bounds, touchePoint))
        {
            self.stepChartBackView.toucheX = touchePoint.x;
        }
    }

}

- (NSString *)changeDateTommddeWithSeconds:(int)seconds
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if (kHCH.todayTimeSeconds == self.selectedTimeSeconds)
    {
        
        return [NSString stringWithFormat:@"%@",NSLocalizedString(@"今天", nil)];
    }
    [dateFormatter setDateFormat:@"MM.dd  E"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@",dateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
