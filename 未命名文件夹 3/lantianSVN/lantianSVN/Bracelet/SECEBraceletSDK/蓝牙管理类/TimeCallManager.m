//
//  TimeCallManager.m
//  HuiChengHe
//
//  Created by zhangtan on 14-12-11.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#import "TimeCallManager.h"

static TimeCallManager * instance=nil;

@implementation TimeCallManager

+ (TimeCallManager *)getInstance{
    if( instance == nil ){
        //        static dispatch_once_t onceToken;
        @synchronized(self) {
            instance =  [[TimeCallManager alloc] init];
        }
    }
    
    return instance;
}

+ (void)clearInstance{
    instance = nil ;
}

- (NSString *)changeCurDateToItailYYYYMMDDString{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    return [formates stringFromDate:[NSDate date]];
}

- (NSString *)changeDateToItailYYYYMMDDStringWithAssignDate:(NSDate *)assignDate{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    return [formates stringFromDate:assignDate];
}

- (NSDate *)changeItailYYYYMMDDStringToDateWithString:(NSString *)itailString{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    return [formates dateFromString:itailString];
}

- (NSString *)getForwordYYYYMMDDDateStringWithAssignString:(NSString *)assignString{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSDate *assignDate = [formates dateFromString:assignString];
    
    NSTimeInterval aTimeInterval = [assignDate timeIntervalSinceReferenceDate];
    aTimeInterval -= 24*60*60;
    NSDate *cureDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return [formates stringFromDate:cureDate];
}

- (NSString *)getBackYYYYMMDDDateStringWithAssignString:(NSString *)assignString{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSDate *assignDate = [formates dateFromString:assignString];
    
    NSTimeInterval aTimeInterval = [assignDate timeIntervalSinceReferenceDate];
    aTimeInterval += 24*60*60;
    NSDate *cureDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return [formates stringFromDate:cureDate];
}

- (NSTimeInterval)getYYYYMMDDSecondsSince1970With:(NSTimeInterval)seconds {
    NSDate *cDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [formates stringFromDate:cDate];
    
    NSDate *resultDate = [formates dateFromString:dateStr];
    return [resultDate timeIntervalSince1970];
}

- (NSTimeInterval)getHHmmSecondsSinceCurDayWith:(NSTimeInterval)seconds {
    NSDate *cDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [formates stringFromDate:cDate];
    
    NSDate *resultDate = [formates dateFromString:dateStr];
    
    return [resultDate timeIntervalSinceDate:cDate];
}

- (NSTimeInterval)getYYYYMMDDSecondsWith:(NSData *)data {
    if([data length] != 3)  return 0;
    
    Byte *transdata = (Byte *)[data bytes];
    NSString *timeStr = [NSString stringWithFormat:@"20%02d/%02d/%02d", transdata[2],transdata[1],transdata[0]];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSDate *resultDate = [formates dateFromString:timeStr];
    return [resultDate timeIntervalSince1970];
}

- (NSTimeInterval)getYYYYMMDDHHmmSecondsWith:(NSString *)datastr {
    
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy-MM-dd HH:mm"]; //yyyy-MM-dd HH:mm:ss
    NSDate *resultDate = [formates dateFromString:datastr];
    return [resultDate timeIntervalSince1970];
}

- (NSString *)getMinutueWithSecond:(NSTimeInterval)seconds {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}

- (NSString *)getYearWithSecond:(NSTimeInterval)seconds {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}

- (NSString *)getHourWithSecond:(NSTimeInterval)seconds {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"HH"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}

//获取一个时间和另一个时间点间隔了几个5分钟
- (int)getIntervalFiveMinWith:(int)oritime andEndTime:(int)endTime {
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    int index = 0;
    
    if (i%300 >= 200) {
        index = i/300 +1;
    }else {
        index = i/300 + 1;
    }
    
    return index;
}
//获取一个时间和另一个时间点间隔了几个1分钟
- (int)getIntervalOneMinWith:(int)oritime andEndTime:(int)endTime {
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    int index = 0;
    
    if (i%60 >= 50) {
        index = i/60 +1;
    }else {
        index = i/60;
    }
    
    return index;
}

//获取一个时间和另一个时间点间隔了几个5秒钟
- (int)getIntervalFiveSecondWith:(int)oritime andEndTime:(int)endTime {
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    int index = 0;
    
    index = i/5;
    return index;
}

- (int)getIntervalSecondWith:(int)oritime andEndTime:(int)endTime {
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    return i;
}

//根据秒数获取是当年的第几周
- (int)getWeekIndexInYearWith:(int)senconds {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:senconds];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSWeekOfYearCalendarUnit) fromDate:date];
    int weekIndex = [comps weekOfYear];
    
    return weekIndex;
}

//根据yyyy/MM/dd字符串获得秒数
- (NSTimeInterval)getSecondsWithTimeString:(NSString *)timeStr andFormat:(NSString *) format {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:format];
    NSDate *resultDate = [formates dateFromString:timeStr];
    return [resultDate timeIntervalSince1970];
}

//根据秒数和格式获取时间字符串
- (NSString *)getTimeStringWithSeconds:(int)seconds andFormat:(NSString *)format {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}

//获得当前天的秒数
- (NSTimeInterval)getSecondsOfCurDay {
    NSDate *eDate = [NSDate date];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSString *string = [formates stringFromDate:eDate];
    return  [self getSecondsWithTimeString:string andFormat:@"yyyy/MM/dd"];
}

//获得当前时间的秒数
- (NSTimeInterval)getSecondsOfCurTime {
    NSDate *eDate = [NSDate date];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *string = [formates stringFromDate:eDate];
    return  [self getSecondsWithTimeString:string andFormat:@"yyyy/MM/dd hh:mm:ss"];
}

- (NSTimeInterval)getSecondsOfCurMonth
{
    NSDate *eDate = [NSDate date];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM"];
    NSString *string = [formates stringFromDate:eDate];
    return  [self getSecondsWithTimeString:string andFormat:@"yyyy/MM"];
}

- (NSTimeInterval)getMonthBeginSecondsWithTimeSeconds:(int)timeSeconds
{
    NSDate *eDate = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM"];
    NSString *string = [formates stringFromDate:eDate];
    return  [self getSecondsWithTimeString:string andFormat:@"yyyy/MM"];
}

- (NSTimeInterval)getYeahBeginSecondsWithTimeSeconds:(int)timeSeconds
{
    NSDate *eDate = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy"];
    NSString *string = [formates stringFromDate:eDate];
    return  [self getSecondsWithTimeString:string andFormat:@"yyyy"];
}

//获取时间的秒数
- (NSTimeInterval)getSecondsWithDate:(NSDate *)date
{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSString *string = [formates stringFromDate:date];
    return  [self getSecondsWithTimeString:string andFormat:@"yyyy/MM/dd"];
}

- (NSString *)changeDateTommddeWithSeconds:(int)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM.dd  E"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@",dateString];
}

-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
    
}

- (NSString *)getYYYYMMWithTimeSeconds:(int)timeSeconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM"];
    return [formatter stringFromDate:date];
}

//根据秒数获得日期
- (int)getDayWithTimeSeconds:(int)timeSeconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *ddString = [formatter stringFromDate:date];
    return [ddString intValue];
}

- (int)getMonthNumberWithTimeSeconds:(int)timeSeconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *ddString = [formatter stringFromDate:date];
    return [ddString intValue];
}

- (NSString *)getFirstMonthMMM
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *MMMString = [formatter stringFromDate:date];
    return MMMString;
}

- (NSTimeInterval )getWeekTimeFistDay
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
    }
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    return [firstDayOfWeek timeIntervalSince1970];

}



- (NSString *)getWeekTime
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    NSLog(@"%d----%d",weekDay,day);
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit   fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"MMM dd"] ];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    NSLog(@"%@=======%@",firstDay,lastDay);
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",firstDay,lastDay];
    
    return dateStr;
}

- (NSString *)changeToYYYYMMDDStringWithTimeSeconds:(int)timeSeconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    return [formatter stringFromDate:date];
}

@end
