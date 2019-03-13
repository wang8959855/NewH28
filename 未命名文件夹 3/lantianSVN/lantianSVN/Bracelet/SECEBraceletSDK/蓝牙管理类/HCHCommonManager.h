//
//  HCHCommonManager.h
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/2/21.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface HCHCommonManager : NSObject

@property (nonatomic, assign) int curPower;

@property (nonatomic, assign) int todayTimeSeconds;

@property (nonatomic, assign) int curMonthTimeSeconds;

@property (nonatomic, strong) UserInfoModel *userInfoModel;

@property (nonatomic, strong) NSString * mac;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *version;

@property (nonatomic, strong) NSString *sleepUpTime;


@property (nonatomic, assign) BOOL isLogin;


@property (nonatomic, retain) NSMutableDictionary *userInfoDictionAry;
- (void)setUserBirthdateWith:(NSString *)birthdate;
- (void)setUserHeaderWith:(NSString *)header;
- (void)setUserHeightWith:(NSString *)height;
- (void)setUserWeightWith:(NSString *)weight;
- (void)setUserNickWith:(NSString *)nick;
- (void)setUserGenderWith:(NSString *)gender;
- (void)setUserAcountName:(NSString *)userName;
- (void)setUserAddressWith:(NSString *)address;
- (void)setUserIsCHDWith:(NSString *)isCHD;
- (void)setUserIsHypertensionWith:(NSString *)isHypertension;
- (void)setUserRafTel1With:(NSString *)rafTel1;
- (void)setUserRafTel2With:(NSString *)rafTel2;
- (void)setUserRafTel3With:(NSString *)rafTel3;
/** 基准低压 */
- (void)setUserDiastolicPWith:(NSString *)diastolicP;
/** 基准高压 */
- (void)setUserSystolicPWith:(NSString *)systolicP;
- (void)setUserVipTimeWith:(NSString *)VipTime;
- (void)setUserIDCardNoWith:(NSString *)IDCardNo;
- (void)setUserPointWith:(NSString *)Point;
- (void)setUserTelWith:(NSString *)Tel;
- (void)setUserGluWith:(NSString *)Glu;
- (void)setUserIsGlu:(NSString *)isGlu;


- (id)userBirthdate;
- (id)UserHeader;
- (id)UserHeight;
- (id)UserWeight;
- (id)UserNick;
- (id)UserGender;
- (id)UserAcount;
- (id)UserAddress;
- (id)UserIsCHD;
- (id)UserIsHypertension;
- (id)UserRafTel1;
- (id)UserRafTel2;
- (id)UserRafTel3;
/** 基准低压 */
- (id)UserDiastolicP;
/** 基准高压 */
- (id)UserSystolicP;
- (id)UserVipTime;
- (id)UserIDCardNo;
/** 用户积分 */
- (id)UserPoint;
- (id)UserTel;
- (id)UserGlu;
- (id)UserIsGlu;


- (NSString *)storeHeadImageWithImage:(UIImage *)locImage;


+ (HCHCommonManager*)getInstance;

- (NSDictionary *)changeToParamWithDic:(NSDictionary *)dic;

- (void)userInfoModelChanged;

- (void)setSleepUpTimeKey:(int)sleepUpTime;

@end
