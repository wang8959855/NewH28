//
//  HistoryDataModel.m
//  Bracelet
//
//  Created by xieyingze on 17/1/13.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "HistoryDataModel.h"
#import "sportModel.h"

@implementation HistoryDataModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.OneDayStepDataArray = [NSMutableArray array];
        self.OneDaySleepDataArray = [NSMutableArray array];
        self.OneDayHeartDataArray = [NSMutableArray array];
        self.OneDayLBPDataArray = [NSMutableArray array];
        self.OneDayHBPDataArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)getWeekStepDataWithTimeSeconds:(int)timeSeconds complition:(getMonthDataCompletion )completion
{
    int beginSeconds = [[TimeCallManager getInstance] getWeekTimeFistDay];
    NSString *sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds >= %d ",kHCH.userInfoModel.name,beginSeconds];
    NSArray *weekDataArray = [WHC_ModelSqlite query:[userDataModel class] where:sql];
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i ++)
    {
        [mutArray addObject:[NSString stringWithFormat:@"%d",0]];
    }
    if (weekDataArray && weekDataArray.count != 0)
    {
        for (int i = 0 ; i < weekDataArray.count; i ++)
        {
            userDataModel *model = weekDataArray[i];
            if (model)
            {
                [mutArray replaceObjectAtIndex:(model.timeSeconds - beginSeconds)/KONEDAYSECONDS withObject:[NSString stringWithFormat:@"%d",model.totalSteps]];
            }
        }
    }
    if (completion)
    {
        completion(mutArray);
    }
}

- (void)getMonthDataWithTimeSeconds:(int)timeSeconds completion:(getMonthDataCompletion)completion
{
    _monthBlock = completion;
    int endSeconds = [[TimeCallManager getInstance] getMonthBeginSecondsWithTimeSeconds:timeSeconds + 32 * KONEDAYSECONDS] - 1;
    NSString *dateString = [[TimeCallManager getInstance] getYYYYMMWithTimeSeconds:timeSeconds];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    int dayNumber = [self howManyDaysInThisYear:[dateArray[0] intValue] withMonth:[dateArray[1] intValue]];
    
    NSString *sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds BETWEEN %d AND %d ",kHCH.userInfoModel.name,timeSeconds,endSeconds];
    NSArray *userDataArray = [WHC_ModelSqlite query:[userDataModel class] where:sql];
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dayNumber; i ++)
    {
        [mutArray addObject:[NSString stringWithFormat:@"%d",0]];
    }
    if(userDataArray && userDataArray.count != 0)
    {
        for ( int i = 0; i < userDataArray.count; i ++)
        {
            userDataModel *dataModel = userDataArray[i];
            if (dataModel)
            {
                int day = [[TimeCallManager getInstance] getDayWithTimeSeconds:dataModel.timeSeconds];
                [mutArray replaceObjectAtIndex:day - 1 withObject:[NSString stringWithFormat:@"%d",dataModel.totalSteps]];
            }
        }
        if (_monthBlock)
        {
            _monthBlock(mutArray);
        }
    }
}

- (void)getyearSleepWithTimeSeconds:(int)timeSeconds completion:(getMonthDataCompletion)completion
{
    int beginSeconds = [[TimeCallManager getInstance] getYeahBeginSecondsWithTimeSeconds:kHCH.todayTimeSeconds];
    NSString *sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds > %d",kHCH.userInfoModel.name,beginSeconds];
    NSArray *sleepModelArray = [WHC_ModelSqlite query:[oneDaySleepModel class] where:sql];
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i ++)
    {
        [mutArray addObject:[[oneDaySleepModel alloc] init]];
    }
  
    if(sleepModelArray && sleepModelArray.count != 0)
    {
        for ( int i = 0; i < sleepModelArray.count; i ++)
        {
            oneDaySleepModel *sleepModel = sleepModelArray[i];
            if (sleepModel)
            {
                int month = [[TimeCallManager getInstance] getMonthNumberWithTimeSeconds:sleepModel.timeSeconds];
                oneDaySleepModel *model = mutArray[month - 1];
                model.totalSleepTime += sleepModel.totalSleepTime;
                model.deepSleepTime += sleepModel.deepSleepTime;
                model.lightSleepTime += sleepModel.lightSleepTime;
                model.awakeSleepTime += sleepModel.awakeSleepTime;
            }
        }
        if (completion)
        {
            completion(mutArray);
        }
    }
}

- (void)getyeahDataWithTimeSeconds:(int)timeSeconds completion:(getMonthDataCompletion)completion
{

    int beginSeconds = [[TimeCallManager getInstance] getYeahBeginSecondsWithTimeSeconds:kHCH.todayTimeSeconds];
    NSString *sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds > %d",kHCH.userInfoModel.name,beginSeconds];
    NSArray *userDataArray = [WHC_ModelSqlite query:[userDataModel class] where:sql];
   
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i ++)
    {
        [mutArray addObject:@"0"];
    }
    if(userDataArray && userDataArray.count != 0)
    {
        for ( int i = 0; i < userDataArray.count; i ++)
        {
            userDataModel *dataModel = userDataArray[i];
            if (dataModel)
            {
                int month = [[TimeCallManager getInstance] getMonthNumberWithTimeSeconds:dataModel.timeSeconds];
                int value = [mutArray[month - 1] intValue];
                value += dataModel.totalSteps;
                [mutArray replaceObjectAtIndex:month - 1 withObject:[NSString stringWithFormat:@"%d",value]];
            }
        }
        if (completion)
        {
            completion(mutArray);
        }
    }
}

- (void)getMonthSleepWithTimeSeconds:(int)timeSeconds completion:(getMonthDataCompletion)completion
{
    _monthSleepBlock = completion;
    int beginTimeSeconds = [[TimeCallManager getInstance] getMonthBeginSecondsWithTimeSeconds:timeSeconds];
    int endSeconds = [[TimeCallManager getInstance] getMonthBeginSecondsWithTimeSeconds:beginTimeSeconds + 32 * KONEDAYSECONDS] - 1;
    NSString *dateString = [[TimeCallManager getInstance] getYYYYMMWithTimeSeconds:timeSeconds];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    int dayNumber = [self howManyDaysInThisYear:[dateArray[0] intValue] withMonth:[dateArray[1] intValue]];
    NSString *sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds BETWEEN %d AND %d ",kHCH.userInfoModel.name,timeSeconds,endSeconds];
    NSArray *sleepModelArray = [WHC_ModelSqlite query:[oneDaySleepModel class] where:sql];
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dayNumber; i ++)
    {
        [mutArray addObject:[[oneDaySleepModel alloc] init]];
    }
    
    if(sleepModelArray && sleepModelArray.count != 0)
    {
        for ( int i = 0; i < sleepModelArray.count; i ++)
        {
            oneDaySleepModel *sleepModel = sleepModelArray[i];
            if (sleepModel)
            {
                int day = [[TimeCallManager getInstance] getDayWithTimeSeconds:sleepModel.timeSeconds];
                [mutArray replaceObjectAtIndex:day - 1 withObject:sleepModel];
            }
        }
        if (_monthSleepBlock)
        {
            _monthSleepBlock(mutArray);
        }
    }
}

- (void)getOneDaySleepWithTimeSeconds:(int)timeSedonds Completion:(oneDaySleepCompletion)completion {
    _daySleepBlock = completion;
    NSString *sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds = %d",kHCH.userInfoModel.name,timeSedonds];
    NSArray *sleepModelArray = [WHC_ModelSqlite query:[oneDaySleepModel class] where:sql];
    if (sleepModelArray.count != 0)
    {
        oneDaySleepModel *sleepModel = sleepModelArray[0];
        if (_daySleepBlock)
        {
            _daySleepBlock(sleepModel);
        }
    }else
    {
        [self saveDaySleepArrayWithTimeSeconds:timeSedonds completion:^(oneDaySleepModel *model) {
            if (_daySleepBlock && model) {
                _daySleepBlock(model);
            }
        }];
    }
}

- (void)writeDateYearWithTimeSeconds:(int)timeSeconds  completion:(WriteCompletiondata)completion {
    _block = completion;

    NSString * sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds = %d",kHCH.userInfoModel.name,timeSeconds];
    NSArray *userDataArray = [WHC_ModelSqlite query:[userDataModel class] where:sql];
    if (userDataArray.count != 0)
    {
        userDataModel *dataModel = userDataArray[0];
        if (_block) {
            _block(dataModel);
        }
    }else
    {
        if (_block)
        {
            _block(nil);
        }
    }
}


- (void)saveDaySleepArrayWithTimeSeconds:(int)timeSeconds completion:(oneDaySleepCompletion)completion;
{
    oneDaySleepModel *sleepModel = [[oneDaySleepModel alloc] init];
    NSMutableArray *sleepArray = [[NSMutableArray alloc] init];
    
    NSString * sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds  BETWEEN %d AND %d",kHCH.userInfoModel.name,timeSeconds - KONEDAYSECONDS,timeSeconds + 1];
    
    NSString *orderSql = @"by timeSeconds desc";
    NSArray *userDataArray = [WHC_ModelSqlite query:[userDataModel class] where:sql order:orderSql];
    BOOL isBegin = NO;
    BOOL isEnd = NO;
    int deepSleep = 0;
    int lightSleep = 0;
    int awakeSleep = 0;
    for (int i = 0 ; i < userDataArray.count; i ++)
    {
        userDataModel *dataModel = userDataArray[i];
        sportModel *sportM = [NSKeyedUnarchiver unarchiveObjectWithData:dataModel.userData];
        
        int a = 0;
        int forcount;
        
        if (dataModel.timeSeconds < timeSeconds)
        {
            a = 115;
            forcount = sportM.statuArray.count;
        }else{
            forcount = sportM.statuArray.count;
        }
        for (int j = forcount - 1 ; j >= a; j --)
        {
            NSString *stateStrig = sportM.statuArray[j];
            
            if ([stateStrig isEqualToString:@"21"] )
            {
                if (!isBegin)
                {
                    isBegin = YES;
                    isEnd = NO;
                    sleepModel.endTime = (j - 1)*10;
                }else
                {
                    isEnd = NO;
                }
            }
            if (isBegin)
            {
                [sleepArray insertObject:stateStrig atIndex:0];
                if ([stateStrig isEqualToString:@"18"])
                {
                    awakeSleep += 10;
                }
                if ([stateStrig isEqualToString:@"19"])
                {
                    lightSleep += 10;
                }
                if ([stateStrig isEqualToString:@"20"])
                {
                    deepSleep += 10;
                }
                
                if ([stateStrig isEqualToString:@"17"])
                {
                    isEnd = YES;
                    sleepModel.beginTime = j*10;
                }
            }
        }
    }
    
    for (int i = 0; i < sleepArray.count; i ++) {
        if (![sleepArray[0] isEqualToString:@"17"])
        {
            [sleepArray removeObjectAtIndex:0];
        }else
        {
            break;
        }
    }
    
    sleepModel.lightSleepTime = lightSleep;
    sleepModel.deepSleepTime = deepSleep;
    sleepModel.awakeSleepTime = awakeSleep;
    sleepModel.totalSleepTime = lightSleep + deepSleep + awakeSleep;
    sleepModel.timeSeconds = timeSeconds;
    sleepModel.sleepData = [NSKeyedArchiver archivedDataWithRootObject:sleepArray];
    sleepModel.name = kHCH.userInfoModel.name;
    if ((lightSleep * 3) < deepSleep) {
        sleepModel = nil;
    }
    if ( sleepModel.sleepData)
    {
        NSString * sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds  = %d ",kHCH.userInfoModel.name,timeSeconds];
        [WHC_ModelSqlite delete:[oneDaySleepModel class] where:sql];
        [WHC_ModelSqlite insert:sleepModel];
    }
    if (completion)
    {
        completion(sleepModel);
    }
}

- (void)getWeekSleepDataWithTimeSeconds:(int)timeSeconds complition:(getMonthDataCompletion )completion
{
    int beginSeconds = [[TimeCallManager getInstance] getWeekTimeFistDay];
    NSString *sql = [NSString stringWithFormat:@"name = '%@' AND timeSeconds >= %d ",kHCH.userInfoModel.name,beginSeconds];
    NSArray *sleepModelArray = [WHC_ModelSqlite query:[oneDaySleepModel class] where:sql];
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i ++)
    {
        [mutArray addObject:[[oneDaySleepModel alloc] init]];
    }
    if (sleepModelArray && sleepModelArray.count != 0)
    {
        for (int i = 0; i < sleepModelArray.count; i ++)
        {
            oneDaySleepModel *model = sleepModelArray[i];
            if (model)
            {
                [mutArray replaceObjectAtIndex:(model.timeSeconds - beginSeconds)/KONEDAYSECONDS withObject:model];
            }
        }
    }

    if (completion)
    {
        completion(mutArray);
    }
}

- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}
@end
