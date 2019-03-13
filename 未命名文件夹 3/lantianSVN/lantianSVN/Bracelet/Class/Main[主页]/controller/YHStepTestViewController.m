//
//  YHStepTestViewController.m
//  Bracelet
//
//  Created by xieyingze on 17/1/9.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//
#import "YHStepTestViewController.h"
#import "LMGaugeView.h"

@interface YHStepTestViewController ()

@property (nonatomic, weak) LMGaugeView *circleView;

@property (nonatomic, weak) UIScrollView *backScrollView;

@property (nonatomic, strong) UILabel *stepsLabel;

@property (nonatomic, strong) UILabel * targetLabel;

@property (nonatomic, weak) UIView *backView;

@property (nonatomic, strong) UILabel *bottomStepLabel;

@property (nonatomic, strong) UILabel *calLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation YHStepTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kmainBackgroundColor;
    [self addNavWithTitle:NSLocalizedString(@"运动",nil) backButton:YES shareButton:YES];
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadBlueToothData];
}

- (void)loadUI
{
    [self backScrollView];
    [self circleView];
    [self backView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = NSLocalizedString(@"下拉同步数据",nil);
    tipLabel.textColor = KCOLOR(139, 214, 209);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.frame = CGRectMake(0, 40 * kX, ScreenW, 18);
    [self.backScrollView addSubview:tipLabel];
    
    
    UIImageView *centerImageView = [[UIImageView alloc] init];
    centerImageView.image = [UIImage imageNamed:@"steps"];
    centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.circleView addSubview:centerImageView];
    centerImageView.sd_layout.topSpaceToView(self.circleView, 40*kX)
    .centerXIs(self.circleView.width/2.)
    .widthIs(80 * kX)
    .heightIs(30 * kX);

    _stepsLabel = [[UILabel alloc] init];
    _stepsLabel.text = @"0";
    _stepsLabel.textColor = [UIColor whiteColor];
    _stepsLabel.textAlignment = NSTextAlignmentCenter;
    _stepsLabel.font = [UIFont systemFontOfSize:35];
    [self.circleView addSubview:_stepsLabel];
    _stepsLabel.sd_layout.topSpaceToView(centerImageView, 22 * kX)
    .centerXIs(self.circleView.width/2.)
    .widthIs(self.circleView.width)
    .heightIs(35 * kX);
    
    _targetLabel = [[UILabel alloc] init];
    _targetLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"目标:",nil),[XXUserInformation userSportTarget]];
    _targetLabel.textAlignment = NSTextAlignmentCenter;
    _targetLabel.font = [UIFont systemFontOfSize:18];
    _targetLabel.textColor = [UIColor whiteColor];
    [self.circleView addSubview:_targetLabel];
    _targetLabel.sd_layout.topSpaceToView(_stepsLabel, 23 * kX)
    .widthIs(self.circleView.width)
    .centerXIs(self.circleView.width/2.)
    .heightIs(28);

}

- (LMGaugeView *)circleView
{
    if (!_circleView)
    {
        LMGaugeView *lgmView = [[LMGaugeView alloc] init];
        lgmView.frame = CGRectMake(0, 0, 225 * kX, 225 * kX);
        lgmView.center = CGPointMake(ScreenW/2., 216 * kX);
        lgmView.value = 0;
        lgmView.startAngle = 3./2 * M_PI + M_PI/3600.;
        lgmView.endAngle = 3./2 * M_PI;
        lgmView.ringThickness = 9 *kX;
        lgmView.ringBackgroundColor = kmainDarkColor;
        lgmView.maxValue = [[XXUserInformation userSportTarget] intValue];

        [self.backScrollView addSubview:lgmView];
        _circleView = lgmView;
    }
    return _circleView;
}

- (UIScrollView *)backScrollView
{
    if (!_backScrollView)
    {
        UIScrollView *scroll  = [[UIScrollView alloc] init];
        scroll.frame = CGRectMake(0, 64, ScreenW, ScreenH - 64);
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.contentSize = CGSizeMake(scroll.width, scroll.height);
        [self.view addSubview:scroll];
        scroll.mj_header = [self getRefreshHeader];

        _backScrollView = scroll;
    }
    return _backScrollView;
}

- (UIView *)backView
{
    if (!_backView)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kmainBackgroundColor;
        view.layer.borderColor = KCOLOR(160, 202, 196).CGColor;
        view.layer.borderWidth = 1.0;
        view.layer.cornerRadius = 3;
        view.frame = CGRectMake(55 * kX, 430 * kX, ScreenW - 110 * kX, 114 * kX);
        [self.backScrollView addSubview:view];
        _backView = view;
        
        NSArray *nameArray = @[NSLocalizedString(@"步数",nil),NSLocalizedString(@"热量",nil),NSLocalizedString(@"距离",nil)];
        for (int i = 0 ; i < 3; i ++)
        {
            UILabel *label = [[UILabel alloc] init];
            label.text = nameArray[i];
            [label sizeToFit];
            label.textColor = [UIColor whiteColor];
            label.frame = CGRectMake(13 * kX, 13*kX + 36 * kX * i  , label.width, 25 * kX);
            [_backView addSubview:label];
        }
        
        _bottomStepLabel = [[UILabel alloc] init];
        _bottomStepLabel.text = @"0";
        _bottomStepLabel.textColor = [UIColor whiteColor];
        _bottomStepLabel.textAlignment = NSTextAlignmentRight;
        _bottomStepLabel.frame = CGRectMake(_backView.width - 200 * kX, 13 * kX, 187 * kX, 18 *kX);
        [_backView addSubview:_bottomStepLabel];
        
        _calLabel = [[UILabel alloc] init];
        _calLabel.text = @"0 Kcal";
        _calLabel.textColor = [UIColor whiteColor];
        _calLabel.textAlignment = NSTextAlignmentRight;
        _calLabel.frame = CGRectMake(_backView.width - 200 * kX, 49 * kX, 187 * kX, 18 *kX);
        [_backView addSubview:_calLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.text = @"0 Kcal";
        _distanceLabel.textColor = [UIColor whiteColor];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.frame = CGRectMake(_backView.width - 200 * kX, 85  * kX, 187 * kX, 18 *kX);
        [_backView addSubview:_distanceLabel];
    }
    return _backView;
}

- (MJRefreshNormalHeader *)getRefreshHeader
{
    kWEAKSELF;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([EirogaBlueToothManager sharedInstance].isconnected)
        {
            [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
            [weakSelf reloadBlueToothData];
            
            
        }else{
            [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            [weakSelf.backScrollView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉可以刷新",nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"松开立即刷新",nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"正在刷新数据",nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    return header;
}

- (void)reloadBlueToothData
{
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getActualDataWithDataBlockWithBlock:^(ActualDataModel *model) {
        [weakSelf.backScrollView.mj_header endRefreshing];
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(reloadOutTime) object:nil];
        
        if (model)
        {
            weakSelf.stepsLabel.text = [NSString stringWithFormat:@"%d",model.steps];
            weakSelf.bottomStepLabel.text = [NSString stringWithFormat:@"%d",model.steps];
            weakSelf.calLabel.text = [NSString stringWithFormat:@"%d %@",model.calories,@"Kcal"];
            if ([[XXUserInformation userUnit] isEqualToString:@"1"]) {
                weakSelf.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@",model.distance/1000.0,@"Km"];
            }else if ([[XXUserInformation userUnit] isEqualToString:@"2"]){
                weakSelf.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@",model.distance*0.6214/1000.0,@"mile"];
            }
            weakSelf.circleView.value = model.steps;
        }
    }];
}

- (void)reloadOutTime
{
    [self.backScrollView.mj_header endRefreshing];
    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
}

@end
