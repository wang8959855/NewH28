//
//  SystemAlarmModel.h
//  Bracelet
//
//  Created by panzheng on 2017/3/27.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyModel : NSObject

//注意:提醒需要手环与手机配对后才可实现
//APP提醒总开关
@property (assign, nonatomic) BOOL notifyState;

// 短信提醒开关
@property (assign, nonatomic) BOOL SMSState;

//来电提醒开关
@property (assign, nonatomic) BOOL CallState;

//邮件提醒开关
@property (assign, nonatomic) BOOL EmailState;

//微信消息提醒开关
@property (assign, nonatomic) BOOL WechartState;

//qq推送提醒开关
@property (assign, nonatomic) BOOL QQState;

//facebook messenger 提醒开关
@property (assign, nonatomic) BOOL FacebookState;

//twitter提醒开关
@property (assign, nonatomic) BOOL TwitterState;

// shatsAApp提醒开关
@property (assign, nonatomic) BOOL WhatsAppState;

//当前无效
@property (assign, nonatomic) BOOL MessengerState;

// Instagram提醒
@property (assign, nonatomic) BOOL InstagramState;

//Linkedin提醒
@property (assign, nonatomic) BOOL LinkedinState;

// 来电提醒的延时,即来电多少秒未接后开始提醒
@property (assign, nonatomic) int callDelay;

@end
