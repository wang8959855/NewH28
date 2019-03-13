
//
//  API.h
//  Bracelet
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#ifndef API_h
#define API_h

//生产环境
#define ROOT_URL @"http://sanguo.lantianfangzhou.com/h28/"
#define PATH_URL(url) [NSString stringWithFormat:@"%@%@",ROOT_URL,url]

//登录
#define LOGIN PATH_URL(@"log/login")
//发送登录短信验证码
#define LOGINSEND PATH_URL(@"log/logincode")
//注册
#define REGISTER PATH_URL(@"log/register")
//发送注册短信验证码
#define REGISTERSEND PATH_URL(@"log/registercode")
//上传个人信息
#define UPLOADUSERINFO PATH_URL(@"api/userinfo")
//获取用户信息
#define GETUSERINFO PATH_URL(@"api/getuserinfo")
//上传头像
#define UPLOADHEADER PATH_URL(@"api/headimg")
//修改昵称
#define ALERTNICKNAME PATH_URL(@"api/nickname")
//换绑手机号发送验证码
#define ALERTTELSEND PATH_URL(@"api/changetelcode")
//换绑手机号
#define ALERTTEL PATH_URL(@"api/changetel")
//获取好友列表
#define GETFRIENDLIST PATH_URL(@"api/friendlist")
//添加好友
#define ADDFRIEND PATH_URL(@"api/addfriend")
//删除好友
#define DELETEFRIEND PATH_URL(@"api/dltfriend")
//好友关注列表
#define GETATTENTIONLIST PATH_URL(@"api/whocarelist")
//设置关注列表
#define SETATTENTION PATH_URL(@"api/allowcare")
//获取监测服务按钮状态接口
#define GETSERVER PATH_URL(@"api/getserver")
//定制服务状态接口
#define SETSERVER PATH_URL(@"api/setserver")
//用户点击SOS按钮接口
#define CLICKSOS PATH_URL(@"api/sos")
//心率上传
#define HEARTRATEUPDATE PATH_URL(@"api/heartrate")
//运动数据上传
#define SPORTUPDATE PATH_URL(@"api/steps")
//睡眠数据上传
#define SLEEPUPDATE PATH_URL(@"api/sleep")
//获取报警次数接口
#define GETWARNING PATH_URL(@"api/warnnum")
//获取预警功能权限状态接口
#define GETYJSTATE PATH_URL(@"monitor")
//定时上传定位
#define UPLOADLOCATION PATH_URL(@"api/address")
#define CUSTOMWARING PATH_URL(@"api/warnbtn")

#endif /* API_h */
