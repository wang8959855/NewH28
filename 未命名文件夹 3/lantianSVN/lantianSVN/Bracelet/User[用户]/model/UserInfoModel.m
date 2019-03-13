//
//  UserInfoModel.m
//  Bracelet
//
//  Created by panzheng on 2017/3/14.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (NSString *)name
{
    if (kHCH.mac)
    {
        return kHCH.mac;
    }else
    {
        return @"无mac";
    }
}

- (NSString *)height
{
    if (_height && _height.length != 0)
    {
        return _height;
    }else
    {
        return @"170";
    }
}

- (NSString *)weight
{
    if (_weight && _weight.length != 0)
    {
        return _weight;
    }else
    {
        return @"55";
    }
}

- (void)setGender:(NSString *)gender
{
    _gender = gender;
}

-(void)setBirthday:(NSString *)birthday
{
    _birthday = birthday;
    self.age = nil;
}

- (NSString *)age
{
    if (!_age)
    {
        int birhyear = [[self.birthday componentsSeparatedByString:@"-"][0] intValue];
        if (birhyear > 0)
        {
            NSDate *date = [NSDate date];
            NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
            [forMatter setDateFormat:@"yyyy"];
            int nowYear = [[forMatter stringFromDate:date] intValue];
            _age = [NSString stringWithFormat:@"%d",(nowYear - birhyear)];
        }else
        {
            _age = @"-1";
        }
    }
    return _age;
}

@end
