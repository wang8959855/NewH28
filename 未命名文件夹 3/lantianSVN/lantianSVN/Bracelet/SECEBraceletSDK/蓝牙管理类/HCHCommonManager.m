//
//  HCHCommonManager.m
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/2/21.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "HCHCommonManager.h"

static HCHCommonManager * instance=nil;


@implementation HCHCommonManager

+ (HCHCommonManager *)getInstance{
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [[HCHCommonManager alloc] init];
            [instance initData];
        }
    }
    return instance;
}

- (void)initData
{
    _todayTimeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    _curMonthTimeSeconds = [[TimeCallManager getInstance] getSecondsOfCurMonth];
}

- (UserInfoModel *)userInfoModel
{
    if (!_userInfoModel)
    {
        NSDictionary *dic = [PZSaveDefaluts objectForKey:@"userData"];
        if (dic)
        {
            _userInfoModel = [UserInfoModel mj_objectWithKeyValues:dic];
        }
        else{
            _userInfoModel = [[UserInfoModel alloc] init];
        }
    }
    return _userInfoModel;
}

- (NSString *)mac
{
    NSString *UUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"kBleBoundPeripheralIdentifierString"];
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@mac",UUID]];
    if (string && string.length > 0)
    {
        string = [string uppercaseString];
        NSMutableString * mutString;
        if (string.length > 6)
        {
            mutString = [[NSMutableString alloc] initWithString:[string substringWithRange:NSMakeRange(string.length - 12, 12)]];
        }else
        {
            mutString = [[NSMutableString alloc] initWithString:string];
        }

        for (int i = 1; i < 6 ; i ++)
        {
            [mutString insertString:@":" atIndex:12 - 2 * i];
        }
        return  mutString;
    }
    else return @"未获取到mac";
}



- (NSDictionary *)changeToParamWithDic:(NSDictionary *)dic
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return @{@"data":jsonString,@"userid":USERID,@"token":TOKEN,@"device":@""};
}

- (void)userInfoModelChanged
{
    NSDictionary *dic = _userInfoModel.mj_keyValues;
    [PZSaveDefaluts setObject:dic forKey:@"userData"];
}

#pragma mark -- 网络上传相关

- (NSString *)sleepUpTime
{
    _sleepUpTime = [PZSaveDefaluts objectForKey:@"sleepUpTime"];
    return _sleepUpTime;
}

- (void)setSleepUpTimeKey:(int)sleepUpTime
{
    NSString *timeString = [NSString stringWithFormat:@"%d",sleepUpTime];
    [PZSaveDefaluts setObject:timeString forKey:@"sleepUpTime"];
    _sleepUpTime = timeString;
}

//- (void)setSleepUpTime:(NSString *)sleepUpTime
//{
//    [PZSaveDefaluts setObject:sleepUpTime forKey:@"sleepUpTime"];
//    _sleepUpTime = sleepUpTime;
//}

- (NSString *)storeHeadImageWithImage:(UIImage *)locImage{
    NSString *file = [self getFileStoreFolder];
    file = [NSString stringWithFormat:@"%@/%@",file,@"file.png"];
    
    NSData *imageData = UIImagePNGRepresentation(locImage);
    [imageData writeToFile:file atomically:YES];
    
    return file ;
}

- (NSString *)getFileStoreFolder{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *paths = [[path objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@""]];
    if( ![fileManager isExecutableFileAtPath:paths] ){
        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return paths;
}

- (void)setUserBirthdateWith:(NSString *)birthdate {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && birthdate) {
        [_userInfoDictionAry setObject:birthdate forKey:@"Birthday"];
    }
}

- (id)userBirthdate {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Birthday"];
    } else {
        return  @"";
    }
}
- (void)setUserHeaderWith:(NSString *)header {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && header) {
        [_userInfoDictionAry setObject:header forKey:@"headimg"];
    }
}

- (id)UserHeader {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"headimg"];
    } else {
        return  @"";
    }
}

- (void)setUserHeightWith:(NSString *)height {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && height) {
        [_userInfoDictionAry setObject:height forKey:@"Height"];
    }
}

- (id)UserHeight {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Height"];
    } else {
        return  @"";
    }
}

- (void)setUserWeightWith:(NSString *)weight {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && weight) {
        [_userInfoDictionAry setObject:weight forKey:@"Weight"];
    }
}

- (id)UserWeight {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Weight"];
    } else {
        return  @"";
    }
}

- (void)setUserNickWith:(NSString *)nick {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && nick) {
        [_userInfoDictionAry setObject:nick forKey:@"NickName"];
    }
}

- (id)UserNick {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"NickName"];
    } else {
        return @"";
    }
}

- (void)setUserGenderWith:(NSString *)gender {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && gender) {
        [_userInfoDictionAry setObject:gender forKey:@"Sex"];
    }
}

- (id)UserGender {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Sex"];
    } else {
        return  @"";
    }
}

- (void)setUserAcountName:(NSString *)userName {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && userName) {
        [_userInfoDictionAry setObject:userName forKey:@"Name"];
    }
}

- (id)UserAcount {
    if (_userInfoDictionAry) {
        if ([_userInfoDictionAry objectForKey:@"Name"] == nil)
        {
            return NSLocalizedString(@"", nil);
        }
        return [_userInfoDictionAry objectForKey:@"Name"];
        
    } else {
        return  NSLocalizedString(@"", nil);
    }
}

- (void)setUserAddressWith:(NSString *)address{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && address) {
        [_userInfoDictionAry setObject:address forKey:@"Address"];
    }
}

- (id)UserAddress{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Address"];
    } else {
        return @"";
    }
}

- (void)setUserIsCHDWith:(NSString *)isCHD{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && isCHD) {
        [_userInfoDictionAry setObject:isCHD forKey:@"is_CHD"];
    }
}

- (id)UserIsCHD{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"is_CHD"];
    } else {
        return  @"";
    }
}

- (void)setUserIsHypertensionWith:(NSString *)isHypertension{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && isHypertension) {
        [_userInfoDictionAry setObject:isHypertension forKey:@"is_Hypertension"];
    }
}

- (id)UserIsHypertension{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"is_Hypertension"];
    } else {
        return  @"";
    }
}

- (void)setUserRafTel1With:(NSString *)rafTel1{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && rafTel1) {
        [_userInfoDictionAry setObject:rafTel1 forKey:@"FriendTel1"];
    }
}

- (id)UserRafTel1{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"FriendTel1"];
    } else {
        return @"";
    }
}

- (void)setUserRafTel2With:(NSString *)rafTel2{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && rafTel2) {
        [_userInfoDictionAry setObject:rafTel2 forKey:@"FriendTel2"];
    }
}

- (id)UserRafTel2{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"FriendTel2"];
    } else {
        return  @"";
    }
}

- (void)setUserRafTel3With:(NSString *)rafTel3{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && rafTel3) {
        [_userInfoDictionAry setObject:rafTel3 forKey:@"FriendTel3"];
    }
}

- (id)UserRafTel3{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"FriendTel3"];
    } else {
        return  @"";
    }
}

- (void)setUserDiastolicPWith:(NSString *)diastolicP{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && diastolicP) {
        [_userInfoDictionAry setObject:diastolicP forKey:@"diastolicP"];
    }
}

- (id)UserDiastolicP{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"diastolicP"];
    } else {
        return @"";
    }
}

- (void)setUserSystolicPWith:(NSString *)systolicP{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && systolicP) {
        [_userInfoDictionAry setObject:systolicP forKey:@"systolicP"];
    }
}

- (id)UserSystolicP{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"systolicP"];
    } else {
        return @"";
    }
}

- (void)setUserGluWith:(NSString *)Glu {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && Glu) {
        [_userInfoDictionAry setObject:Glu forKey:@"Glu"];
    }
}

- (id)UserGlu{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Glu"];
    } else {
        return @"";
    }
}

- (void)setUserIsGlu:(NSString *)isGlu{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && isGlu) {
        [_userInfoDictionAry setObject:isGlu forKey:@"is_Glu"];
    }
}

- (id)UserIsGlu{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"is_Glu"];
    } else {
        return @"";
    }
}

- (void)setUserVipTimeWith:(NSString *)VipTime{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && VipTime) {
        [_userInfoDictionAry setObject:VipTime forKey:@"VipTime"];
    }
}

- (id)UserVipTime{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"VipTime"];
    } else {
        return @"";
    }
}

- (void)setUserIDCardNoWith:(NSString *)IDCardNo{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && IDCardNo) {
        [_userInfoDictionAry setObject:IDCardNo forKey:@"IDCardNo"];
    }
}

- (id)UserIDCardNo{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"IDCardNo"];
    } else {
        return @"";
    }
}

- (void)setUserPointWith:(NSString *)Point{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && Point) {
        [_userInfoDictionAry setObject:Point forKey:@"Point"];
    }
}

- (id)UserPoint{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Point"];
    } else {
        return @"";
    }
}

- (void)setUserTelWith:(NSString *)Tel{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && Tel) {
        [_userInfoDictionAry setObject:Tel forKey:@"Tel"];
    }
}

- (id)UserTel{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Tel"];
    } else {
        return @"";
    }
}


@end
