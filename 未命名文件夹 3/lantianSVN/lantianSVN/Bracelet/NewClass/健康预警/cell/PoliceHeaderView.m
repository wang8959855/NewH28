//
//  PoliceHeaderView.m
//  Bracelet
//
//  Created by apple on 2018/8/13.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "PoliceHeaderView.h"
#import <CoreLocation/CoreLocation.h>
#import "SOSView.h"
#import "YujingView.h"

@interface PoliceHeaderView ()<CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager* locationManager;

@property (weak, nonatomic) IBOutlet UIButton *yjButton;

//1:sos 2:定制
@property (nonatomic, assign) NSInteger clickType;

//记录是否请求过sos
@property (nonatomic, assign) BOOL isSOS;

@end

@implementation PoliceHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.sosButton.layer.borderWidth = 2;
    self.sosButton.layer.borderColor = kMainColor.CGColor;
    self.yjButton.layer.borderWidth = 2;
    self.yjButton.layer.borderColor = kMainColor.CGColor;
    self.locationButton.layer.borderWidth = 2;
    self.locationButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.locationButton.selected = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
}

- (IBAction)sosAction:(UIButton *)sender {
    SOSView *sos = [SOSView initSOSView];
    [sos show];
    kWEAKSELF;
    sos.sosOKBlock = ^{
        self.clickType = 1;
        [weakSelf startLocation];
    };
}

//定位按钮
- (IBAction)locationAction:(UIButton *)sender {
    NSString *title = @"";
    if (sender.selected) {
        title = @"关闭轨迹定位将让监护人无法获取您的位置信息，是否关闭";
    }else{
        title = @"轨迹定位将让监护人获取您的位置信息，是否开启";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:title preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self.vc presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied:{
            self.locationButton.selected = NO;
            self.locationButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }break;
        default:{
            self.locationButton.selected = YES;
            self.locationButton.layer.borderColor = kMainColor.CGColor;
        }break;
    }
}


//开始定位
- (void)startLocation{
    
    [self.vc addActityIndicatorInView:self.vc.view labelText:NSLocalizedString(@"正在请求", nil) detailLabel:NSLocalizedString(@"正在请求", nil)];
    
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
        
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        _locationManager.allowsBackgroundLocationUpdates =YES;
        
    }
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = placemarks.firstObject;
        NSLog(@"name,%@",place.name);                      // 位置名
        NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
        NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
        NSLog(@"locality,%@",place.locality);              // 市
        NSLog(@"subLocality,%@",place.subLocality);        // 区
        NSLog(@"country,%@",place.country);                // 国家
        if (!place.locality || place.locality.length == 0) {
            //定位失败
            [self.vc removeActityIndicatorFromView:self.vc.view];
            [self.vc addActityTextInView:self.vc.view text:@"定位失败"  deleyTime:1.5f];
            return;
        }
        if (self.clickType == 1) {
            [self requestSOSAddress:[NSString stringWithFormat:@"%@%@%@%@",place.country,place.locality,place.subLocality,place.name] lng:oldCoordinate.longitude lat:oldCoordinate.latitude environment:place.name];
        }else{
            [self requestUploadAddress:[NSString stringWithFormat:@"%@%@%@%@",place.country,place.locality,place.subLocality,place.name] lng:oldCoordinate.longitude lat:oldCoordinate.latitude environment:place.name];
        }
    }];
}

//预警
- (IBAction)yjAction:(UIButton *)sender {
    [YujingView yujingViewWithNoti:self.isWar];
}

//点击sos
- (void)requestSOSAddress:(NSString *)address lng:(double)lng lat:(double)lat environment:(NSString *)environment{
    if (self.isSOS) {
        return;
    }
    self.isSOS = YES;
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",CLICKSOS,TOKEN];
    NSString *lngStr = [NSString stringWithFormat:@"%f",lng];
    NSString *latStr = [NSString stringWithFormat:@"%f",lat];
    NSDictionary *para = @{@"userid":USERID,@"address":address,@"lng":lngStr,@"lat":latStr,@"environment":environment};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        self.isSOS = NO;
        [self.vc removeActityIndicatorFromView:self.vc.view];
        int code = [responseObject[@"code"] intValue];
        NSString *message = responseObject[@"message"];
        if (code == 0) {
            [self.vc addActityTextInView:self.vc.view text:@"呼叫成功"  deleyTime:1.5f];
        }else{
            [self.vc addActityTextInView:self.vc.view text:@"呼叫失败" deleyTime:1.5f];
            [self.vc addActityTextInView:self.vc.view text:message deleyTime:1.5f];
        }
    }];
}

//定时上传定位
- (void)requestUploadAddress:(NSString *)address lng:(double)lng lat:(double)lat environment:(NSString *)environment{
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",UPLOADLOCATION,TOKEN];
    NSDictionary *para = @{@"userid":USERID,@"address":address,@"lng":@(lng),@"lat":@(lat),@"environment":environment};
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", @"text/json", nil];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int code = [responseObject[@"code"] intValue];
        [self.vc removeActityIndicatorFromView:self.vc.view];
        if (code == 0) {
            //上传成功
            NSLog(@"上传成功");
            [self.vc addActityTextInView:self.vc.view text:@"心率监护:地理位置上传成功"  deleyTime:1.5f];
        }else{
            //上传失败
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.vc removeActityIndicatorFromView:self.vc.view];
    }];
}

@end
