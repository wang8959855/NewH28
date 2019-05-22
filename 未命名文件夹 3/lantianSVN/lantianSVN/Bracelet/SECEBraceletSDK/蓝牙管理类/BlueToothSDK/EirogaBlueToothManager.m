//
//  EirogaBlueToothManager.m
//  Bracelet
//
//  Created by panzheng on 2017/3/23.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "EirogaBlueToothManager.h"
#import "userDataModel.h"
#import "sportModel.h"
#import "TakePhotoViewController.h"
#import "HistoryDataModel.h"
//#import <CoreLocation/CoreLocation.h>
#import "ZCChinaLocation.h"
#import "WGS84TOGCJ02.h"
#import <BMKLocationKit/BMKLocationManager.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>

@interface EirogaBlueToothManager()<BMKLocationManagerDelegate,BMKLocationAuthDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger uploadNum;

@property (nonatomic, strong) CLLocationManager *locationmanager1;

//没有开启定位请求3次
@property (nonatomic, assign) NSInteger locationErrorNum;

@end


@implementation EirogaBlueToothManager

+ (instancetype)sharedInstance
{
    static EirogaBlueToothManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance setBlocks];
        [instance createLocation];
    });
    return instance;
}

- (void)setBlocks
{
    kWEAKSELF;
    [self.manager connectStateChangedWithBlock:^(BOOL isConnect, CBPeripheral *peripheral) {
        self.isconnected = isConnect;
        if (isConnect)
        {
            weakSelf.connectedUUID = peripheral.identifier.UUIDString;
            [weakSelf performSelector:@selector(getHistoryDataWithTimeSeconds:andHour:) withObject:nil afterDelay:2];
            NSString *value = peripheral.identifier.UUIDString;
            [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"kBleBoundPeripheralIdentifierString"];
            [weakSelf addActityText:NSLocalizedString(@"蓝牙已连接",nil) deleyTime:1.5f];
            weakSelf.peripheral = peripheral;
            [self bindDevice:peripheral.name];
            
            NSString *unitCode = [XXUserInformation userUnit];
            int unit = 0;
            if ([unitCode isEqualToString:@"2"])
            {
                unit = 1;
            }
            NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
            NSRange containsA = [formatStringForHours rangeOfString:@"a"];
            
            BOOL hasAMPM = containsA.location != NSNotFound;
            
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *currentLanguage = [languages objectAtIndex:0];
            BOOL isEnglish = YES;
            if ([currentLanguage containsString:@"zh-Hans"])
            {
                isEnglish = NO;
            }

            [weakSelf.manager setBindUnit:unit andTimeType:hasAMPM isEnglish:isEnglish];
            [[PZBlueToothManager sharedInstance] getHardWearVersionWithHardVersionBlock:^(HardWearVersionModel *model) {
                kHCH.type = model.nameString;
                kHCH.version = model.nameString;
            }];
            
        }else
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            weakSelf.RSSI = 0;
            weakSelf.connectedUUID = @"";
            weakSelf.peripheral = nil;
            [weakSelf addActityText:NSLocalizedString(@"蓝牙已断开",nil) deleyTime:1.5f];
        }
        if (self.StateBlock)
        {
            weakSelf.StateBlock(isConnect,peripheral);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findPhone) name:findMyPhone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTakePhoto) name:beginTakePhoto object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endTakePhoto) name:endTakePhoto object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusic) name:playMusic object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseMusic) name:pauseMusic object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lastSong) name:lastSong object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextSong) name:nextSong object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendSOS) name:sendSOS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetRSSI:) name:@"RSSI" object:nil];
}

- (void)bindDevice:(NSString *)deviceName{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@",BINDDEVICE];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID,@"watch":deviceName,@"token":TOKEN} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        if (error)
        {
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                
            } else {
            }
        }
    }];
}

- (void)didGetRSSI:(NSNotification *)noti
{
    self.RSSI = [noti.object intValue];
}

- (void)addActityText : (NSString *)textString deleyTime : (float)times
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = textString ;
    hud.label.text = textString;
    hud.margin = 10.f;
    //    	hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.square = YES;
    //    [hud hide:YES afterDelay:times];
    [hud hideAnimated:YES afterDelay:times];
}

- (void)playMusic
{
    if (![XXDeviceInfomation isMusicControl])
        return;
    self.musicPlayerController = [MPMusicPlayerController systemMusicPlayer];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    if (![self isPlayingItem]) {
        [self createMediaQuery];
    }//若没有正在播放的媒体项目，则创建媒体队列
    if (self.musicPlaybackState == MPMusicPlaybackStateStopped || self.musicPlaybackState == MPMusicPlaybackStatePaused || self.musicPlaybackState == MPMusicPlaybackStateInterrupted) {
        [self.musicPlayerController play];
    }
}

- (MPMusicPlayerController *)musicPlayerController
{
    if (!_musicPlayerController) {
        _musicPlayerController = [MPMusicPlayerController systemMusicPlayer];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return _musicPlayerController;
}

- (BOOL)isPlayingItem {
    if ([self.musicPlayerController indexOfNowPlayingItem] == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (void)createMediaQuery {
    self.query = [MPMediaQuery songsQuery];
    [self.musicPlayerController setQueueWithQuery:self.query];
}

- (void)pauseMusic
{
    if (![XXDeviceInfomation isMusicControl])
        return;
    [self.musicPlayerController pause];
}

- (void)lastSong
{
    if (![XXDeviceInfomation isMusicControl])
        return;
    [self.musicPlayerController skipToPreviousItem];
    if (self.musicPlaybackState == MPMusicPlaybackStateStopped || self.musicPlaybackState == MPMusicPlaybackStatePaused || self.musicPlaybackState == MPMusicPlaybackStateInterrupted) {
        [self.musicPlayerController play];
    }
}

- (void)nextSong
{
    if (![XXDeviceInfomation isMusicControl])
        return;
    [self.musicPlayerController skipToNextItem];
    if (self.musicPlaybackState == MPMusicPlaybackStateStopped || self.musicPlaybackState == MPMusicPlaybackStatePaused || self.musicPlaybackState == MPMusicPlaybackStateInterrupted) {
        [self.musicPlayerController play];
    }
}

//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray<CLLocation *> *)locations
//{
////    [_locationmanager stopUpdatingLocation];
//
//    CLLocation *getLocation = locations.lastObject;
//    adaLog(@"%@",locations);
//
//    BOOL ischina = [[ZCChinaLocation shared] isInsideChina:getLocation.coordinate];
//    CLLocation *location;
//    if (ischina)
//    {
//        CLLocationCoordinate2D coordGCJ = [WGS84TOGCJ02 transformFromWGSToGCJ:[getLocation coordinate]];
//        location = [[CLLocation alloc] initWithLatitude:coordGCJ.latitude longitude:coordGCJ.longitude];
//    }else
//    {
//        location = getLocation;
//    }
//
//    adaLog(@"%@",location);
//    NSString *urlString = [NSString stringWithFormat:@"http://uri.amap.com/marker?position=""%f"",""%f""",location.coordinate.longitude,location.coordinate.latitude];
//
//    NSDictionary *param = @{@"uid":kHCH.userInfoModel.uid,
//                            @"address":urlString};
//
//    NSString *url;
//    if (kHCH.userInfoModel.isThird)
//    {
//        url = @"adds";
//    }else
//    {
//        url = @"add";
//    }
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_GET RequestURL:url ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
//        adaLog(@"%@",responseObject);
//    }];
//
//}

- (void)sendSOS
{
//    _locationmanager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
//        [_locationmanager requestWhenInUseAuthorization];
    }else {
        //设置代理
//        _locationmanager.delegate=self;
        //设置定位精度
//        _locationmanager.desiredAccuracy=kCLLocationAccuracyBest;
//        [_locationmanager startUpdatingLocation];
    }

}

- (void)findPhone
{
    SystemSoundID soundID = 0;
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:soundFile], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)beginTakePhoto
{
    UIViewController *result = [self getTopViewController];
    if ([result isKindOfClass:[TakePhotoViewController class]])
    {
        return;
    }else
    {
        TakePhotoViewController *takePhotoVC = [TakePhotoViewController new];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:takePhotoVC animated:YES completion:nil];
    }
}

- (void)endTakePhoto
{
    UIViewController *result = [self getTopViewController];
    if ([result isKindOfClass:[TakePhotoViewController class]])
    {
        [(TakePhotoViewController *)result closeClick:nil];
    }
}

- (UIViewController *)getTopViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([result isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}


#pragma mark -- 发送数据
- (void)getHistoryDataWithTimeSeconds:(int)timeSeconds andHour:(int)hour
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = NSLocalizedString(@"正在同步数据", nil);
    [hud hideAnimated:YES afterDelay:1.5];
    [XXDeviceInfomation setDeviceUpdateTime];
    
    if (hour > 24)
    {
        hour = 0;
    }
    if (hour > 6 && hour < 12)
    {
        HistoryDataModel *model = [[HistoryDataModel alloc] init];
        [model saveDaySleepArrayWithTimeSeconds:timeSeconds completion:nil];
    }
    if (timeSeconds == [HCHCommonManager getInstance].todayTimeSeconds )
    {
        NSString * sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds = %d",kHCH.userInfoModel.name,timeSeconds];
        NSArray *userDataArray = [WHC_ModelSqlite query:[userDataModel class] where:sql];
        if (userDataArray.count != 0)
        {
            userDataModel *userData = userDataArray[0];
            if (userData.lastUpdate > hour)
            {
                hour = userData.lastUpdate;
            }
        }else
        {
            hour = 0;
        }
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        NSString *timeString = [formatter stringFromDate:date];
        int nowHour = [timeString intValue];
        

        if (nowHour >= hour)
        {
            [self getHistoryDataWithTimeSecondsFromBracelet:timeSeconds andHour:hour];
            
            return;
        }else
        {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [self uploadDataWithTimeSeconds:kHCH.todayTimeSeconds];
            return;
        }
    }else
    {
        if (timeSeconds == 0)
        {
            [self performSelector:@selector(getHistoryDataWithTimeSeconds:andHour:) withObject:nil afterDelay:150];

            for (int i = 0 ; i < 7; i ++)
            {
                timeSeconds = [HCHCommonManager getInstance].todayTimeSeconds - (6 - i) * KONEDAYSECONDS;
                NSString * sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds = %d",kHCH.userInfoModel.name,timeSeconds];
                NSArray *userDataArray = [WHC_ModelSqlite query:[userDataModel class] where:sql];
                
                if (userDataArray.count == 0)
                {
                    [self getHistoryDataWithTimeSecondsFromBracelet:timeSeconds andHour:0];
                }else
                {
                    userDataModel *dataModel = userDataArray[0];
                    if (dataModel.lastUpdate < 24)
                    {
                        [self getHistoryDataWithTimeSecondsFromBracelet:timeSeconds andHour:dataModel.lastUpdate];
                        return;
                    }
                }
            }
        }else
        {
            NSString * sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds = %d",kHCH.userInfoModel.name,timeSeconds];
            NSArray *userDataArray = [WHC_ModelSqlite query:[userDataModel class] where:sql];
            
            if (userDataArray.count == 0)
            {
                [self getHistoryDataWithTimeSecondsFromBracelet:timeSeconds andHour:0];
                return;
            }else
            {
                userDataModel *dataModel = userDataArray[0];
                if (dataModel.lastUpdate < 24)
                {
                    [self getHistoryDataWithTimeSecondsFromBracelet:timeSeconds andHour:hour];
                    return;
                }
            }
        }
    }
}


- (void)getHistoryDataWithTimeSecondsFromBracelet:(int)timeSeconds andHour:(int)hour {
    NSString *timeString = [[TimeCallManager getInstance] getTimeStringWithSeconds:timeSeconds andFormat:@"yyyy/MM/dd"];;
    NSArray *timeArray = [timeString componentsSeparatedByString:@"/"];
    
    kWEAKSELF;
    [self.manager getHistoryDataWithYeah:[timeArray[0] intValue] Month:[timeArray[1] intValue] Day:[timeArray[2] intValue] andHour:hour DataBlock:^(historyDataHourModel *model) {
        
        int timeSeconds = [[TimeCallManager getInstance] getSecondsWithTimeString:[NSString stringWithFormat:@"%d/%d/%d",model.yeah,model.month,model.day] andFormat:@"yyyy/MM/dd"];
        NSString * sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds = %d",kHCH.userInfoModel.name,timeSeconds];
        NSArray *modelArray = [WHC_ModelSqlite query:[userDataModel class] where:sql];
        if (modelArray.count == 0)
        {
            userDataModel *dataModel = [userDataModel new];
            dataModel = [userDataModel new];
            dataModel.name = kHCH.userInfoModel.name;
            dataModel.lastUpdate = hour;
            dataModel.timeSeconds = timeSeconds;
            sportModel *sport = [sportModel new];
            NSMutableArray *array144 = [[NSMutableArray alloc] init];
            NSMutableArray *array24 = [[NSMutableArray alloc] init];
            for (int i = 0; i < 14400; i ++)
            {
                [array144 addObject:@"0"];
            }
            for (int i = 0 ; i < 14400; i ++)
            {
                [array24 addObject:@"0"];
            }
            [sport.statuArray addObjectsFromArray:array144];
            [sport.stepArray addObjectsFromArray:array24];
            [sport.BPHArray addObjectsFromArray:array144];
            [sport.BPLArray addObjectsFromArray:array144];
            
            [sport.heartArray addObjectsFromArray:array144];
            
            [sport.calmHRArray addObjectsFromArray:array24];
            
            [sport.statuArray replaceObjectsInRange:NSMakeRange(hour * 60, 60) withObjectsFromArray:model.stateArray];
            [sport.statuArray replaceObjectsInRange:NSMakeRange(hour * 60, 60) withObjectsFromArray:model.stepArray];
//            [sport.BPHArray replaceObjectsInRange:NSMakeRange(hour * 6, 6) withObjectsFromArray:model.BPHArray];
//            [sport.BPLArray replaceObjectsInRange:NSMakeRange(hour * 6, 6) withObjectsFromArray:model.BPLArray];
            [sport.heartArray replaceObjectsInRange:NSMakeRange(hour * 60, 60) withObjectsFromArray:model.heartArray];
            [sport.calmHRArray replaceObjectAtIndex:hour withObject:[NSString stringWithFormat:@"%d",model.calmHR]];
            dataModel.totalSteps = 0;
            for (int i = 0; i < 60; i ++)
            {
                dataModel.totalSteps += [sport.stepArray[i] intValue];
            }
            dataModel.userData = [NSKeyedArchiver archivedDataWithRootObject:sport];
            [WHC_ModelSqlite insert:dataModel];
            [weakSelf getHistoryDataWithTimeSeconds:timeSeconds andHour:hour];
        }else{
            userDataModel *dataModel = modelArray[0];
            sportModel *sportM = [NSKeyedUnarchiver unarchiveObjectWithData:dataModel.userData];
            
            if (dataModel.lastUpdate <= hour)
            {
                if (sportM.statuArray.count != 0) {
                    [sportM.statuArray replaceObjectsInRange:NSMakeRange(hour * 60, 60) withObjectsFromArray:model.stateArray];
                }
                [sportM.statuArray replaceObjectsInRange:NSMakeRange(hour * 60, 60) withObjectsFromArray:model.stepArray];
//                [sportM.stepArray replaceObjectAtIndex:hour withObject:[NSString stringWithFormat:@"%d",model.totalSteps]];
//                if (sportM.BPHArray.count != 0) {
//                    [sportM.BPHArray replaceObjectsInRange:NSMakeRange(hour * 6, 6) withObjectsFromArray:model.BPHArray];
//                }
//                if (sportM.BPLArray.count != 0) {
//                    [sportM.BPLArray replaceObjectsInRange:NSMakeRange(hour * 6, 6) withObjectsFromArray:model.BPLArray];
//                }
                if (sportM.heartArray.count != 0) {
                    [sportM.heartArray replaceObjectsInRange:NSMakeRange(hour * 60, 60) withObjectsFromArray:model.heartArray];
                }
                [sportM.calmHRArray replaceObjectAtIndex:hour withObject:[NSString stringWithFormat:@"%d",model.calmHR]];
                dataModel.lastUpdate = hour;
            }
            
            int recieveHour = hour;
            if (timeSeconds != [HCHCommonManager getInstance].todayTimeSeconds && dataModel.lastUpdate == 23)
            {
              recieveHour = 24;
            }
            dataModel.totalSteps = 0;
            for (int i = 0; i < 24; i ++)
            {
                dataModel.totalSteps += [sportM.stepArray[i] intValue];
            }
            dataModel.lastUpdate = recieveHour;
            dataModel.userData = [NSKeyedArchiver archivedDataWithRootObject:sportM];
            [WHC_ModelSqlite update:dataModel where:sql];
            
            if(timeSeconds != [HCHCommonManager getInstance].todayTimeSeconds)
            {
                if (dataModel.lastUpdate > 23)
                {
                    [self uploadDataWithTimeSeconds:timeSeconds];
                    [self getHistoryDataWithTimeSeconds:timeSeconds+KONEDAYSECONDS andHour:0];
                }else if(dataModel.lastUpdate < 23)
                {
                    [self getHistoryDataWithTimeSeconds:timeSeconds andHour:dataModel.lastUpdate + 1];
                }else
                {
                }
            }else
            {
                [self getHistoryDataWithTimeSeconds:timeSeconds andHour:dataModel.lastUpdate + 1];
            }
            
        }
        adaLog(@"dataTimeIs ==== %@",[NSString stringWithFormat:@"%d/%d/%d/%d",model.yeah,model.month,model.day,model.hour]);
    }];
}

- (void)uploadDataWithTimeSeconds:(int)timeSeconds
{
        kWEAKSELF;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(queue, ^{
            [weakSelf uploadSleepDataWithTimeSeconds:timeSeconds];
        });
        dispatch_sync(queue, ^{
            [weakSelf uploadSportDataWithTimeSeconds:timeSeconds];
        });
        dispatch_sync(queue, ^{
            [weakSelf uploadHistoryHeartDataWithTimeSeconds:timeSeconds];
        });

}

- (void)uploadSportDataWithTimeSeconds:(int)timeSeconds
{
    HistoryDataModel *historyModel = [HistoryDataModel new];
    [historyModel writeDateYearWithTimeSeconds:timeSeconds completion:^(userDataModel *dataModel) {
        if (dataModel)
        {
            sportModel *sportM = [NSKeyedUnarchiver unarchiveObjectWithData:dataModel.userData];
            NSArray *stepArray = sportM.stepArray;
            
            NSMutableArray *valueArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < 24; i ++)
            {
                [valueArray addObject:@{@"startTime":[NSString stringWithFormat:@"%02d",i],
                                        @"steps":@"0",
                                        @"cal":@"0"
                                        }];
            }
            if (stepArray && stepArray.count > 0)
            {
                int uploadHourTime = 0;
//                int lastTime = [[Common sportTime] intValue];
                
                for (int i = 0; i < stepArray.count; i ++)
                {
                    int step = [stepArray[i] intValue];
                    if (step > 0)
                    {
                        float singleCal = ([kHCH.userInfoModel.weight floatValue] - 15) * 0.000693 + 0.005895;

                        float calories = singleCal * step;
                        NSDictionary * dic = @{@"startTime":[NSString stringWithFormat:@"%02d",i],
                                               @"steps":stepArray[i],
                                               @"cal":[NSString stringWithFormat:@"%.0f",calories]
                                               };
                        [valueArray replaceObjectAtIndex:i withObject:dic];
                        uploadHourTime = i;
                    }
                }
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                NSString *dateString = [formatter stringFromDate:date];
                
                NSDictionary *jsonDic = @{@"deviceId":kHCH.mac,@"openid":kHCH.mac,@"values":valueArray,@"type":kHCH.type,@"version":kHCH.version,@"date":dateString};
                NSDictionary *param = [kHCH changeToParamWithDic:jsonDic];
                NSString *url = [NSString stringWithFormat:@"%@/?token=%@",SPORTUPDATE,TOKEN];
                [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
//                    NSData *data = responseObject;
//                    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if (responseObject)
                    {
                        adaLog(@"%@",responseObject[@"message"]);
                        int code = [responseObject[@"code"] intValue];
                        if (code == 0)
                        {
                            [Common uploadSportTimeChangedWithTime:(timeSeconds + uploadHourTime)];
                        }
                    }
                }];
            }
        }
    }];
}

- (void)uploadHistoryHeartDataWithTimeSeconds:(int)timeSeconds
{
    HistoryDataModel *historyModel = [HistoryDataModel new];
    int lastTime = [[Common heartTime] intValue];
    [historyModel writeDateYearWithTimeSeconds:timeSeconds completion:^(userDataModel *dataModel) {
        if (dataModel)
        {
            sportModel *sportM = [NSKeyedUnarchiver unarchiveObjectWithData:dataModel.userData];
            NSArray *heartArray = sportM.heartArray;
            NSArray *stepArray = sportM.stepArray;
            NSMutableArray *valueArray = [[NSMutableArray alloc] init];
            NSMutableArray *valueArray1 = [[NSMutableArray alloc] init];
            int valueTimeSeconds = 0;
            for (int i = 0 ; i < heartArray.count; i ++)
            {
                int heart = [heartArray[i] intValue];
                if (heart > 0)
                {
                    int time = timeSeconds + i * 60;
                    if (time > lastTime)
                    {
                        NSDictionary *dic = @{@"time":intToString(time),@"rate":intToString(heart)};
                        [valueArray addObject:dic];
                        valueTimeSeconds = time;
                    }
                }
            }
            for (int i = 0; i < stepArray.count; i ++)
            {
                int step = [stepArray[i] intValue];
                if (step > 0)
                {
                    int time = timeSeconds + i * 60;
                    NSDictionary *dic = @{@"time":intToString(time),@"step":intToString(step)};
                    [valueArray1 addObject:dic];
                }
            }
            if (valueArray && valueArray.count != 0)
            {
                NSDictionary *jsonDic = @{@"deviceId":kHCH.mac,@"openid":kHCH.mac,@"rate":valueArray,@"type":kHCH.type,@"version":kHCH.version,@"step":valueArray1};
                NSDictionary *param = [kHCH changeToParamWithDic:jsonDic];
                NSString *url = [NSString stringWithFormat:@"%@",HEARTRATEUPDATE];
                [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
                    if (responseObject)
                    {
                        int code = [responseObject[@"code"] intValue];
                        if (code == 0)
                        {
                            adaLog(@"%@",responseObject[@"message"]);
                            [Common uploadHeartTimeChangedWithTime:valueTimeSeconds];
                        }
                    }
                }];

            }
        }
    }];
}

- (void)uploadSleepDataWithTimeSeconds:(int)timeSeconds
{
    HistoryDataModel *historyModel = [HistoryDataModel new];
    [historyModel getOneDaySleepWithTimeSeconds:timeSeconds Completion:^(oneDaySleepModel *model) {
        int sleepTime = model.timeSeconds;
        NSString *date = [[TimeCallManager getInstance] changeToYYYYMMDDStringWithTimeSeconds:sleepTime];
        
        int startTime = model.beginTime;
        if (startTime < 1080)
        {
            startTime = timeSeconds + startTime * 60;
        }else
        {
            startTime = timeSeconds - (1440 - startTime)*60;
        }
        int endTime = model.endTime - 10;
        if (endTime < 1080)
        {
            endTime = timeSeconds + endTime * 60;
        }else
        {
            endTime = timeSeconds - (1440 - endTime)*60;
        }
        
        int sportTime = model.deepSleepTime;
        int lightTime = model.lightSleepTime;
        int cleartTime = model.awakeSleepTime;
        
        NSDictionary *totalDic = @{@"date":date,@"startTime":intToString(startTime),@"endTime":intToString(endTime),@"sportime":intToString(sportTime),@"lighttime":intToString(lightTime),@"cleartime":intToString(cleartTime)};
        
        NSMutableArray *valueArray = [[NSMutableArray alloc] init];
        NSArray *sleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:model.sleepData];
        int lastTime = [[Common sleepTime] intValue];
        for (int i = 0 ; i < sleepArray.count; i ++)
        {
            int time = startTime + i * 1 * 60;
            int sq = 0;
            int state = [sleepArray[i] intValue];
            if (state == 18)
            {
                sq = 3;
            }else if (state == 19)
            {
                sq = 2;
            }else if (state == 20)
            {
                sq = 1;
            }
            if (sq /*&& time > lastTime*/)
            {
                NSDictionary *dic = @{@"time":intToString(time),@"sq":intToString(sq)};
                [valueArray addObject:dic];
            }
        }
        if (valueArray.count == 0)
        {
            return ;
        }
        NSDictionary *paramDic = @{@"deviceId":kHCH.mac,@"openid":kHCH.mac,@"type":kHCH.type,@"version":kHCH.version,@"total":totalDic,@"values":valueArray};
        NSString *url = [NSString stringWithFormat:@"%@/?token=%@",SLEEPUPDATE,TOKEN];
        NSDictionary *param = [kHCH changeToParamWithDic:paramDic];
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task)
         {
             if (responseObject){
                 int code = [responseObject[@"code"] intValue];
                 if (code == 0){
                     [Common uploadSleepTimeChangedWithTime:endTime];
                     adaLog(@"%@",responseObject[@"message"]);
                 }
             }
         }];
    }];
}

- (PZBlueToothManager *)manager
{
    return [PZBlueToothManager sharedInstance];
}

- (void)BlueToothStateChangedWithBLock:(void (^)(BOOL, CBPeripheral *))StateBlock
{
    if (StateBlock) {
        self.StateBlock = StateBlock;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    self.locationManager = nil;
}

#pragma mark - 上传定位
- (void)createLocation{
    
    self.locationmanager1 = [[CLLocationManager alloc] init];
    self.locationmanager1.delegate = self;
    [self.locationmanager1 requestAlwaysAuthorization];
    [self.locationmanager1 requestWhenInUseAuthorization];
    self.locationmanager1.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationmanager1.distanceFilter = 1000;
    [self.locationmanager1 startUpdatingLocation];
    _locationErrorNum = 0;
    
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
//    [_locationManager startUpdatingLocation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(startUploadLocation) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)startUploadLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] &&
        (status == kCLAuthorizationStatusAuthorizedWhenInUse
         || status == kCLAuthorizationStatusAuthorizedAlways)) {
            //定位功能可用，开始定位
            //单次定位
            _locationErrorNum = 0;
            kWEAKSELF
            [self.locationManager requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
                weakSelf.uploadNum = 0;
                if (location.rgcData) {
                    NSString *address = @"";
                    if ([location.rgcData.province isEqualToString:location.rgcData.city]) {
                        address = [NSString stringWithFormat:@"%@%@",location.rgcData.city,location.rgcData.district];
                    }else{
                        address = [NSString stringWithFormat:@"%@%@%@",location.rgcData.province,location.rgcData.city,location.rgcData.district];
                    }
                    [weakSelf requestUploadAddress:address lng:location.location.coordinate.longitude lat:location.location.coordinate.latitude environment:location.rgcData.locationDescribe];
                }else{
                    [weakSelf requestUploadAddress:@"" lng:location.location.coordinate.longitude lat:location.location.coordinate.latitude environment:@""];
                }
                [weakSelf.locationManager stopUpdatingLocation];
            }];
        }else{
            _locationErrorNum++;
            if (_locationErrorNum != 4) {
                [self performSelector:@selector(startUploadLocation) withObject:nil afterDelay:5];
            }
        }
}
//定时上传定位
- (void)requestUploadAddress:(NSString *)address lng:(double)lng lat:(double)lat environment:(NSString *)environment{
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",UPLOADLOCATION,TOKEN];
    NSString *lngStr = [NSString stringWithFormat:@"%.f",lng];
    NSString *latStr = [NSString stringWithFormat:@"%.f",lat];
    NSDictionary *para = @{@"userid":USERID,@"address":address,@"lng":@(lng),@"lat":@(lat),@"environment":environment};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            //上传成功
            NSLog(@"上传成功");
            BaseViewController *topmostVC = (BaseViewController *)[self topViewController];
            [topmostVC.view makeToast:@"心率监护:地理位置上传成功" duration:1.5 position:CSToastPositionCenter];
        }else{
            //上传失败
            if (self.uploadNum < 3) {
                [self requestUploadAddress:address lng:lng lat:lat environment:environment];
            }
            self.uploadNum++;
        }
    }];
}

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error{
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


@end
