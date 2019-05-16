//
//  HeartRateDetailViewController.m
//  Bracelet
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "HeartRateDetailViewController.h"
#import "WeekBackView.h"
#import "HistoryDataModel.h"
#import "sportModel.h"

@interface HeartRateDetailViewController ()

@property (nonatomic, weak) WeekBackView *stepChartBackView;

@property (nonatomic, assign) viewDataType dataType;

@property (nonatomic, weak) UIButton *typeButton;

@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, assign) int selectedTimeSeconds;

@end

@implementation HeartRateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavWithTitle:@"心率" backButton:YES shareButton:YES];
    [self loadUI];
}

- (void)loadUI{
    [self typeButton];
    self.dataType = viewDataTypeHR;
    self.stepChartBackView.dataType = viewDataTypeHR;
    [self changeDayWithtimeSeconds:kHCH.todayTimeSeconds];
    [self stepChartBackView];
    [self dateLabel];
    
}

- (void)changeDayWithtimeSeconds:(int)timeSeconds {
    
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
    [self changeDayWithtimeSeconds:kHCH.todayTimeSeconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)typeButton
{
    if (!_typeButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"xinlv-new"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.sd_layout.rightSpaceToView(self.view, 6 * kX)
        .topSpaceToView(self.view, 15+SafeAreaTopHeight)
        .widthIs(44)
        .heightIs(44);
        _typeButton = button;
    }
    return _typeButton;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.selectedTimeSeconds = kHCH.todayTimeSeconds;
        label.text = [self changeDateTommddeWithSeconds:kHCH.todayTimeSeconds];
        label.font = [UIFont systemFontOfSize:14];
        label.userInteractionEnabled = YES;
        [self.view addSubview:label];
        label.sd_layout.xIs(20)
        .topSpaceToView(self.view, 18+SafeAreaTopHeight)
        .widthIs(300 * kX)
        .heightIs(35);
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
        view.sd_layout.topSpaceToView(self.view, SafeAreaTopHeight+25)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(ScreenH - SafeAreaTopHeight - 25);
        _stepChartBackView = view;
    }
    return _stepChartBackView;
}

- (NSString *)changeDateTommddeWithSeconds:(int)seconds {
    
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

@end
