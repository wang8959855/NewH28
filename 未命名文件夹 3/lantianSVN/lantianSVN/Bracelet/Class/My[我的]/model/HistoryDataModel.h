//
//  HistoryDataModel.h
//  Bracelet
//
//  Created by xieyingze on 17/1/13.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userDataModel.h"
#import <UIKit/UIKit.h>
#import "oneDaySleepModel.h"
//typedef void (^WriteCompletiondata)(NSArray *OneDayStepDataArray,NSArray *OneDaySleepDataArray,NSArray *OneDayHeartDataArray,NSArray *OneDayLowBloodPressureDataArray,NSArray *OneDayHighBloodPressureDataArray);
typedef void (^WriteCompletiondata)(userDataModel *dataModel);
typedef void (^getMonthDataCompletion)(NSArray *array);
typedef void (^oneDaySleepCompletion)(oneDaySleepModel *model);

@interface HistoryDataModel : NSObject
@property (nonatomic, copy) WriteCompletiondata block;
@property (nonatomic, copy) getMonthDataCompletion monthBlock;
@property (nonatomic, copy) oneDaySleepCompletion daySleepBlock;
@property (nonatomic, copy) getMonthDataCompletion monthSleepBlock;


@property(nonatomic,strong)NSMutableArray *OneDayStepDataArray;
@property(nonatomic,strong)NSMutableArray *OneDaySleepDataArray;
@property(nonatomic,strong)NSMutableArray *OneDayHeartDataArray;
@property(nonatomic,strong)NSMutableArray *OneDayLBPDataArray;
@property(nonatomic,strong)NSMutableArray *OneDayHBPDataArray;

//获取一天历史数据model
- (void)writeDateYearWithTimeSeconds:(int)timeSeconds  completion:(WriteCompletiondata)completion;

//获取一月的历史数据步数数组
- (void)getMonthDataWithTimeSeconds:(int)timeSeconds completion:(getMonthDataCompletion)completion;

- (void)getyeahDataWithTimeSeconds:(int)timeSeconds completion:(getMonthDataCompletion)completion;

//统计睡眠存入数据库
- (void)saveDaySleepArrayWithTimeSeconds:(int)timeSeconds completion:(oneDaySleepCompletion)completion;

//获取一天睡眠Model
- (void)getOneDaySleepWithTimeSeconds:(int)timeSedonds Completion:(oneDaySleepCompletion)completion;

//获取一周睡眠
- (void)getWeekSleepDataWithTimeSeconds:(int)timeSeconds complition:(getMonthDataCompletion )completion;

- (void)getyearSleepWithTimeSeconds:(int)timeSeconds completion:(getMonthDataCompletion)completion;

//获取一月睡眠Model数组
- (void)getMonthSleepWithTimeSeconds:(int)timeSeconds completion:(getMonthDataCompletion)completion;

- (void)getWeekStepDataWithTimeSeconds:(int)timeSeconds complition:(getMonthDataCompletion )completion;

@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,assign)NSInteger count;
@end
