//
//  HistoryViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/6/1.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "HistoryViewController.h"
#import "HIstoryTableViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mkMapView;

@property (nonatomic, strong) MKPolyline *mkPolyline;

@property (nonatomic, weak) UIView * backView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}



- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"运动记录",nil) backButton:YES shareButton:NO];
    
    [self totalDistanceLabel];
    UILabel *distanceUnit = [[UILabel alloc] init];
    distanceUnit.font = [UIFont systemFontOfSize:15];
    distanceUnit.textColor = [UIColor grayColor];
    distanceUnit.textAlignment = NSTextAlignmentCenter;
    distanceUnit.text = NSLocalizedString(@"距离(Km)",nil);
    [self.view addSubview:distanceUnit];
    distanceUnit.sd_layout.topSpaceToView(_totalDistanceLabel, 10 * kX)
    .centerXIs(self.view.width/2.)
    .widthIs(self.view.width)
    .heightIs(20);
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    lineView.sd_layout.centerXIs(self.view.width/2.)
    .widthIs(0.5)
    .topSpaceToView(distanceUnit, 15 * kX)
    .heightIs(40 * kX);
    
    [self costLabel];
    
    CGFloat tableTop = 0;
    if (IsIphone6Plus_Device) {
        tableTop = 30;
    }else if (iPhoneX){
        tableTop = 40;
    }else{
        tableTop = 20;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.sd_layout.leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(lineView, tableTop * kX)
    .bottomEqualToView(self.view);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[HIstoryTableViewCell class] forCellReuseIdentifier:@"CELL"];
    
}

- (void)setDictionary:(NSDictionary *)dictionary
{
    _dictionary = dictionary;
    float totalDistance = 0;
    int count = 0;
    NSArray *array = dictionary.allValues;
    for (int i = 0;  i < array.count; i ++)
    {
        NSArray *detailArray = array[i];
        for (int idx = 0; idx < detailArray.count; idx ++)
        {
            TrajectoryModel *model = detailArray[idx];
            totalDistance += model.distance;
            count += 1;
        }
    }
    self.totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f",totalDistance/1000.0];
    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
    
    float stride = 0.0;
    adaLog(@"%@",kHCH.userInfoModel.gender);
    if ([kHCH.userInfoModel.gender isEqualToString:@"1"])
    {
        stride = (0.415 * [kHCH.userInfoModel.height floatValue]) / 100.0;
    }else if ([kHCH.userInfoModel.gender isEqualToString:@"2"])
    {
        stride = (0.413) * [kHCH.userInfoModel.height floatValue] / 100.0;
    }
    float singleCal = ([kHCH.userInfoModel.weight floatValue] - 15) * 0.000693 + 0.005895;
    float steps = totalDistance/stride;
    float cost = singleCal * steps;
    self.costLabel.text = [NSString stringWithFormat:@"%.2f",cost];
    
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dictionary.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30 * kX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    view.frame = CGRectMake(0, 0, self.view.width, 30 * kX);
    
    UILabel *label = [[UILabel alloc] init];
    NSArray *result = [_dictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1]; //降序
    }];
    label.text = result[section];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    label.sd_layout.leftSpaceToView(view, 12 * kX)
    .topEqualToView(view)
    .bottomEqualToView(view)
    .rightEqualToView(view);
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *result = [_dictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1]; //降序
    }];
    NSArray *array = _dictionary[result[section]];
    NSLog(@"result=%@",result);
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HIstoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    NSArray *result = [_dictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1]; //降序
    }];
    NSArray *array = _dictionary[result[indexPath.section]];
    cell.model = array[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70 * kX;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HIstoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:cell.model.arrayData];

    if (!_backView)
    {
        UIView *backView = [[UIView alloc] init];
        _backView = backView;
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH - 20);
        [self.view addSubview:_backView];
        
        UIView *topView = [[UIView alloc] init];
        topView.frame = CGRectMake(0, 0, ScreenW, 44);
        topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [_backView addSubview:topView];
        
        UIButton * cancelButton = [[UIButton alloc] init];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
        [topView addSubview:cancelButton];
        [cancelButton sizeToFit];
        cancelButton.frame = CGRectMake(12, 0, cancelButton.width, 44);
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, ScreenW, ScreenH)];
        _mkMapView.mapType = MKMapTypeStandard;
        _mkMapView.showsUserLocation = NO;
        _mkMapView.delegate = self;
        [_backView addSubview:_mkMapView];

        if (_mkMapView)
        {
            if (array.count > 0)
            {
                CLLocation *beginLocation = array[0];
                MKCoordinateSpan span = MKCoordinateSpanMake(0.0008, 0.0005);
                MKCoordinateRegion  region= MKCoordinateRegionMake(beginLocation.coordinate, span);
                [_mkMapView setRegion:region animated:NO];
                
                CLLocationCoordinate2D commonPolylineCoords[array.count];
                for (int i = 0 ; i < array.count; i ++)
                {
                    CLLocation *historyLocation = array[i];
                    commonPolylineCoords[i] = historyLocation.coordinate;
                }
                self.mkPolyline = [MKPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
                [_mkMapView addOverlay: _mkPolyline];
            }
        }

        [UIView animateWithDuration:0.35 animations:^{
            _backView.frame =CGRectMake(0, 20, ScreenW, ScreenH - 20);
        } completion:nil];
    }else
    {
        [UIView animateWithDuration:0.35 animations:^{
            _backView.frame =CGRectMake(0, 20, ScreenW, ScreenH - 20);
        } completion:nil];
    }
}

- (void)cancelButtonClick
{
    [UIView animateWithDuration:0.35 animations:^{
        _backView.frame = CGRectMake(0, ScreenH, _backView.width, _backView.height);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        self.backView = nil;
    }];
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolyline class]]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        MKPolylineView *polyLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polyLineView.lineWidth = 8.0; //折线宽度
        polyLineView.strokeColor = [UIColor blueColor]; //折线颜色
        return (MKOverlayRenderer *)polyLineView;
#pragma clang diagnostic pop
    }
    return nil;
}

#pragma mark -- GET方法
- (UILabel *)totalDistanceLabel
{
    if (!_totalDistanceLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:25];
        label.text = @"0.00";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        [label sizeToFit];
        label.sd_layout.topSpaceToView(self.view, 64 + 27 * kX)
        .centerXIs(self.view.width/2.)
        .widthIs(self.view.width)
        .heightIs(label.height);
        _totalDistanceLabel = label;
    }
    return _totalDistanceLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0";
        [self.view addSubview:label];
        label.sd_layout.topSpaceToView(self.view, 182 * kX)
        .centerXIs(self.view.width/4.)
        .widthIs(self.view.width/2.)
        .heightIs(18);
        _countLabel = label;
        
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.text = NSLocalizedString(@"总次数(次)",nil);
        unitLabel.textAlignment = NSTextAlignmentCenter;
        unitLabel.font = [UIFont systemFontOfSize:13];
        unitLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:unitLabel];
        unitLabel.sd_layout.topSpaceToView(label, 8 * kX)
        .centerXEqualToView(label)
        .widthIs(self.view.width/2.)
        .heightIs(15);
    }
    return _countLabel;
}

- (UILabel *)costLabel
{
    if (!_costLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0";
        [self.view addSubview:label];
        label.sd_layout.topSpaceToView(self.view, 182 * kX)
        .rightSpaceToView(self.view, 0)
        .widthIs(self.view.width/2.)
        .heightIs(18);
        _costLabel = label;
        
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.text = NSLocalizedString(@"总消耗(Kcal)",nil);
        unitLabel.textAlignment = NSTextAlignmentCenter;
        unitLabel.font = [UIFont systemFontOfSize:13];
        unitLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:unitLabel];
        unitLabel.sd_layout.topSpaceToView(label, 8 * kX)
        .centerXEqualToView(label)
        .widthIs(self.view.width/2.)
        .heightIs(15);
    }
    return _costLabel;
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
