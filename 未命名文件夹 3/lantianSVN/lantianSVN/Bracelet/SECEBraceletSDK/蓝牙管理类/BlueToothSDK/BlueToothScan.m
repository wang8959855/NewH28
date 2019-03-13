//
//  BlueToothScan.m
//  健康手环
//
//  Created by szx000 on 14-11-8.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#import "BlueToothScan.h"
#import "PerModel.h"


@interface BlueToothScan()<CBCentralManagerDelegate,CBPeripheralDelegate> {
    CBCentralManager *cbCenterManger;
    CBPeripheral *cbPeripheral;
    
    NSMutableArray *uuidArray ;
}

@end

@implementation BlueToothScan

- (void)dealloc{
    [cbCenterManger stopScan];
    cbPeripheral.delegate = nil ;
    cbCenterManger.delegate = nil ;
    cbCenterManger = nil;
    uuidArray = nil;
    if( cbPeripheral ){
        [cbCenterManger cancelPeripheralConnection:cbPeripheral];
    }
}

-(void)updateLog:(NSString *)s
{
}

- (void)startScan{
    cbCenterManger = [[CBCentralManager alloc]initWithDelegate:self queue:nil ];
    if (uuidArray) {
        [uuidArray removeAllObjects];
    }else {
        uuidArray = [[NSMutableArray alloc]init];
    }
//    NSArray *array = [cbCenterManger retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFF0"]]];
    NSArray *array = [cbCenterManger retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFF0"],[CBUUID UUIDWithString:@"0AF0"]]];
    
    for (NSInteger index = 0; index < array.count; index++) {
        BOOL addFlag = [self addDevList:array[index] RSSI:@1 MACName:nil Mac:nil];
        if (addFlag) {
            if ([_delegate respondsToSelector:@selector(blueToothScanDiscoverPeripheral:)]) {
                [_delegate blueToothScanDiscoverPeripheral:uuidArray];
            }
        }
    }
//    [cbCenterManger scanForPeripheralsWithServices:nil options:nil];
}

- (void)stopScan {
    if (cbCenterManger) {
        [cbCenterManger stopScan];
        cbCenterManger = nil;
        [uuidArray removeAllObjects];
    }
}

#pragma mark
#pragma mark centerBlueManagere Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            [self updateLog:@"CoreBluetooth BLE hardware is Powered off"];
            break;
        case CBCentralManagerStatePoweredOn:
            [self updateLog:@"CoreBluetooth BLE hardware is Powered on and ready"];
            [cbCenterManger scanForPeripheralsWithServices:nil
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            break;
        case CBCentralManagerStateResetting:
            
            [self updateLog:@"CoreBluetooth BLE hardware is resetting"];
            break;
        case CBCentralManagerStateUnauthorized:
            
            [self updateLog:@"CoreBluetooth BLE state is unauthorized"];
            break;
        case CBCentralManagerStateUnknown:
            
            [self updateLog:@"CoreBluetooth BLE state is unknown"];
            break;
        case CBCentralManagerStateUnsupported:
            
            [self updateLog:@"CoreBluetooth BLE hardware is unsupported on this platform"];
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    cbPeripheral = peripheral;
    
    NSData *macData = advertisementData[@"kCBAdvDataManufacturerData"];
    NSString *macString;
    NSString *macNameString;
    if (macData)
    {
        macString = [NSString stringWithFormat:@"%@",macData];
        macString = [macString stringByReplacingOccurrencesOfString:@" " withString:@""];
        macString = [macString substringWithRange:NSMakeRange(1,macString.length - 2)];
        
        NSData *data = [macData subdataWithRange:NSMakeRange(macData.length - 2, 2)];
        macNameString = [[NSString stringWithFormat:@"%@",data] substringWithRange:NSMakeRange(1, 4)];
        macNameString = [macNameString uppercaseString];
    }
    BOOL addFlag = FALSE;
    addFlag = [self addDevList:peripheral RSSI:RSSI MACName:macNameString Mac:macString];
    if (addFlag) {
        if ([_delegate respondsToSelector:@selector(blueToothScanDiscoverPeripheral:)]) {
            [_delegate blueToothScanDiscoverPeripheral:uuidArray];
        }
    }
}

- (BOOL)addDevList:(CBPeripheral *)peripheral RSSI:(NSNumber*)RSSI MACName:(NSString *)macName Mac:(NSString *)mac{
    if ([RSSI intValue] == 127)
    {
        return NO;
    }
    int count = (int)[uuidArray count];
    BOOL isUpdate = true;
    
    for (int index = 0; index < count; index++) {
        PerModel *model = [uuidArray objectAtIndex:index];
        CBPeripheral *peripheralInArray = model.per;
        NSString *llString1;
        NSString *llString2;
        #if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        llString1 = [NSString stringWithFormat:@"%@",peripheral.UUID];
        llString2 = [NSString stringWithFormat:@"%@",peripheralInArray.UUID];
        #else
        llString1 = peripheral.identifier.UUIDString;
        llString2 = peripheralInArray.identifier.UUIDString;
        #endif
        if ([llString1 isEqualToString:llString2]) {
            isUpdate = false;
            break;
        }
    }
    
    if (isUpdate) {
        PerModel *model = [[PerModel alloc] init];
        model.per = peripheral;
        model.RSSI = [RSSI intValue];
        if (macName && macName.length != 0 && ![macName isKindOfClass:[NSNull class]])
        {
            model.perName = [NSString stringWithFormat:@"%@.%@",peripheral.name,macName];
            model.mac = mac;
        }else
        {
            model.perName = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@macName",peripheral.identifier.UUIDString]];
            model.mac = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@mac",peripheral.identifier.UUIDString]];
        }

        if (model.perName && model.perName.length != 0 && ![model.perName isKindOfClass:[NSNull class]])
        {
            for (int i = 0 ; i < uuidArray.count; i ++)
            {
                PerModel *arryModel = uuidArray[i];
                if ([RSSI intValue] > arryModel.RSSI)
                {
                    [uuidArray insertObject:model atIndex:i];
                    return isUpdate;
                }
            }
            [uuidArray addObject:model];
        }else
            return NO;

        
    }
    return isUpdate;
}

- (void)clearDeviceList {
    if (uuidArray) {
        [uuidArray removeAllObjects];
        if ([_delegate respondsToSelector:@selector(blueToothScanDiscoverPeripheral:)]) {
            [_delegate blueToothScanDiscoverPeripheral:uuidArray];
        }
    }
}

@end
