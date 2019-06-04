//
//  MoreView.m
//  Wukong
//
//  Created by apple on 2019/3/26.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "MoreView.h"
#import "SOSView.h"
#import "RhythmViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationKit/BMKLocationManager.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>

static MoreView *instance = nil;
@interface MoreView ()<BMKLocationManagerDelegate,BMKLocationAuthDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UIButton *rotateBtn;

//节律
@property (nonatomic, strong) UIButton *jielvBtn;
//sos
@property (nonatomic, strong) UIButton *sosBtn;
//定位
@property (nonatomic, strong) UIButton *locationBtn;
//预警
@property (nonatomic, strong) UIButton *policeBtn;

//4个按钮的初始位置
@property (nonatomic, assign) CGRect btnInitialFrame;
//4个按钮的结束位置
@property (nonatomic, strong) NSArray *endFrameArr;

//宽度
@property (nonatomic, assign) CGFloat viewWidth;

@property (strong,nonatomic) BMKLocationManager* locationManager;

@property (nonatomic, strong) CLLocationManager *locationManager1;

@end

@implementation MoreView

+ (instancetype)moreView{
    @synchronized(self) {
        if( instance == nil ){
            instance =  [[MoreView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [[UIApplication sharedApplication].keyWindow addSubview:instance];
            
            CGAffineTransform endAngle = CGAffineTransformMakeRotation(M_PI / 4);
            [UIView animateWithDuration:0.3 animations:^{
                instance.rotateBtn.transform = endAngle;
                for (int i = 0; i < 3; i++) {
                    UIView *view = [instance viewWithTag:100+i];
                    view.frame = [instance.endFrameArr[i] CGRectValue];
                }
                [instance getState];
            } completion:^(BOOL finished) {
            }];
        }
    }
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    
    self.locationManager1 = [[CLLocationManager alloc] init];
    self.locationManager1.delegate = self;
    
    //初始化实例
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"T1yaP1z2gQECDxQ3n1VWKqMaAEvgoL07" authDelegate:self];
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = self.bounds;
    [self addSubview:effectview];
    
    self.rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.rotateBtn];
    self.rotateBtn.frame = CGRectMake(ScreenWidth/2-44, ScreenHeight-SafeAreaBottomHeight-26, 88, 88);
    [self.rotateBtn setImage:[UIImage imageNamed:@"yuan"] forState:UIControlStateNormal];
    [self.rotateBtn addTarget:self action:@selector(rotateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewWidth = (ScreenWidth-150)/3;
    //创建4个按钮的初始位置
    self.btnInitialFrame = CGRectMake(ScreenWidth/2-self.viewWidth/2, ScreenHeight-SafeAreaBottomHeight-30, self.viewWidth, 88);
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:self.btnInitialFrame];
        [self addSubview:view];
        view.tag = 100+i;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 20)];
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.tag = 200+i;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 20, self.viewWidth, 68);
        [view addSubview:button];
        [button addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            self.jielvBtn = button;
            [button setImage:[UIImage imageNamed:@"jl-label"] forState:UIControlStateNormal];
            label.text = @"节律";
        }else if (i == 1){
            self.sosBtn = button;
            [button setImage:[UIImage imageNamed:@"sos-label"] forState:UIControlStateNormal];
            label.text = @"sos";
        }else if (i == 2){
            self.locationBtn = button;
            [button setImage:[UIImage imageNamed:@"dw-label"] forState:UIControlStateNormal];
            label.text = @"定位";
            [button setImage:[UIImage imageNamed:@"dw-blue"] forState:UIControlStateSelected];
        }else if (i == 3){
            self.policeBtn = button;
            [button setImage:[UIImage imageNamed:@"yj-label"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"yj-blue"] forState:UIControlStateSelected];
            label.text = @"预警";
        }
        
    }
    [self bringSubviewToFront:self.rotateBtn];
    
    //设置4个按钮的结束位置
    CGRect rect1 = CGRectMake(30, ScreenHeight-SafeAreaBottomHeight-100, self.viewWidth, 88);
//    CGRect rect4 = CGRectMake(ScreenWidth-30-self.viewWidth, ScreenHeight-SafeAreaBottomHeight-100, self.viewWidth, 88);
    
    CGRect rect2 = CGRectMake(ScreenW/2-self.viewWidth/2, ScreenHeight-SafeAreaBottomHeight-180, self.viewWidth, 88);
    CGRect rect3 = CGRectMake(ScreenWidth-30-self.viewWidth, ScreenHeight-SafeAreaBottomHeight-100, self.viewWidth, 88);
    self.endFrameArr = @[@(rect1),@(rect2),@(rect3)];
    
}

//按钮点击事件
- (void)menuAction:(UIButton *)button{
    if (button == self.jielvBtn) {//节律
        [self rotateAction:nil];
        RhythmViewController *rhy = [RhythmViewController new];
//        rhy.hidesBottomBarWhenPushed = NO;
        [[self findCurrentViewController].navigationController pushViewController:rhy animated:YES];
    }else if (button == self.sosBtn){//sos
        SOSView *sos = [SOSView initSOSView];
        [sos show];
        __weak MoreView *weakSelf = self;
        sos.sosOKBlock = ^{
            if (!weakSelf.locationBtn.selected) {
                [self makeToast:@"请先打开定位" duration:1.5 position:CSToastPositionCenter];
                return;
            }
            [self makeToastActivity];
            [weakSelf startLocation];
        };
    }else if (button == self.locationBtn){//定位
        [self rotateAction:nil];
        NSString *title = @"";
        if (button.selected) {
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
        [[self findCurrentViewController] presentViewController:alert animated:YES completion:nil];
    }else if (button == self.policeBtn){//预警
        
    }
}

//关闭界面
- (void)rotateAction:(UIButton *)button{
    [UIView animateWithDuration:0.3 animations:^{
        button.transform = CGAffineTransformIdentity;
        for (int i = 0; i < 4; i++) {
            UIView *view = [self viewWithTag:100+i];
            view.frame = self.btnInitialFrame;
        }
    } completion:^(BOOL finished) {
        [instance removeFromSuperview];
        instance = nil;
    }];
}
//关闭界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.rotateBtn.transform = CGAffineTransformIdentity;
        for (int i = 0; i < 4; i++) {
            UIView *view = [self viewWithTag:100+i];
            view.frame = self.btnInitialFrame;
        }
    } completion:^(BOOL finished) {
        [instance removeFromSuperview];
        instance = nil;
    }];
}

//开始定位
- (void)startLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] &&
        (status == kCLAuthorizationStatusAuthorizedWhenInUse
         || status == kCLAuthorizationStatusAuthorizedAlways)) {
            //定位功能可用，开始定位
            kWEAKSELF
            [self.locationManager requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
                if (location.rgcData) {
                    NSString *address = @"";
                    if ([location.rgcData.province isEqualToString:location.rgcData.city]) {
                        address = [NSString stringWithFormat:@"%@%@",location.rgcData.city,location.rgcData.district];
                    }else{
                        address = [NSString stringWithFormat:@"%@%@%@",location.rgcData.province,location.rgcData.city,location.rgcData.district];
                    }
                    [weakSelf requestSOSAddress:address lng:location.location.coordinate.longitude lat:location.location.coordinate.latitude environment:location.rgcData.locationDescribe];
                }else{
                    [weakSelf requestSOSAddress:@"" lng:location.location.coordinate.longitude lat:location.location.coordinate.latitude environment:@""];
                }
                [weakSelf.locationManager stopUpdatingLocation];
            }];
        }else{
            //定位失败
            [self hideToastActivity];
            [self makeToast:@"定位失败" duration:1.5 position:CSToastPositionCenter];
        }
}

//点击sos
- (void)requestSOSAddress:(NSString *)address lng:(double)lng lat:(double)lat environment:(NSString *)environment{
    NSString *url = [NSString stringWithFormat:@"%@",CLICKSOS];
    NSDictionary *para = @{@"userid":USERID,@"address":address,@"lng":@(lng),@"lat":@(lat),@"environment":environment,@"token":TOKEN};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self hideToastActivity];
        int code = [responseObject[@"code"] intValue];
        NSString *message = responseObject[@"message"];
        if (code == 0) {
            [self rotateAction:nil];
            [[self findCurrentViewController].view makeToast:@"呼叫成功" duration:1.5 position:CSToastPositionCenter];
        }else{
            [self makeToast:message duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//定位信息
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    UILabel *label = [self viewWithTag:202];
    switch (status) {
        case kCLAuthorizationStatusDenied:{//未定位
            self.locationBtn.selected = NO;
            label.textColor = [UIColor grayColor];
        }break;
        default:{//已定位
            label.textColor = kMainColor;
            self.locationBtn.selected = YES;
        }break;
    }
}

//查询画预警状态
- (void)getState{
    NSString *url = [NSString stringWithFormat:@"%@/%@",GETSERVER,TOKEN];
    NSDictionary *para = @{@"UserID":USERID};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            int isWarn = [responseObject[@"data"][@"isWarn"] intValue];
            self.policeBtn.selected = isWarn;
            UILabel *label = [self viewWithTag:203];
            if (isWarn) {
                label.textColor = kMainColor;
            }else{
                label.textColor = [UIColor grayColor];
            }
        }else{
            
        }
    }];
}

//获取最上层的viewcontroller
- (UIViewController *)findCurrentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}



@end
