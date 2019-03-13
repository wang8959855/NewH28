//
//  SizeDefine.h
//  MasonryDemo
//
//  Created by 谢英泽 on 2016/11/10.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#ifndef SizeDefine_h
#define SizeDefine_h


/**
 屏幕常见空间高度
 */
#define kUI_NavBar_HEIGHT   44
#define kUI_TabBar_HEIGHT   49
#define kUI_Status_HEIGHT   20
#define kUI_Zero            0

#define kUI_CellHeight      54

#define kPadding_Width      10
#define kMargin_Height      10

#define kCollectionCellPadding  10

/**
 获取frame尺寸
 */
#define kUI_WIDTH           [UIScreen mainScreen].bounds.size.width
#define kUI_HEIGHT          [UIScreen mainScreen].bounds.size.height

#define kUI_Width(frame)    CGRectGetWidth(frame)
#define kUI_Height(frame)   CGRectGetHeight(frame)
#define kUI_MinX(frame)     CGRectGetMinX(frame)
#define kUI_MaxX(frame)     CGRectGetMaxX(frame)
#define kUI_MinY(frame)     CGRectGetMinY(frame)
#define kUI_MaxY(frame)     CGRectGetMaxY(frame)
#define kUI_MidX(frame)     CGRectGetMidX(frame)
#define kUI_MidY(frame)     CGRectGetMidY(frame)
#define kUI_CenterX(frame)  (frame.size.width/2)
#define kUI_CenterY(frame)  (frame.size.height/2)

#endif /* SizeDefine_h */
