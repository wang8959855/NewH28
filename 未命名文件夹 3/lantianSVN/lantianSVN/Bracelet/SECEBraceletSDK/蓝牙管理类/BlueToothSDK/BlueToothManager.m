//
//  BlueToothManager.m
//  TestBlueToothVector
//
//  Created by zhangtan on 14-9-24.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#import "BlueToothManager.h"
#import "iOSDFULibrary-Swift.h"

#define ArraySize(ARR) ( (sizeof(ARR)) / ( sizeof(ARR[0])) )



//#define HeartRate_Service_UUID  @"Heart Rate"

//#define HeartRate_Service_UUID  @"180D"

NSString *const kServiceUUIDString = @"0AF0";
NSString *const kWriteCharacteristicUUIDString = @"0AF6";   //写UUID
NSString *const kNotifyCharacteristicUUIDString = @"0AF7"; // 通知UUID

//#define WriteService_UDID @"FFF0"
//#define WriteCharactic_UUID  @"FFF3"


@interface BlueToothManager()<CBCentralManagerDelegate,CBPeripheralDelegate,LoggerDelegate,DFUServiceDelegate,DFUProgressDelegate>{
    CBCentralManager *cbCenterManger;
    CBService *cbServices;
    CBCharacteristic *cbCharacteristcs;
    
    CBPeripheral *cbPeripheral;
    
    CBCharacteristic *rdCharactic1;
    CBCharacteristic *notifyCharactic;
    
    
    
    
    NSMutableArray *uuidArray ;
    NSData *sendData;
    
    uint revTotalCount;
    uint revTotalBytes;
    BOOL isMulRev;
    NSData *toSendData_OAD;
    
    BOOL isPersonOper;
    BOOL isConnecting;
    NSTimer *myTimer;
    int connectTime;//连接了几次蓝牙
 
    
}
@property (nonatomic, strong)NSMutableData *reciveData;

@property (nonatomic, strong)DFUServiceController *controller;


@end
static BlueToothManager *instance;

@implementation BlueToothManager

- (void)dealloc{
    [cbCenterManger stopScan];
    cbPeripheral.delegate = nil ;
    cbCenterManger.delegate = nil ;
    cbCenterManger = nil;
    if( cbPeripheral ){
        [cbCenterManger cancelPeripheralConnection:cbPeripheral];
    }
    cbServices = nil ;
    cbCharacteristcs = nil ;
    rdCharactic1 = nil ;
    sendData = nil;
}

+ (BlueToothManager *)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BlueToothManager alloc] init];
    });
    return instance ;
}

+ (void)clearInstance{
    instance = nil ;
}
- (instancetype)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

- (void)initData{
    revTotalCount = 0;
    revTotalBytes = 0;
    connectTime = 0;
    _connectTimeAlert = 1;
    isMulRev = NO;
    self.canPaired = YES;
    [self startScan];
}

- (NSMutableData *)reciveData
{
    if (!_reciveData)
    {
        _reciveData = [[NSMutableData alloc] init];
    }
    return _reciveData;
}

- (void)startScan{
    if (!cbCenterManger) {
        cbCenterManger = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
}

- (void)stopScan {
    if (cbCenterManger) {
        [cbCenterManger stopScan];
        cbCenterManger = nil;
    }
}

- (void)ConnectPeripheral:(CBPeripheral *)peripheral {
    if (peripheral) {
        cbPeripheral = peripheral;
        [cbCenterManger connectPeripheral:cbPeripheral options:nil];
        isConnecting = YES;
        [self performSelector:@selector(connectOutTime) withObject:nil afterDelay:5.f];

    }
}

-(void)updateLog:(CBCentralManagerState)s
{
    if (_delegate&&[_delegate respondsToSelector:@selector(callbackCBCentralManagerState:)])
    {
        [_delegate callbackCBCentralManagerState:s];
    }
}

- (void)ConnectWithUUID:(NSString *)connectUUID{
    //    NSArray *array = [cbCenterManger retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFF0"]]];
    NSArray *array = [cbCenterManger retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFF0"],[CBUUID UUIDWithString:@"0AF0"]]];
    for (NSInteger index = 0; index < array.count; index++) {
        cbPeripheral = array[index];
        NSString *llString;
        
        llString = cbPeripheral.identifier.UUIDString;
        if ([llString isEqualToString:connectUUID]) {
            self.connectUUID = connectUUID;
            [cbCenterManger connectPeripheral:cbPeripheral options:nil];
            return;
        }
    }
    
    if (_isConnected) {
        return;
    }
    _connectUUID = connectUUID ;
    
    isConnecting = NO;
    if( cbPeripheral.state == CBPeripheralStateConnected || cbPeripheral.state == CBPeripheralStateConnecting ){
    }else{
        [cbCenterManger stopScan];
        [cbCenterManger scanForPeripheralsWithServices:nil
                                               options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }
}

- (void)connectOutTime
{
    isConnecting = NO;
}

- (void)disConnectPeripheralWithUuid:(NSString *)uuid {
    //    if ([uuid isEqualToString:self.connectUUID]) {
    
    if (cbPeripheral  && notifyCharactic) {
        [cbPeripheral setNotifyValue:NO forCharacteristic:notifyCharactic];
    }
    if (cbPeripheral && cbCenterManger) {
        [cbCenterManger cancelPeripheralConnection:cbPeripheral];
        [cbCenterManger stopScan];
    }
    isPersonOper = YES;
    self.connectUUID = @"";
    if (myTimer.isValid)
    { [myTimer invalidate]; myTimer = nil;
      }
        self.connectUUID = nil;
}

- (void)setIsConnected:(BOOL)isConnected
{
    _isConnected = isConnected;
    isConnecting = NO;
}

#pragma mark
#pragma mark centerBlueManagere Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            [self updateLog:CBCentralManagerStatePoweredOff];
            //[self updateLog:@"CoreBluetooth BLE hardware is Powered off"];
            self.isConnected = NO;
            self.sendingData = nil;
            [self.dataArray removeAllObjects];
 
            self.deviceName = nil;
            if( [_delegate respondsToSelector:@selector(blueToothManagerIsConnected: connectPeripheral:)] ){
                [_delegate blueToothManagerIsConnected:NO connectPeripheral:nil];
            }
            break;
        case CBCentralManagerStatePoweredOn:
            [self updateLog:CBCentralManagerStatePoweredOn];
            //[self updateLog:@"CoreBluetooth BLE hardware is Powered on and ready"];
            //if([ADASaveDefaluts objectForKey:kLastDeviceUUID]){
                if (!myTimer ) {
                    myTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(timeFired:) userInfo:nil repeats:YES];
                }
           
            break;
        case CBCentralManagerStateResetting:
            [self updateLog:CBCentralManagerStateResetting];
           // [self updateLog:@"CoreBluetooth BLE hardware is resetting"];
            break;
        case CBCentralManagerStateUnauthorized:
            [self updateLog:CBCentralManagerStateUnauthorized];
           // [self updateLog:@"CoreBluetooth BLE state is unauthorized"];
            break;
        case CBCentralManagerStateUnknown:
            [self updateLog:CBCentralManagerStateUnknown];
          //  [self updateLog:@"CoreBluetooth BLE state is unknown"];
            break;
        case CBCentralManagerStateUnsupported:
            [self updateLog:CBCentralManagerStateUnsupported];
            //[self updateLog:@"CoreBluetooth BLE hardware is unsupported on this platform"];
            break;
        default:
            break;
    }
}



- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict{
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
}



- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if (_isOTAMode)
    {
        if (![peripheral.name isEqualToString:@"DfuTarg"] || _isOTAIng)
        {

            return;
        }
        if (_url)
        {
            self.isOTAIng = YES;
            [cbCenterManger stopScan];
            [myTimer invalidate];
            myTimer = nil;
//            sleep(3);
                DFUFirmware * selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:_url];
                adaLog(@"%@",selectedFirmware);
                
                DFUServiceInitiator * initiator = [[DFUServiceInitiator alloc ] initWithCentralManager: cbCenterManger target: peripheral];
                initiator = [initiator withFirmware:selectedFirmware];
                initiator.logger = self;
                initiator.delegate = self;
                initiator.progressDelegate = self;
                _controller = [initiator start];
        }
        return;
    }
    
    NSString *llString;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    llString = [NSString stringWithFormat:@"%@",peripheral.UUID];
#else
    llString = peripheral.identifier.UUIDString;
#endif
    
    if( !_connectUUID ){
        return;
    }else if([_connectUUID isEqualToString:llString] && !isConnecting){
        cbPeripheral = peripheral;
        [cbCenterManger connectPeripheral:cbPeripheral options:nil];
        isConnecting = YES;
        [self performSelector:@selector(connectOutTime) withObject:nil afterDelay:5.f];
    }
    //连接设备
    //[cbCenterManger connectPeripheral:cbPeripheral options:nil];//451964
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    cbPeripheral = peripheral;
    //停止扫描
    [cbCenterManger stopScan];
    self.deviceName = peripheral.name;
    
    NSString *llString;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    llString = [NSString stringWithFormat:@"%@",peripheral.UUID];
#else
    llString = peripheral.identifier.UUIDString;
#endif
    self.connectUUID = llString;
    
    //发现services
    //设置peripheral的delegate未self非常重要，否则，didDiscoverServices无法回调
    cbPeripheral.delegate = self;
    
    //    NSArray *array = [NSArray arrayWithObjects:
    //                      [CBUUID UUIDWithString:@"FFE0"],
    //                      nil];
    [cbPeripheral discoverServices:nil];
    if (myTimer.isValid) {
        [myTimer invalidate];
        myTimer = nil;
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    rdCharactic1 = nil ;
    notifyCharactic = nil;
    cbPeripheral = nil;
    [self performSelector:@selector(readRSSI) withObject:nil afterDelay:0.5f];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(readRSSI) object: nil];
    if (_isConnected) {
        if(
           [_delegate respondsToSelector:@selector(blueToothManagerIsConnected: connectPeripheral:)]){
            [_delegate blueToothManagerIsConnected:NO connectPeripheral:nil];
        }
    }
    self.isConnected = NO;
    [self.dataArray removeAllObjects];
    self.sendingData = nil;
    
    isPersonOper = NO;
    revTotalCount = 0;
    revTotalBytes = 0;
    isMulRev = NO;
    //    [reviceData subdataWithRange:NSMakeRange(0, 0)];
    self.reciveData = nil;

    if (!myTimer && !isPersonOper) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(timeFired:) userInfo:nil repeats:YES];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSArray *array = [peripheral services];
    for( CBService *service in array ){
        NSString *string = [NSString stringWithFormat:@"%@",service.UUID];
        
        if( [string isEqualToString:kServiceUUIDString]){
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    adaLog(@"device connect");
    self.isConnected = YES;
    self.sendingData = nil;
}




- (void)changeCanPaire
{
    self.canPaired = YES;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    for( CBCharacteristic *c in service.characteristics ){
        NSString *string = [NSString stringWithFormat:@"%@",c.UUID];
        if( [string isEqualToString:kNotifyCharacteristicUUIDString]){
            [cbPeripheral setNotifyValue:YES forCharacteristic:c];
            notifyCharactic = c;
        }else if( [string isEqualToString:kWriteCharacteristicUUIDString] ){
            rdCharactic1 = c ;
        }
    }
    NSString *string = [NSString stringWithFormat:@"%@",service.UUID];
    if( [string isEqualToString:kServiceUUIDString]){
        [cbPeripheral setNotifyValue:YES forCharacteristic:notifyCharactic];
        if( [_delegate respondsToSelector:@selector(blueToothManagerIsConnected:connectPeripheral:)] ){
            [_delegate blueToothManagerIsConnected:YES connectPeripheral:peripheral];
        }
        [self performSelector:@selector(synsCurTime) withObject:nil afterDelay:0.2f];
        [self performSelector:@selector(readRSSI) withObject:nil afterDelay:0.5f];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error
{
    adaLog(@"%@",RSSI);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RSSI" object:RSSI];
}

- (void)readRSSI
{
    if (_isConnected)
    {
        [cbPeripheral readRSSI];
    }
    [self performSelector:@selector(readRSSI) withObject:nil afterDelay:10.];
}

- (void)connectReload
{
    self.sendingData = nil;
}



- (void)reloadBlueToothData
{
    if (_isConnected == YES  )
    {
       
    }
}




- (void)recieveDataUpdate
{

}

#pragma  - - - mark - - - - 接受数据的方法- -- - -- - - didUpdateValueForCharacteristic
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    adaLog(@"[characteristic value] == %@",[characteristic value]);
    
    NSString *string = [NSString stringWithFormat:@"%@",[characteristic UUID]];
    if( [string isEqualToString:kNotifyCharacteristicUUIDString]){
        NSData *notifyData = [characteristic value];
        Byte *transDat = (Byte *)[notifyData bytes];
        int command_id = transDat[0];
        int key = transDat[1];
        if(command_id == 0x02 && key == 0x08)
        {
            [self.reciveData appendData:characteristic.value];
            return;
        }else
            if (self.reciveData.length != 0)
            {
                [self.reciveData appendData:characteristic.value];
                Byte * tempData = (Byte *)[self.reciveData bytes];
                int len = tempData[7];
                
                if (self.reciveData.length == len + 8)
                {
                NSData *toSendData = [self.reciveData subdataWithRange:NSMakeRange(0, self.reciveData.length)];
                self.reciveData = nil;
                    if (_delegate && [_delegate respondsToSelector:@selector(blueToothManagerReceiveNotifyData:)])
                    {
                        
                        if (_sendingData && _sendingData.length != 0)
                        {
                            if ([[_sendingData subdataWithRange:NSMakeRange(0, 2)] isEqualToData: [toSendData subdataWithRange:NSMakeRange(0, 2)]])
                            {
                                self.sendingData = nil;
                                [_delegate blueToothManagerReceiveNotifyData:toSendData];
                            }
                            
                        }
                        [self blueToothWhriteTransData:nil isNeedResponse:YES];
                    }
                return;
                    
                }else if (self.reciveData.length > len + 8)
                {
                    self.reciveData = nil;
                }
            }else
            {
                NSData *toSendData = characteristic.value;
                if (_delegate && [_delegate respondsToSelector:@selector(blueToothManagerReceiveNotifyData:)])
                {
                    
                    if (_sendingData && _sendingData.length != 0)
                    {
//                        adaLog(@"%@",[_sendingData subdataWithRange:NSMakeRange(0, 2)]);
                        if ([[_sendingData subdataWithRange:NSMakeRange(0, 2)] isEqualToData:[toSendData subdataWithRange:NSMakeRange(0, 2)]])
                        {
                            self.sendingData = nil;
                        }
                    }
                    
                    [_delegate blueToothManagerReceiveNotifyData:toSendData];

                    [self blueToothWhriteTransData:nil isNeedResponse:YES];
                }
            }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSString *string = [NSString stringWithFormat:@"%@",[characteristic UUID]];
    if (sendData != nil && [string isEqualToString:kWriteCharacteristicUUIDString]) {
        if ([sendData length] > 20) {
            [cbPeripheral writeValue:[sendData subdataWithRange:NSMakeRange(0, 20)] forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithResponse];
            NSInteger len = [sendData length];
            sendData = [sendData subdataWithRange:NSMakeRange(20, len - 20)];
        }else if([sendData length] > 0){
            NSData *data = [sendData subdataWithRange:NSMakeRange(0, sendData.length)];
            [cbPeripheral writeValue:data forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithResponse];
            sendData = [sendData subdataWithRange:NSMakeRange(0, 0)];
        }else {
            sendData = nil;
        }
    }
    
}

- (NSString *)getHexStringWithValue:(int)values{
    NSString *newHexStr = [NSString stringWithFormat:@"%x",values&0xff];
    if([newHexStr length]==1)
        newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
    else
        newHexStr = [NSString stringWithFormat:@"%@",newHexStr];
    
    newHexStr = [NSString stringWithFormat:@"0x%@",newHexStr];
    
    return newHexStr ;
}

-(NSData *)utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
    {
        NSString *cString = [NSString stringWithFormat:@"%.4x",[string characterAtIndex:i]];
        NSMutableString *mutString = [[NSMutableString alloc] initWithCapacity:4];
        [mutString appendString:[cString substringWithRange:NSMakeRange(2, 2)]];
        [mutString appendString:[cString substringWithRange:NSMakeRange(0, 2)]];
        [s appendString:mutString];
    }
    NSData *unicodeData = [self stringToHexDataWithString:s];
    return unicodeData;
}

//    把内容为16进制的字符串转换为数组
- (NSData *)stringToHexDataWithString:(NSString *)string
{
    NSInteger len = [string length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    return data;
}



#pragma mark   - - -  多写注释
/**判断蓝牙外设连接状态的方法*/
-(BOOL)readDeviceIsConnect:(CBPeripheral *)device{
    if(device.state == CBPeripheralStateConnected) {
        return YES;//连接状态
    } else {
        return NO;//未连接状态(断开状态)
    }
}

#pragma mark
#pragma mark OAD operate



#pragma mark -固件升级

- (void)cancelOTA
{
    if (_controller)
    {
        [_controller abort];
        self.controller = nil;
        self.isOTAMode = NO;
        self.isOTAIng = NO;
        cbCenterManger = nil;
        cbCenterManger = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
}

- (void)beginOTAWithURL:(NSURL *)url
{
    self.isOTAMode = YES;
    self.url = url;
    Byte transDat[] = {0x01,0x01};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [cbPeripheral writeValue:data forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithResponse];
   
    if (!myTimer ) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(timeFired:) userInfo:nil repeats:YES];
    }
}

#pragma mark -- delegate
- (void)logWith:(enum LogLevel)level message:(NSString * _Nonnull)message
{
    adaLog(@"LogMessage:%@,%ld",message,(long)level);
}

- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond
{
    if (self.progressBlock)
    {
        self.progressBlock(progress);
    }
    if (progress == 100)
    {
        self.isOTAIng = NO;
        self.isOTAMode = NO;
        self.controller = nil;
        cbCenterManger = nil;
        cbCenterManger = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }

    adaLog(@"PROGress :part:%ld,totalParts:%ld,progress:%ld,speed:%f,avgSpeed:%f",(long)part,(long)totalParts,(long)progress,currentSpeedBytesPerSecond,avgSpeedBytesPerSecond);
}

- (void)dfuStateDidChangeTo:(enum DFUState)state
{
    
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString * _Nonnull)message
{
    if (self.errorBlock)
    {
        self.errorBlock(message);
    }
    adaLog(@"dfuError:%@",message);
}


#pragma mark -- 发送数据

- (void)getBatteryinformation
{
    Byte transDat[] = {0x02,0x5};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)getActualData
{
    Byte transDat[] = {0x02,0x07};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

/**
 实时心率测量开关

 @param state 开关状态
 */
- (void)changeHeartStateWithState:(BOOL)state
{
    Byte transDat[] = {0x02,0x09,state};
    NSData *data = [NSData dataWithBytes:transDat length:3];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}


/**
 同步时间
 */
- (void)synsCurTime {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday fromDate:date];

    Byte transData[] = {0x03,0x01,comps.year - 2000,comps.month,comps.day,comps.hour,comps.minute,comps.second};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}


/**
 获取历史数据

 @param yeah 年
 @param month 月
 @param day 日
 @param hour 小时
 */
- (void)getHistoryDataWithyeah:(int)yeah month:(int)month day:(int)day andHour:(int)hour
{
    Byte transDat[] = {0x02,0x19,yeah - 2000,month,day,hour};
    NSData *data = [NSData dataWithBytes:transDat length:ArraySize(transDat)];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)getHardwareVersion
{
    Byte transDat[] = {0x02,0x01};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)getAlarmDataWithID:(int)idnumber
{
    Byte transDat[] = {0x02,0x12,idnumber};
    NSData *data = [NSData dataWithBytes:transDat length:3];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)setAlarmWithAlarmID:(int)alarmID State:(int)state Hour:(int)hour Minute:(int)minute Repeat:(int)repeat
{
    Byte transDat[] = {0x03,0x02,alarmID,state,hour,minute,repeat};
    NSData *data = [NSData dataWithBytes:transDat length:ArraySize(transDat)];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)setAlarmNameWithAlarmID:(int)alarmID Name:(NSString *)name
{
    Byte transDat[] = {0x03,0x40,alarmID};
    NSData *lData = [NSData dataWithBytes:transDat length:3];
    NSMutableData *mutData = [[NSMutableData alloc] initWithData:lData];
    NSData *nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
    [mutData appendData:nameData];
    [self blueToothWhriteTransData:mutData isNeedResponse:YES];
}

- (void)getSystemNotify
{
    Byte transDat[] ={0x02,0x11};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)setNotifyWithNotifyModel:(NotifyModel *)notifyModel;
{

    int item0 = 0;
    item0 = item0 | (notifyModel.SMSState << 1);
    item0 = item0 | (notifyModel.CallState << 2);
    item0 = item0 | (notifyModel.EmailState << 3);
    item0 = item0 | (notifyModel.WechartState << 4);
    item0 = item0 | (notifyModel.QQState << 5);
    item0 = item0 | (notifyModel.FacebookState << 6);
    item0 = item0 | (notifyModel.TwitterState << 7);
    
    int item1 = 0;
    item1 = item1 | notifyModel.WhatsAppState;
    item1 = item1 | (notifyModel.MessengerState << 1);
    item1 = item1 | (notifyModel.InstagramState << 2);
    item1 = item1 | (notifyModel.LinkedinState << 4);

    Byte transDat[] = {0x03,0x30,notifyModel.notifyState,item0,item1,notifyModel.callDelay,};
    NSData *data = [NSData dataWithBytes:transDat length:ArraySize(transDat)];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)getSedentaryData
{
    Byte transDat[] = {0x02,0x15};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)setSedentaryWithSedentaryWithSedentaryModel:(SedentaryModel *)model;
{
    Byte transDat[] = {0x03,0x20,model.beginHour,model.beginMin,model.endHour,model.endMin,model.timeInteval & 0xff,(model.timeInteval >> 8) & 0xff,model.repeats,};
    NSData *data = [NSData dataWithBytes:transDat length:ArraySize(transDat)];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)findBracelet
{
    Byte transDat[] = {0x06,0x04};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)changeTakePhoteStateWithState:(BOOL)state
{
    Byte transDat[] = {0x07,0x01,8 - state};
    NSData *data = [NSData dataWithBytes:transDat
                                  length:3];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)getLiftHandState
{
    Byte transDat[] = {0x02,0x17};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)setLiftHandStateWithState:(int)state
{
    Byte transDat[] = {0x03,0x28,state};
    NSData *data = [NSData dataWithBytes:transDat length:3];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)getHeartRateState
{
    Byte transDat[] = {0x02,0x16};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)getHeartRateTime
{
    Byte transDat[] = {0x02,0x26};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:NO];
}

- (void)setHeartRateStateWithState:(int)state
{
    Byte transDat[] = {0x03,0x25,state};
    NSData *data = [NSData dataWithBytes:transDat length:3];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)getDisturbInformation
{
    Byte transDat[] = {0x02,0x18};
    NSData *data = [NSData dataWithBytes:transDat length:2];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)setDisturbInformationWith:(DisturbModel *)model
{
    Byte transDat[] = {0x03,0x29,model.State,model.beginHour,model.beginMin,model.endHour,model.endMin};
    NSData *data = [[NSData alloc] initWithBytes:transDat length:ArraySize(transDat)];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)sendUserInformationWithHeight:(int)height weight:(int)weight gender:(int)gender
{
    Byte transDat[] = {0x03,0x10,height,weight,gender};
    NSData *data = [[NSData alloc] initWithBytes:transDat length:ArraySize(transDat)];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)sendUserBph:(int)bph bpl:(int)bpl glu:(int)glu spo1:(int)spo1 spo2:(int)spo2
{
    Byte transDat[] = {0x03,0x31,bph,bpl,glu,spo1,spo2};
    NSData *data = [[NSData alloc] initWithBytes:transDat length:ArraySize(transDat)];
    [self blueToothWhriteTransData:data isNeedResponse:NO];
}

- (void)setBindUnitWith:(int)unit andTimeType:(int)type isEnglish:(BOOL)isEnglish;
{
    Byte transDat[] = {0x03,0x11,unit,type,isEnglish};
    NSData *data = [NSData dataWithBytes:transDat length:5];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)setHeartRateTimeIntervel:(int)minites
{
    Byte transDat[] = {0x03,0x26,minites};
    NSData *data = [NSData dataWithBytes:transDat length:3];
    [self blueToothWhriteTransData:data isNeedResponse:YES];
}

- (void)blueToothWhriteTransData:(NSData *)lData isNeedResponse:(BOOL)response
{
    NSMutableData *mutData = [[NSMutableData alloc] initWithData:lData];
    
    if (rdCharactic1) {
        if (lData && lData.length != 0)
        {
            lData = [self autoData20FromData:mutData];
//            adaLog(@"self.dataArray = %@",self.dataArray);
            if (response)
            {
                [self.dataArray addObject:lData];
            }
            else if (self.dataArray.count != 0)
            {
                [self.dataArray insertObject:lData atIndex:0];
            }
            else
            {
                adaLog(@"shotSendData  - -- %@",lData);
                [cbPeripheral writeValue:lData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithResponse];
                return;
            }
        }
        if (self.dataArray && self.dataArray.count!=0 && !_sendingData)
        {
            NSData *data = self.dataArray[0];
            if (data)
            {
                adaLog(@"longSendData = %@",data);
                [cbPeripheral writeValue:data forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithResponse];
                if (response)
                {
                    self.sendingData = data;
                    [self performSelector:@selector(resendSendingData:) withObject:data afterDelay:4];
                }
                [self.dataArray removeObjectAtIndex:0];
            }
        }
    }
}

- (NSData *)autoData20FromData:(NSMutableData *)data
{
    int length = (int)data.length;
    Byte *values = (Byte *)malloc(20 - length);
    for (int i = 0; i < 20 - length ; i++) {
        
        values[i] = 0x00;
    }
    if (length > 20) {
        //清空
        //       [data resetBytesInRange:NSMakeRange(0, data.length)];
    }else
    {
        [data appendBytes:values length:(20 - length)];
    }
    free(values);
    
    return data;
    
}

- (void)resendSendingData:(NSData*)data
{
    if (_resendCount >= 2)
    {
        _resendCount = 0;
        self.sendingData = nil;
        [self blueToothWhriteTransData:nil isNeedResponse:YES];
    }
    if ([data isEqualToData:_sendingData])
    {
//        [cbPeripheral setNotifyValue:YES forCharacteristic:notifyCharactic];
        if (rdCharactic1)
        {
            adaLog(@"resendData ===== %@",data);
            [cbPeripheral writeValue:data forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithResponse];
            _resendCount ++;
            [self performSelector:@selector(resendSendingData:) withObject:data afterDelay:4];
        }
    }
}

#pragma mark -- 定时器方法
- (void)timeFired:(NSTimer *)timer {
    if (cbCenterManger.state == CBCentralManagerStatePoweredOff)  return;
    
    if (_isOTAMode)
    {
        [cbCenterManger scanForPeripheralsWithServices:nil
                                               options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        return;
    }
    if (_connectUUID && ![_connectUUID isEqualToString:@""]  && !isConnecting) {
        [self ConnectWithUUID:_connectUUID];
    }
    ++connectTime;
    if(connectTime > 20)
    {
        if (_delegate&&[_delegate respondsToSelector:@selector(callbackConnectTimeAlert:)])
        {
            [_delegate callbackConnectTimeAlert:_connectTimeAlert];
        }
    }
    //adaLog(@"定时连接");
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
