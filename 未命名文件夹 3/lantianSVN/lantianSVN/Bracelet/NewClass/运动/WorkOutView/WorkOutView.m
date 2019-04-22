//
//  WorkOutView.m
//  Bracelet
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "WorkOutView.h"
#import "PSDrawerManager.h"
#import "WHC_ModelSqlite.h"
#import "HistoryViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZCChinaLocation.h"
#import "WGS84TOGCJ02.h"

@interface WorkOutView ()<CAAnimationDelegate,MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, weak) CALayer *stopLayer;

@property (nonatomic, strong) MKMapView *mkMapView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) MKPolyline *mkPolyline;



@end

@implementation WorkOutView

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = allColorWhite;
        [[PSDrawerManager instance] beginDragResponse];
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    bgView.backgroundColor = kMainColor;
    [self addSubview:bgView];
    
    [self gpsStateLabel];
    [self distanceLabel];
    [self timeLabel];
    [self speedLabel];
    [self locus];
    
//    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [historyButton setTitleColor:kmainBackgroundColor forState:UIControlStateNormal];
//    [historyButton setTitle:NSLocalizedString(@"运动轨迹",nil) forState:UIControlStateNormal];
//    [historyButton addTarget:self action:@selector(historyClick) forControlEvents:UIControlEventTouchUpInside];
//    [historyButton sizeToFit];
//    historyButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self addSubview:historyButton];
//    historyButton.layer.borderColor = kmainBackgroundColor.CGColor;
//    historyButton.layer.borderWidth = 1;
//    historyButton.layer.cornerRadius = 9;
//    historyButton.sd_layout.topSpaceToView(self, 436 * kX)
//    .centerXIs(self.width/2.)
//    .widthIs(historyButton.width)
//    .heightIs(40 * kX);
    [self beginBtn];
    
}

#pragma mark -- 按钮点击方法

- (void)historyClick
{
    NSString *orderSql = @"by beginTime desc";
    
    NSArray *array = [WHC_ModelSqlite query:[TrajectoryModel class] order:orderSql];
    if (array && array.count > 0) {
        HistoryViewController *historyVC = [[HistoryViewController alloc] init];
        historyVC.view.backgroundColor = [UIColor whiteColor];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < array.count; i ++) {
            TrajectoryModel *model = array[i];
            int month = [[TimeCallManager getInstance] getMonthNumberWithTimeSeconds:model.beginTime];
            NSString * year = [[TimeCallManager getInstance] getYearWithSecond:model.beginTime];
            NSString *monthString = [NSString stringWithFormat:@"%@-%02d",year,month];
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dic[monthString]] ;
            if (array && array.count != 0)
            {
                [array addObject:model];
                [dic setObject:array forKey:monthString];
            }else{
                NSMutableArray * newArray = [[NSMutableArray alloc] init];
                [newArray addObject:model];
                [dic setObject:newArray forKey:monthString];
            }
        }
        historyVC.dictionary = dic;
        [self.controller presentViewController:historyVC animated:YES completion:nil];
    }
}

- (void)mapModeClick
{
    if (!_beginBtn.selected)
    {
        [self addActityTextInView:self text:NSLocalizedString(@"还未开始运动",nil) deleyTime:2.f];
        return;
    }
    if (!_backView)
    {
        UIView *backView = [[UIView alloc] init];
        _backView = backView;
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, 20, ScreenW, ScreenH - 20);
        [self addSubview:_backView];
        
        UIView *topView = [[UIView alloc] init];
        topView.frame = CGRectMake(0, 0, ScreenW, 44);
        topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [_backView addSubview:topView];
        
        UIButton * cancelButton = [[UIButton alloc] init];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
        [topView addSubview:cancelButton];
        cancelButton.frame = CGRectMake(12, 0, 50, 44);
        [cancelButton sizeToFit];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, ScreenW, ScreenH)];
        _mkMapView.mapType = MKMapTypeStandard;
        _mkMapView.showsUserLocation = NO;
        _mkMapView.delegate = self;
        
        if (_mkMapView)
        {
            if (self.model.locationArray.count != 0)
            {
                CLLocation *location = self.model.locationArray.lastObject;
                MKCoordinateSpan span = MKCoordinateSpanMake(0.0008, 0.0005);
                MKCoordinateRegion  region= MKCoordinateRegionMake(location.coordinate, span);
                [_mkMapView setRegion:region animated:YES];
            }
            
            CLLocationCoordinate2D commonPolylineCoords[self.model.locationArray.count];
            for (int i = 0 ; i < self.model.locationArray.count; i ++)
            {
                CLLocation *historyLocation = self.model.locationArray[i];
                commonPolylineCoords[i] = historyLocation.coordinate;
            }
            [_mkMapView removeOverlay:_mkPolyline];
            self.mkPolyline = [MKPolyline polylineWithCoordinates:commonPolylineCoords count:self.model.locationArray.count];
            [_mkMapView addOverlay: _mkPolyline];
        }
        [self.backView addSubview:_mkMapView];
        
        
    }
    else
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
        
    }];
}

- (void)timerfire
{
    int time = [[NSDate date] timeIntervalSince1970];
    self.model.duration = time - self.model.beginTime;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",self.model.duration/3600,self.model.duration/60,self.model.duration%60];
}


#pragma mark -- CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *getLocation = locations.lastObject;
    adaLog(@"%@",locations);
    
    BOOL ischina = [[ZCChinaLocation shared] isInsideChina:getLocation.coordinate];
    CLLocation *location;
    if (ischina)
    {
        CLLocationCoordinate2D coordGCJ = [WGS84TOGCJ02 transformFromWGSToGCJ:[getLocation coordinate]];
        location = [[CLLocation alloc] initWithLatitude:coordGCJ.latitude longitude:coordGCJ.longitude];
    }else
    {
        location = getLocation;
    }
    
    if (self.model.locationArray.count != 0)
    {
        CLLocation *lastLocation = self.model.locationArray.lastObject;
        CLLocationDistance distance = [location distanceFromLocation:lastLocation];
        self.model.distance += distance;
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.distance/1000.0];
        adaLog(@"%f",self.model.distance);
    }else
    {
        if (_mkMapView)
        {
            MKCoordinateSpan span = MKCoordinateSpanMake(0.0008, 0.0005);
            MKCoordinateRegion  region= MKCoordinateRegionMake(location.coordinate, span);
            [_mkMapView setRegion:region animated:YES];
        }
    }
    
    [self.model.locationArray addObject:location];
    
    double speed = location.speed;
    if (speed < 0)
    {
        speed = speed * -1;
    }
    self.speedLabel.text = [NSString stringWithFormat:@"%.2f",speed];
    
    if (_mkMapView)
    {
        
        CLLocationCoordinate2D commonPolylineCoords[self.model.locationArray.count];
        for (int i = 0 ; i < self.model.locationArray.count; i ++)
        {
            CLLocation *historyLocation = self.model.locationArray[i];
            commonPolylineCoords[i] = historyLocation.coordinate;
        }
        [_mkMapView removeOverlay:_mkPolyline];
        _mkPolyline = [MKPolyline polylineWithCoordinates:commonPolylineCoords  count:self.model.locationArray.count];
        [_mkMapView addOverlay: _mkPolyline];
    }
}

#pragma mark --- MAMapViewDelegate

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


#pragma mark -- CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim;
{
    adaLog(@"动画开始");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
    if (_stopLayer)
    {
        [_stopLayer removeFromSuperlayer];
        self.stopLayer = nil;
    }
    if (flag)
    {
        _beginBtn.selected = !_beginBtn.selected;
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
        self.mkMapView = nil;
        [self.timer invalidate];
        self.timer = nil;
        [self.backView removeFromSuperview];
        self.backView = nil;
        
        NSString *orderSql = @"by beginTime desc";
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[WHC_ModelSqlite query:[TrajectoryModel class] order:orderSql]];
        while (array.count >= 30)
        {
            TrajectoryModel *model = array[29];
            [array removeObjectAtIndex:29];
            NSString * sql = [NSString stringWithFormat:@"beginTime = %d",model.beginTime];
            [WHC_ModelSqlite delete:[TrajectoryModel class] where:sql];
        }
        
        self.model.arrayData = [NSKeyedArchiver archivedDataWithRootObject:self.model.locationArray];
        [WHC_ModelSqlite insert:self.model];
        self.model = nil;
        
    }
}

#pragma mark -- 内部调用方法

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchePoint = [touch locationInView:self];
    if (CGRectContainsPoint(_beginBtn.frame, touchePoint) && !(CGRectContainsPoint(_backView.frame, touchePoint)))
    {
        if (!_beginBtn.selected)
        {
            _beginBtn.selected = !_beginBtn.selected;
            [self beginLocation];
            if (!self.timer)
            {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerfire) userInfo:nil repeats:YES];
            }
            self.model.beginTime = [[NSDate date] timeIntervalSince1970];
            self.timeLabel.text = @"00:00:00";
            self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.distance/1000.0];
            self.speedLabel.text = @"0.00";
        }else
        {
            [_beginBtn.layer insertSublayer:self.stopLayer atIndex:0];
            CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
            scaleAnimation.fromValue = @0;//开始的大小
            scaleAnimation.toValue = @1.0;//最后的大小
            scaleAnimation.duration = 2;//动画持续时间
            scaleAnimation.delegate = self;
            scaleAnimation.repeatCount = 1;
            scaleAnimation.removedOnCompletion = YES;
            scaleAnimation.timingFunction = defaultCurve;
            [_stopLayer addAnimation:scaleAnimation forKey:@"pulse"];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    adaLog(@"Ended......");
    [self.stopLayer removeFromSuperlayer];
}

- (BOOL)locationServicesEnabled {
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        NSLog(@"手机gps定位已经开启");
        return YES;
    } else {
        NSLog(@"手机gps定位未开启");
        return NO;
    }
}

- (void)beginLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }else {
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=1.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        [_locationManager startUpdatingLocation];
        [_locationManager requestAlwaysAuthorization];
    }
}

#pragma mark -- GET方法

- (CALayer *)stopLayer
{
    if (!_stopLayer)
    {
        CALayer * spreadLayer = [CALayer layer];
        CGFloat diameter = sqrt(_beginBtn.centerX*_beginBtn.centerX + _beginBtn.centerY * _beginBtn.centerY)/2;  //扩散的大小
        spreadLayer.bounds = CGRectMake(0,0, diameter, diameter);
        spreadLayer.cornerRadius = diameter/2; //设置圆角变为圆形
        spreadLayer.position = CGPointMake(_beginBtn.width/2, _beginBtn.width/2);
        spreadLayer.backgroundColor = kMainColor.CGColor;
        _stopLayer = spreadLayer;
    }
    return _stopLayer;
}

- (TrajectoryModel *)model
{
    if (!_model)
    {
        _model = [TrajectoryModel new];
    }
    return _model;
}

- (UILabel *)gpsStateLabel
{
    if (!_gpsStateLabel)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"traGPS"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        imageView.frame = CGRectMake(25 * kX, 23 * kX, 25 * kX, 28 * kX);
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = allColorWhite;
        label.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GPS:",nil),[self locationServicesEnabled]?NSLocalizedString(@"可用",nil):NSLocalizedString(@"不可用",nil)];
        [label sizeToFit];
        _gpsStateLabel = label;
        [self addSubview:_gpsStateLabel];
        label.sd_layout.leftSpaceToView(imageView, 8 * kX)
        .centerYIs(imageView.centerY)
        .widthIs(label.width)
        .heightIs(20);
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mapButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mapButton setTitle:NSLocalizedString(@"地图模式",nil) forState:UIControlStateNormal];
        [mapButton sizeToFit];
        [mapButton addTarget:self action:@selector(mapModeClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [self addSubview:mapButton];
        mapButton.sd_layout.rightSpaceToView(self, 20 * kX)
        .centerYIs(imageView.centerY)
        .widthIs(mapButton.width)
        .heightIs(30);
        
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        rightImageView.image = [UIImage imageNamed:@"traMap"];
        [self addSubview:rightImageView];
        rightImageView.sd_layout.rightSpaceToView(mapButton, 8 * kX)
        .centerYIs(imageView.centerY)
        .widthIs(imageView.width)
        .heightIs(imageView.height);
    }
    return _gpsStateLabel;
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:38];
        label.textColor = allColorWhite;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0.00";
        _distanceLabel = label;
        [self addSubview:_distanceLabel];
        _distanceLabel.sd_layout.topSpaceToView(self, 77 * kX)
        .centerXIs(self.centerX)
        .heightIs(40)
        .widthIs(100);
        
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.font = [UIFont systemFontOfSize:14];
        unitLabel.textColor = allColorWhite;
        unitLabel.text = @"公里";
        [unitLabel sizeToFit];
        [self addSubview:unitLabel];
        unitLabel.sd_layout.leftSpaceToView(label, 0)
        .bottomEqualToView(label)
        .heightIs(25)
        .widthIs(unitLabel.width);
        
    }
    return _distanceLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        
        CGFloat width = ScreenW/3;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"traTime"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(width/2-(43 * kX)/2, 155 * kX, 30 * kX, 30 * kX);
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = allColorWhite;
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _timeLabel = label;
        _timeLabel.sd_layout.topSpaceToView(imageView, 10 * kX)
        .centerXIs(imageView.centerX)
        .widthIs(width)
        .heightIs(25 * kX);
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.font = [UIFont systemFontOfSize:13];
        bottomLabel.textColor = allColorWhite;
        bottomLabel.text = @"时间(h)";
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bottomLabel];
        bottomLabel.sd_layout.topSpaceToView(label, 10 * kX)
        .centerXIs(imageView.centerX)
        .widthIs(80 * kX)
        .heightIs(25 * kX);
        
    }
    return _timeLabel;
}

- (UILabel *)speedLabel
{
    if(!_speedLabel)
    {
        
        CGFloat width = ScreenW/3;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"traDistance"];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(width + width/2-(43 * kX)/2, 155 * kX, 30 * kX, 30 * kX);
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = allColorWhite;
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _speedLabel = label;
        _speedLabel.sd_layout.topSpaceToView(imageView, 10 * kX)
        .centerXIs(imageView.centerX)
        .widthIs(width)
        .heightIs(25 * kX);
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.font = [UIFont systemFontOfSize:13];
        bottomLabel.textColor = allColorWhite;
        bottomLabel.text = @"速度(Km/h)";
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bottomLabel];
        bottomLabel.sd_layout.topSpaceToView(label, 10 * kX)
        .centerXIs(imageView.centerX)
        .widthIs(80 * kX)
        .heightIs(25 * kX);
        
    }
    return _speedLabel;
}

- (UILabel *)locus{
    if(!_locus)
    {
        
        CGFloat width = ScreenW/3;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"guiji"];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(width*2 + width/2-(43 * kX)/2, 155 * kX, 30 * kX, 30 * kX);
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = allColorWhite;
        label.text = @"查看";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _locus = label;
        _locus.sd_layout.topSpaceToView(imageView, 10 * kX)
        .centerXIs(imageView.centerX)
        .widthIs(width)
        .heightIs(25 * kX);
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.font = [UIFont systemFontOfSize:13];
        bottomLabel.textColor = allColorWhite;
        bottomLabel.text = @"运动轨迹(缩略图)";
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bottomLabel];
        bottomLabel.sd_layout.topSpaceToView(label, 10 * kX)
        .centerXIs(imageView.centerX)
        .widthIs(100 * kX)
        .heightIs(25 * kX);
        
        UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:lookBtn];
        lookBtn.frame = CGRectMake(width*2 + width/2-(43 * kX)/2, 162 * kX, width, 85*kX);
        [lookBtn addTarget:self action:@selector(historyClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _locus;
}

- (UIButton *)beginBtn
{
    if (!_beginBtn)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = KCOLOR(40, 82, 251);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"开始",nil) forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"长按停止",nil) forState:UIControlStateSelected];
        button.titleLabel.numberOfLines = 0;
        button.userInteractionEnabled = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:button];
        button.sd_layout.topSpaceToView(self, 301 * kX)
        .centerXIs(self.centerX)
        .widthIs(100 * kX)
        .heightIs(100 * kX);
        _beginBtn = button;
        _beginBtn.layer.cornerRadius = 50 * kX;
    }
    return _beginBtn;
}

@end
