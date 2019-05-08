//
//  CositeaBlueTooth.m
//  Mistep
//
//  Created by 迈诺科技 on 16/9/7.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZBlueToothManager.h"
#import "iOSDFULibrary-Swift.h"

#define intToString(x) [NSString stringWithFormat:@"%d",x]
#define ArraySize(ARR) ( (sizeof(ARR)) / ( sizeof(ARR[0])) )


@interface PZBlueToothManager()<BlutToothManagerDelegate,BlueToothScanDelegate>

@property (copy, nonatomic) intBlock batterayBlock;

@property (copy, nonatomic) arrayBlock deviceArrayBlock;

@property (copy, nonatomic) connectStateChanged connectStateBlock;

@property (copy, nonatomic) actualDataBlock actualModelBlock;

@property (copy, nonatomic) doubleIntBlock actualHeartBlock;

@property (copy, nonatomic)  historyDataBlock historyHourModelBlock;

@property (copy, nonatomic) hardVersionBlock hardVersionModelBlock;

@property (copy, nonatomic) alarmModelBlock alarmBlock;

@property (copy, nonatomic) notifyModelBlock notifyBlock;

@property (copy, nonatomic) sedentaryModelBlock sedentaryBlock;

@property (copy, nonatomic) intBlock LiftHandBlock;

@property (copy, nonatomic) intBlock heartRateStateBlock;


@property (copy, nonatomic) disturbModelBlock disturbBlock;

@property (copy,nonatomic) intBlock heartRateTime;


@property (copy, nonatomic) BlueToothScan *blueToothScan;

@property (copy, nonatomic) BlueToothManager *blueToothManager;

@end

@implementation PZBlueToothManager


- (void)dealloc
{
    self.blueToothScan.delegate = nil;
    self.blueToothManager.delegate = nil;
}

+ (PZBlueToothManager*)sharedInstance
{
    static PZBlueToothManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.blueToothManager.delegate = self;
        self.blueToothScan.delegate = self;
    }
    return self;
}

#pragma mark -- 扫描方法
- (void)scanDevicesWithBlock:(arrayBlock)deviceArrayBlock
{
    [self.blueToothScan startScan];
    if (deviceArrayBlock)
    {
        self.deviceArrayBlock = deviceArrayBlock;
    }
    [self performSelector:@selector(stopScan) withObject:nil afterDelay:1.f];
}

- (void)stopScan
{
    [self.blueToothScan stopScan];
}

#pragma mark -- BlueToothScanDelegate

- (void)blueToothScanDiscoverPeripheral:(NSMutableArray *)deviceArray
{
    if (self.deviceArrayBlock)
    {
        self.deviceArrayBlock(deviceArray);
    }
}

#pragma mark -- 连接蓝牙
- (void)connectWithUUID:(NSString *)UUID perName:(NSString *)perName Mac:(NSString *)mac;
{
    if (perName && perName.length != 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:perName forKey:[NSString stringWithFormat:@"%@macName",UUID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:mac forKey:[NSString stringWithFormat:@"%@mac",UUID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.blueToothManager ConnectWithUUID:UUID];
}




#pragma mark -- DFU升级
- (void)startDFUWithFirmWarePath:(NSString *)path andProgressBlock:(void (^) (int progress))progress errorBlock:(void(^)(NSString *error))error
{
    if (progress)
    {
        self.blueToothManager.progressBlock = progress;
    }
    if (error)
    {
        self.blueToothManager.errorBlock = error;
    }
    NSURL *url = [NSURL URLWithString:path];
    [self.blueToothManager beginOTAWithURL:url];
    
}

- (void)localOTAWithURL:(NSString *)url
{
    NSURL *localURL = [NSURL URLWithString:url];
    [self.blueToothManager beginOTAWithURL:localURL];
}

- (void)cancelDFU
{
    [self.blueToothManager cancelOTA];
}

#pragma mark -- 断开蓝牙
- (void)disConnectedPeripheral
{
    [self.blueToothManager disConnectPeripheralWithUuid:nil];
}

#pragma mark -- 发送蓝牙数据

- (void)getHardBatteryInformation:(intBlock)battery
{
    [self.blueToothManager getBatteryinformation];
    if (battery)
    {
        self.batterayBlock = battery;
    }
}

- (void)getActualDataWithDataBlockWithBlock:(actualDataBlock)modelBlock
{
    [self.blueToothManager getActualData];
    if (modelBlock)
    {
        self.actualModelBlock = modelBlock;
    }
}

- (void)switchActualHeartStateWithState:(BOOL)state andActualHeartBlock:(doubleIntBlock)actualHeartBlock
{
    [self.blueToothManager changeHeartStateWithState:state];

    if (actualHeartBlock) {
        self.actualHeartBlock = actualHeartBlock;
    }
}

- (void)getHardWearVersionWithHardVersionBlock:(hardVersionBlock)hardVersionModelBlock
{
    [self.blueToothManager getHardwareVersion];
    if (hardVersionModelBlock)
    {
        self.hardVersionModelBlock = hardVersionModelBlock;
    }
}

- (void)getAlarmWithAlarmID:(int)alarmID andAlarmModelBlock:(alarmModelBlock)block
{
    [self.blueToothManager getAlarmDataWithID:alarmID];
    if (block) {
        self.alarmBlock = block;
    }
}

- (void)setAlarmWithAlarmID:(int)alarmID State:(int)state Hour:(int)hour Minute:(int)minute Repeat:(int)repeat
{
    [self.blueToothManager setAlarmWithAlarmID:alarmID State:state Hour:hour Minute:minute Repeat:repeat];
}

- (void)setAlarmNameWithAlarmID:(int)alarmID Name:(NSString *)name
{
    [self.blueToothManager setAlarmNameWithAlarmID:alarmID Name:name];
}

- (void)getNotifyWithBlock:(notifyModelBlock)notify
{
    [self.blueToothManager getSystemNotify];
    if (notify) {
        self.notifyBlock = notify;
    }
}

- (void)setNotifyWithNotifyModel:(NotifyModel *)model
{
    [self.blueToothManager setNotifyWithNotifyModel:model];
}

- (void)getSedentaryWithSedentaryModelBlock:(sedentaryModelBlock)block;
{
    [self.blueToothManager getSedentaryData];
    if (block)
    {
        self.sedentaryBlock = block;
    }
}

- (void)setSedentaryWithSedentaryModel:(SedentaryModel *)model
{
    [self.blueToothManager setSedentaryWithSedentaryWithSedentaryModel:model];
}

- (void)findBracelet
{
    [self.blueToothManager findBracelet];
}

- (void)changetakePhoteStateWithState:(BOOL)state
{
    [self.blueToothManager changeTakePhoteStateWithState:state];
}

- (void)getLiftHandStateWithBlock:(intBlock)block
{
    [self.blueToothManager getLiftHandState];
    if (block) {
        self.LiftHandBlock = block;
    }
}

- (void)setLiftHandStateWithState:(int)State
{
    [self.blueToothManager setLiftHandStateWithState:State];
}

- (void)getHeartRateStateWithBlock:(intBlock)block
{
    [self.blueToothManager getHeartRateState];
    if (block) {
        self.heartRateStateBlock = block;
    }
}

- (void)getHeartRateTimeinterverWithBlock:(intBlock)block
{
    [self.blueToothManager getHeartRateTime];
    if (block)
    {
        self.heartRateTime = block;
    }
}

- (void)setHeartRateStateWithState:(int)state
{
    [self.blueToothManager setHeartRateStateWithState:state];
}

- (void)getDisturbModelWithBlock:(disturbModelBlock)block
{
    [self.blueToothManager getDisturbInformation];
    if (block) {
        self.disturbBlock = block;
    }
}

- (void)setDisturbWithDisturbModel:(DisturbModel *)model
{
    [self.blueToothManager setDisturbInformationWith:model];
}

- (void)getHistoryDataWithYeah:(int)yeah Month:(int)month Day:(int)day andHour:(int)hour DataBlock:(historyDataBlock)modelBlock;
{
    [self.blueToothManager getHistoryDataWithyeah:yeah month:month day:day andHour:hour];
    if (modelBlock) {
        self.historyHourModelBlock = modelBlock;
    }
}

- (void)sendUserInformationWithHeight:(int)height weight:(int)weight gender:(int)gender
{
    [self.blueToothManager sendUserInformationWithHeight:height weight:weight gender:gender];
}

- (void)sendUserBph:(int)bph bpl:(int)bpl glu:(int)glu spo1:(int)spo1 spo2:(int)spo2{
    [self.blueToothManager sendUserBph:bph bpl:bpl glu:glu spo1:spo1 spo2:spo2];
}

- (void)setBindUnit:(int)unit andTimeType:(int)timeType isEnglish:(BOOL)isEnglish;
{
    [self.blueToothManager setBindUnitWith:unit andTimeType:timeType isEnglish:isEnglish];
}
- (void)setHeartRateTimeWithTime:(int)minites
{
    [self.blueToothManager setHeartRateTimeIntervel:minites];
}


#pragma mark -- 接收蓝牙数据

- (void)connectStateChangedWithBlock:(connectStateChanged)connectStateBlock
{
    if (connectStateBlock)
    {
        self.connectStateBlock = connectStateBlock;
    }
}

#pragma mark -- BlutToothManagerDelegate

- (void)blueToothManagerIsConnected:(BOOL)isConnected connectPeripheral:(CBPeripheral *)peripheral
{
    if (self.connectStateBlock)
    {
        self.connectStateBlock(isConnected,peripheral);
    }
}

#pragma mark   -- -  常用

//代理回调了数据，在这里分发
- (void)blueToothManagerReceiveNotifyData:(NSData *)Dat
{
    adaLog(@"收到的蓝牙数据：%@",Dat);
    Byte *transDat = (Byte *)[Dat bytes];
    int command_id = transDat[0];
    int key = transDat[1];
    switch (command_id) {
        case 0x02:
        {
            switch (key) {
                    
                case 0x01:
                    [self recieveHardVersionData:Dat];
                    break;
                case 0x05:
                {
                    int battery = transDat[5];
                    self.batterayBlock(battery);
                }
                    break;
                case 0x07:
                    [self recieveActualDatwithData:Dat];
                    break;
                case 0x08:
                    [self recieveHistoryData:Dat];
                    break;
                case 0x09:
                {
                    int state = transDat[2];
                    int hr = transDat[3];
                    if (self.actualHeartBlock) {
                        self.actualHeartBlock(state,hr);
                    }
                }
                    break;
                    
                case 0x11:
                    [self getNotifyData:Dat];
                    break;
                case 0x12:
                    [self recieveAlarmDataWithData:Dat];
                    break;
                case 0x15:
                    [self recieveSedentaryWithData:Dat];
                    break;
                case 0x16:
                {
                    int State = transDat[2];
                    if (self.heartRateStateBlock)
                    {
                        self.heartRateStateBlock(State);
                    }
                }
                    break;
                case 0x17:
                {
                    int State = transDat[2];
                    if (self.LiftHandBlock)
                    {
                        self.LiftHandBlock(State);
                    }
                }
                    break;
                case 0x18:
                {
                    [self recieveDisturbData:Dat];
                }
                    break;
                case 0x26:
                {
                    int time = transDat[2];
                    if (self.heartRateTime)
                    {
                        self.heartRateTime(time);
                    }
                }
                    break;
                default:
                    break;
                    
            }
        }
            break;
        case 0x07:
        {
            if (key == 0x02)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:findMyPhone object:nil];
            }
            if (key == 0x03)
            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:sendSOS object:nil];
            }
            if (key == 0x01)
            {
                int state = transDat[2];
                switch (state)
                {
                    case 1:
                        [[NSNotificationCenter defaultCenter] postNotificationName:playMusic object:nil];
                        break;
                    case 2:
                        [[NSNotificationCenter defaultCenter] postNotificationName:pauseMusic object:nil];
                        break;
                    case 4:
                        [[NSNotificationCenter defaultCenter] postNotificationName:lastSong object:nil];
                        break;
                    case 5:
                        [[NSNotificationCenter defaultCenter] postNotificationName:nextSong object:nil];
                        break;
                    case 6:
                    [[NSNotificationCenter defaultCenter] postNotificationName:takePhoto object:nil];
                        break;
                    case 7:
                        [[NSNotificationCenter defaultCenter] postNotificationName:beginTakePhoto object:nil];
                        break;
                    case 8:
                        [[NSNotificationCenter defaultCenter] postNotificationName:endTakePhoto object:nil];
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 接收到蓝牙数据后处理方法

- (void)getNotifyData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];
    NotifyModel *model = [NotifyModel new];
    model.notifyState = transDat[2];
    int item0 = transDat[3];
    int item1 = transDat[4];
    int callDelay = transDat[5];
    model.SMSState = (item0 >> 1) & 0x01;
    model.CallState = (item0 >> 2) & 0x01;
    model.EmailState = (item0 >> 3) & 0x01;
    model.WechartState = (item0 >> 4) & 0x01;
    model.QQState = (item0 >> 5) & 0x01;
    model.FacebookState = (item0 >> 6) & 0x01;
    model.TwitterState = (item0 >> 7) & 0x01;
    model.WhatsAppState = item1 & 0x01;
    model.MessengerState = (item1 >> 1) & 0x01;
    model.InstagramState = (item1 >> 2) & 0x01;
    model.LinkedinState = (item1 >> 4) & 0x01;
    model.callDelay = callDelay;
    self.notifyBlock(model);

}

- (void)recieveHardVersionData:(NSData *)data
{
    NSData *nameData = [data subdataWithRange:NSMakeRange(2, 16)];
    NSString *nameString = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
    HardWearVersionModel *model = [HardWearVersionModel new];
    model.nameString = nameString;
//    Byte *transDat = (Byte *)[data bytes];
    
//    model.mainSoftVersion = [self combineDataWithAddr:transDat + 14 andLength:2];
//    adaLog(@"name = %@,main = %d",model.nameString,model.mainSoftVersion);
    if (self.hardVersionModelBlock) {
        self.hardVersionModelBlock(model);
    }
}

- (void)recieveActualDatwithData:(NSData*)data
{
    if (data && data.length != 0)
    {
        Byte *transDat = (Byte *)[data bytes];
        ActualDataModel *model = [[ActualDataModel alloc] init];
        model.steps = [self combineDataWithAddr:transDat+2 andLength:3];
        model.hr = transDat[5];
        model.distance = [self combineDataWithAddr:transDat + 8 andLength:3];
        model.calories = [self combineDataWithAddr:transDat + 11 andLength:3];
        if (self.actualModelBlock)
        {
            self.actualModelBlock(model);
        }
    }
}

- (void)recieveAlarmDataWithData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];

    int getAlarmID = transDat[2];
    int status = transDat[3];
    int alarmHour = transDat[4];
    int alarmMin = transDat[5];
    int repeats = transDat[6];
   
    AlarmModel *model = [AlarmModel new];
    model.state = status;
    model.hour = alarmHour;
    model.minute = alarmMin;
    model.repeats = repeats;
    model.idNum = getAlarmID;
    
    if (self.alarmBlock)
    {
        self.alarmBlock(model);
    }
}

- (void)recieveSedentaryWithData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];
    SedentaryModel *model = [SedentaryModel new];
    model.beginHour = transDat[2];
    model.beginMin = transDat[3];
    model.endHour = transDat[4];
    model.endMin = transDat[5];
    model.timeInteval = [self combineDataWithAddr:transDat + 6 andLength:2];
    model.repeats = transDat[8];
    if (self.sedentaryBlock)
    {
        self.sedentaryBlock(model);
    }
}

- (void)recieveDisturbData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];
    DisturbModel *model = [DisturbModel new];
    model.State = transDat[2];
    model.beginHour = transDat[3];
    model.beginMin = transDat[4];
    model.endHour = transDat[5];
    model.endMin = transDat[6];
    if (self.disturbBlock)
    {
    self.disturbBlock(model);
    }
}

- (void)recieveHistoryData:(NSData *)data
{
    if (!data || data.length ==0)
    {
        return;
    }
    Byte *transDat = (Byte *)[data bytes];
    int year = transDat[2] + 2000;
    int mouth = transDat[3];
    int day = transDat[4];
    int hour = transDat[5];
    int calmHR = transDat[6];
    int len = transDat[7];
    NSMutableArray *stateArray = [[NSMutableArray alloc] init];
    NSMutableArray *heartArray = [[NSMutableArray alloc] init];
    NSMutableArray *BPHArray = [[NSMutableArray alloc] init];
    NSMutableArray *BPLArray = [[NSMutableArray alloc] init];
    NSMutableArray *stepArray = [[NSMutableArray alloc] init];
    int steps = 0;
    
    if (len == 42)
    {
        for (int i = 0 ; i < len/7; i ++)
        {
            int status = transDat[8 + i * 7];
            int step = [self combineDataWithAddr:transDat + (9 + i * 7 ) andLength:3];
            int hr = transDat[12 + i * 7];
            int BPL = transDat[13 + i * 7];
            int BPH = transDat[14 + i *7];
            steps += step;
            [stepArray addObject:[NSString stringWithFormat:@"%d",step]];
            [stateArray addObject:[NSString stringWithFormat:@"%d",status]];
            for (int i = 0; i < 3; i ++)
            {
                [heartArray addObject:@"0"];
            }
            [heartArray addObject:[NSString stringWithFormat:@"%d",hr]];
            [BPHArray addObject:[NSString stringWithFormat:@"%d",BPH]];
            [BPLArray addObject:[NSString stringWithFormat:@"%d",BPL]];
        }
    }else if (len == 60)
    {
        for (int i = 0 ; i < len/10; i ++)
        {
            int status = transDat[8 + i * 10];
            int step = [self combineDataWithAddr:transDat + (9 + i * 10 ) andLength:3];
            int hr1 = transDat[12 + i*10];
            int hr2 = transDat[13 + i*10];
            int hr3 = transDat[14 + i*10];
            int hr4 = transDat[15 + i*10];

            int BPL = transDat[16 + i * 10];
            int BPH = transDat[17 + i *10];
            steps += step;
            [stepArray addObject:[NSString stringWithFormat:@"%d",step]];
            [stateArray addObject:[NSString stringWithFormat:@"%d",status]];
            
            [heartArray addObject:[NSString stringWithFormat:@"%d",hr1]];
            [heartArray addObject:[NSString stringWithFormat:@"%d",hr2]];
            [heartArray addObject:[NSString stringWithFormat:@"%d",hr3]];
            [heartArray addObject:[NSString stringWithFormat:@"%d",hr4]];

            
            [BPHArray addObject:[NSString stringWithFormat:@"%d",BPH]];
            [BPLArray addObject:[NSString stringWithFormat:@"%d",BPL]];
        }
    }

    
    historyDataHourModel *hourModel = [[historyDataHourModel alloc] init];
    hourModel.yeah = year;
    hourModel.month = mouth;
    hourModel.day = day;
    hourModel.hour = hour;
    hourModel.calmHR = calmHR;
    hourModel.totalSteps = steps;
    hourModel.stepArray = stepArray;
    hourModel.stateArray = stateArray;
    hourModel.heartArray = heartArray;
    hourModel.BPHArray = BPHArray;
    hourModel.BPLArray = BPLArray;
    if (self.historyHourModelBlock)
    {
        self.historyHourModelBlock(hourModel);
    }
}

#pragma mark -- 收到离线数据历史数据等


#pragma mark -- 处理数据工具方法
- (int)combineDataWithAddr:(Byte *)addr andLength:(int)len {
    int result = 0;
    for (int index = 0; index < len; index ++) {
        result = result | ((*(addr + index)) << (8 *index));
        
    }
    if (result < 0)
    {
        result = 0;
    }
    return result;
}

- (int)getRepeatStatusWithArray:(NSArray*)repeatArray
{
    int status = 0;
    for (int i = 0; i < 7; i ++)
    {
        if ([repeatArray[i] intValue] == YES)
        {
            status = status| (0x01 << (i));
        }
    }
    return status;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


- (NSString *)transToUnicodStringWithString:(NSString *)string
{
    NSMutableString *resultStr = [[NSMutableString alloc]initWithCapacity:0];
    for (int i = 0; i < string.length/4; i++)
    {
        NSMutableString *mutString = [[NSMutableString alloc] initWithCapacity:0];
        NSRange range = NSMakeRange(4*i, 4);
        NSString *cString = [string substringWithRange:range];
        [mutString appendString:[cString substringWithRange:NSMakeRange(2, 2)]];
        [mutString appendString:[cString substringWithRange:NSMakeRange(0, 2)]];
        [resultStr appendString:@"\\u"];
        [resultStr appendString:mutString];
    }
    return resultStr;
}


#pragma mark -- 内部调用方法


#pragma mark -- 全局变量get方法

- (BlueToothScan *)blueToothScan
{
    if (!_blueToothScan)
    {
        _blueToothScan = [[BlueToothScan alloc] init];
    }
    return _blueToothScan;
}

- (BlueToothManager *)blueToothManager
{

    return [BlueToothManager getInstance];
}

@end
