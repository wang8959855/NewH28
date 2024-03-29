//
//  AllTool.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/4.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

static NSString *const changeLoginNofication = @"changeLogin";
static NSString *const changeMainNofication = @"changeMain";
/** 个人信息更新成功 */
static NSString *const UserInformationUpDateNotification = @"userInfoUpdate";

#import <Foundation/Foundation.h>

@interface AllTool : NSObject

/**
 *
 */
/**
 *   求平均值
 */
+(NSString *)getMean:(NSArray *)array;
/**
 *   求最大值
 */
+(NSString *)getMax:(NSArray *)array;

/**
 *   求最大值
 */
+(NSString *)getSportIDMax:(NSArray *)array;

/**
 *   把心率带数组转化为分钟。用于以后的计算
 */
+(NSMutableArray *)seconedTominute:(NSArray *)array;
/**
 *   手表的过滤
 */
+(NSMutableArray *)checkWatch:(NSArray *)deviceArray;
/**
 *   手环的过滤
 */
+(NSMutableArray *)checkBracelet:(NSArray *)deviceArray;


/**
 * 核实手环版本是否支持在线运动
 */
+(BOOL)checkVersionWithHard:(int)hardV HardTwo:(int)hardTwo Soft:(int)softV Blue:(int)blueV;
/**
 *  十六进制字符串转换为十进制数
 *
 *  @param hexString 十六进制字符串
 *
 *  @return 十进制整数
 */
+(NSInteger)hexStringTranslateToDoInteger:(NSString *)hexString;

/**
 *  清理绑定设备的缓存
 */

+(void)clearDeviceBangding;
/**
 * 截取时间字符串的一部分
 */
+ (NSString *)timecutting:(NSString *)timeString;
/**
 *十六进制转二进制
 */
+(NSString *)getBinaryByhex:(NSString *)hex;
/**
 *二进制转十六进制
 */
+(NSString *)getHexByBinary:(NSString *)Binary;
/**
 *  天气内容判断
 */
+(NSString *)rangeWeather:(NSString *)weather;
/**
 
 不是中文 ，提前把天气转成中文
 
 **/
+(NSString *)AheadEnglishToChinese:(NSString *)english;

/**
 *把日期截取生成  时 日 月 年
 */
+(NSMutableArray*)weatherDateToArray:(NSString *)date;
/**
 *       天气范围   拆分字符串成数组
 *
 **/
+(NSMutableArray*)tempToArray:(NSString *)date;
/**
 *
 *取出其中的数字
 **/
+(NSString *)findNumFromStr:(NSString *)weather_fl;

/**
 *      判断其中的 风向
 *
 **/
+(NSString *)findWeather_fx:(NSString *)fx;


/**
 *      十进制转二进制
 *
 **/
+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal;
/**
 *      二进制转十进制
 *
 **/
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;

/**
 *      十六进制字符串转化为数组  。用于发给蓝牙
 *
 **/
+ (NSMutableArray *)hexToArray:(NSString *)hex;

/**
 *      十进制字符串转化为数组  。用于发给蓝牙
 *
 **/
+ (NSMutableArray *)numberToArray:(int)number;
/**
 *  开始上传数据
 */
+(void)startUpData;


/**
 *
 清除设备类型
 */
+(void)clearDeviceType;

/**
 *
 arrayToString    11，22，33，44,
 */
+(NSString *)arrayToString2:(NSArray*)array;
/**
 *
 arrayToString    11，22，33，44
 */
+(NSString *)arrayToString:(NSArray*)array;

+(NSString *)arrayToStringHeart:(NSArray*)array;
+(NSString *)arrayToStringSport:(NSArray*)array;

/**
 *
 macToString    mac地址转化为字符串
 */
+(NSString *)macToMacString:(NSString *)macAddressData;

/**
 *
 macToString    data  mac地址转化为字符串
 */
+(NSString *)macDataToString:(NSData *)macAddressData;

/**
 *
 macToString    data  mac地址转化为字符串
 */
+(BOOL)savePeripheral:(PerModel *)model;
/**
 *
 检查到设置中的外设。没有收到广播。就从数据库中取得macAddress  保存本地
 */
+(BOOL)setMacaddress:(NSString *)uuid;

/**
 *
 字典转json格式字符串：
 **/

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/*!
 
 * @brief 制造180分钟的0值。
 
 * @param
 
 * @return NSMutableArray
 
 */
+(NSMutableArray *)makeArrayEight;
/*!
 * @brief 制造144分钟的0值。
 0-清醒 1-浅睡 2-深睡
 * @return NSMutableArray
 */
+(NSMutableArray *)makeSleepArray;
// 判断字符串中是否有中文
+ (BOOL)isChinese:(NSString *)str;

/*
 校验mac地址的 正确性  -- 长度
 * @param mac地址
 
 * @return BOOL
 */
+(BOOL)checkMacAddressLength:(NSString *)macString;

/*
 校验mac地址的正确性
 * @param mac地址
 
 * @return BOOL
 */
+(BOOL)checkMacAddressCorrect:(NSString *)macString;
/*
 核实MacAddress是否需要修正
 * @param mac地址
 
 * @return BOOL
 */
+(BOOL)isNeedAmendMacAddress:(NSString *)macString;

/*
 保存macAddress之前的获取
 
 * @return macAddress
 */
+(NSString *)amendMacAddressGetAddress;
/*
 pm25   用于计算空气质量
 
 * @return pm25
 */
+(NSString *)pm25ToString:(NSInteger)number;

//经纬度分出
+(NSArray *)getLatLonDegree:(NSString *)LLString;
/*
 获取运动目标时间
 
 * @return target
 */
+(NSString *)getSportTargetTime:(NSString *)targetTime;
/**
 
 *  是直接使用
 
 */
+(BOOL)isDirectUse;
/**
 
 *  计算配速
 
 */
+(NSString*)pacewithTime:(double)time andRice:(double)rice;

/**
 
 *  过滤 255 和 0
 
 */
+(NSMutableArray*)checkArray:(NSArray *)array;

#pragma mark - 更换主页面
+ (void)setRootViewController:(UIViewController *)viewController animationType:(NSString *)animationType;
//显示提示框
+ (void)addActityIndicatorInView :(UIView *)view labelText : (NSString *)labelString detailLabel : (NSString *)detailString;
//移除view
+ (void)removeActityIndicatorFromView : (UIView *)view;
#pragma mark - 弹出HUD
+ (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times;


/**
 *      通过过滤，把有效的睡眠中的清醒转成浅睡。开始睡眠后 30分钟，就算开始。超过30分钟的清醒才是清醒，否则清醒转浅睡
 *
 **/
+ (NSMutableArray *)filterSleepToValid:(NSArray *)sleepArr;

/**
 *  切圆角
 *  @param originalView 需要切圆角的视图
 *  @param corners 枚举UIRectCorner
 *  @param size 圆角的尺寸CGSize
 *
 *  @return CAShapeLayer
 **/
+ (CAShapeLayer *)getCornerRoundWithSelfView:(UIView *)originalView byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)size;

/**
 * 基准高压和基准低压
 * arr[0]为高压
 * arr[1]为低压
 */
+ (NSArray *)calcSWithBirthday:(NSString *)birthday sex:(NSString *)sex;

//获取当前时
+ (int)currentHour;
//获取当前分
+ (int)currentMinute;

@end
