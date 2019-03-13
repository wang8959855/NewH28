//
//  ColorDefine.h
//  MasonryDemo
//
//  Created by 谢英泽 on 2016/11/10.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h

//自定义颜色
#define KCOLOR(R,G,B)           [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

//16进制颜色
#define kCOLOR_RGBValue(RGBValue)   [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 \
green:((float)((RGBValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((RGBValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define kmainBackgroundColor  KCOLOR(0, 160, 233)
#define kmainLightColor KCOLOR(0, 167, 247)
#define kmainDarkColor KCOLOR(0, 115, 170)
#define kmaintextGrayColor KCOLOR(140, 218, 255)

#define kmainDeepSleep KCOLOR(0, 115, 170)
#define kmainLightSleep KCOLOR(0, 167, 247)
#define kmainAwakeSleep KCOLOR(140, 218, 255)

//基本颜色
#define kCOLOR_red              [UIColor redColor]          // 1.0, 0.0, 0.0 RGB
#define kCOLOR_black            [UIColor blackColor]        // 0.0 white
#define kCOLOR_darkGray         [UIColor darkGrayColor]     // 0.333 white
#define kCOLOR_white            [UIColor whiteColor]        // 1.0 white
#define kCOLOR_gray             [UIColor grayColor]         // 0.5 white
#define kCOLOR_lightGray        [UIColor lightGrayColor]
#define kCOLOR_green            [UIColor greenColor]        // 0.0, 1.0, 0.0 RGB
#define kCOLOR_blue             [UIColor blueColor]         // 0.0, 0.0, 1.0 RGB
#define kCOLOR_cyan             [UIColor cyanColor]         // 0.0, 1.0, 1.0 RGB
#define kCOLOR_yellow           [UIColor yellowColor]       // 1.0, 1.0, 0.0 RGB
#define kCOLOR_magenta          [UIColor magentaColor]      // 1.0, 0.0, 1.0 RGB
#define kCOLOR_orange           [UIColor orangeColor]       // 1.0, 0.5, 0.0 RGB
#define kCOLOR_purple           [UIColor purpleColor]       // 0.5, 0.0, 0.5 RGB
#define kCOLOR_brown            [UIColor brownColor]        // 0.6, 0.4, 0.2 RGB
#define kCOLOR_clear            [UIColor clearColor]        // 0.0 white, 0.0 alpha

//基本颜色轻色版
#define kCOLOR_light_red        KCOLOR(222,113,98)
#define kCOLOR_light_orange     KCOLOR(247,186,129)
#define kCOLOR_light_yellow     KCOLOR(254,233,180)
#define kCOLOR_light_green      KCOLOR(169,195,104)
#define kCOLOR_light_blue       KCOLOR(82,170,193)
#define kCOLOR_light_gray       KCOLOR(211,211,212)
#define kCOLOR_light_black      KCOLOR(129,129,129)
#define kCOLOR_light_purple     KCOLOR(187,160,203)

//基本颜色华丽版
#define kCOLOR_heavy_red        KCOLOR(231,37,32)   //E72562
#define kCOLOR_heavy_orange     KCOLOR(241,141,0)   //F18D00
#define kCOLOR_heavy_yellow     KCOLOR(255,237,97)  //FFED61
#define kCOLOR_heavy_green      KCOLOR(170,207,82)  //AACF52
#define kCOLOR_heavy_blue       KCOLOR(44,134,206)   //49A1C1
#define kCOLOR_heavy_gray       KCOLOR(81,77,77)    //514D4D
#define kCOLOR_heavy_black      KCOLOR(0,10,0)      //000A00
#define kCOLOR_heavy_purple     KCOLOR(124,80,157)  //7C509D

//tabbar选择色
#define kCOLOR_tabBar           kCOLOR_heavy_blue

#define kCOLOR_line             kCOLOR_RGBValue(0xEAEAEA)

//tableview背景色
#define kCOLOR_tableView        kCOLOR_RGBValue(0xEFEFEF)

//NavigationBar颜色
#define kCOLOR_Nav              kCOLOR_RGBValue(0xEAEAEA)

//字体颜色
#define KCOLOR_font_normal      kCOLOR_RGBValue(0x666666)
#define KCOLOR_font_light       kCOLOR_RGBValue(0x999999)
#define KCOLOR_font_special     kCOLOR_RGBValue(0x333333)

#endif /* ColorDefine_h */
