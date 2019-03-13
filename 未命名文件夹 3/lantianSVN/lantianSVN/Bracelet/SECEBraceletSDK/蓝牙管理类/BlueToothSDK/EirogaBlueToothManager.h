//
//  EirogaBlueToothManager.h
//  Bracelet
//
//  Created by panzheng on 2017/3/23.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "historyDataHourModel.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>


@interface EirogaBlueToothManager : NSObject

@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController; //音乐播放器
@property (assign, nonatomic)MPMusicPlaybackState musicPlaybackState;
@property (strong, nonatomic) MPMediaQuery *query;

@property (nonatomic, assign) int RSSI;

@property (nonatomic, strong) CBPeripheral *peripheral;
#pragma mark -- Block

typedef void(^eirogaBlueToothState)(BOOL isconnected,CBPeripheral *peripheral);

@property (nonatomic, copy) eirogaBlueToothState StateBlock;

#pragma mark -- 全局变量
@property (nonatomic, strong)PZBlueToothManager *manager;

@property (nonatomic, strong) NSString *connectedUUID;

@property (nonatomic, assign) BOOL isconnected;



+ (instancetype)sharedInstance;

- (void)BlueToothStateChangedWithBLock:(void (^)(BOOL isconnected,CBPeripheral *peripheral))StateBlock;

- (void)getHistoryDataWithTimeSeconds:(int)timeSeconds andHour:(int)hour;

@end
