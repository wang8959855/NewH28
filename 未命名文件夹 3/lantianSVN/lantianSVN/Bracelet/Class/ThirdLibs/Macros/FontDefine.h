//
//  FontDefine.h
//  MasonryDemo
//
//  Created by 谢英泽 on 2016/11/10.
//  Copyright © 2016年 wtjr. All rights reserved.
//
#import "UnitydDefine.h"

#ifndef FontDefine_h
#define FontDefine_h

#define kFONT_Nav_HTML5     kFONT_HEITI_SC(20)

//Heiti TC
#define kFONT_HEITI_TC(m)   [UIFont fontWithName:@"Heiti TC" size:m]

//Heiti SC
#define kFONT_HEITI_SC(m)   [UIFont fontWithName:@"Heiti SC" size:m]

//Lato-Regular
#define kFONT_Regular_SC(m)   [UIFont fontWithName:@"Lato-Regular" size:m]

//Lato-ThinItalic
#define kFONT_ThinItalic_SC(m)   [UIFont fontWithName:@"Lato-ThinItalic" size:m]

//******************************屏幕适配**********************************/

/**
 iPhone6p
 */
#ifdef kUI_is_Iphone6p

#define kFONT_system(m)     [UIFont systemFontOfSize:m * 1.1f]

//导航栏标题
#define kFONT_navTitle      kFONT_system(20)
//普通字体
#define kFONT_normalText    kFONT_system(14)

/**
 iPhone6
 */
#elif kUI_is_Iphone6

#define kFONT_system(m)     [UIFont systemFontOfSize:m]

//导航栏标题
#define kFONT_navTitle      kFONT_system(20)
//普通字体
#define kFONT_normalText    kFONT_system(14)

/**
 iPhone5
 */
#else

#define kFONT_system(m)     [UIFont systemFontOfSize:m * 0.9f]

//导航栏标题
#define kFONT_navTitle      kFONT_system(20)
//普通字体
#define kFONT_normalText    kFONT_system(14)

#endif

#endif /* FontDefine_h */
