//
//  PZChart.m
//  keyBand
//
//  Created by 迈诺科技 on 15/12/4.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "PZChart.h"

#define kXSideidth 10

@implementation PZChart
static float maxHR = 180.0;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setHeartArray:(NSArray *)heartArray
{
    if (_heartArray != heartArray)
    {
        _heartArray = heartArray;
        
//        UIScrollView *scrollView = (UIScrollView *)self.superview;
//        scrollView.contentSize =
//        self.frame = CGRectMake(0, 0, self.heartArray.count + 20, self.height);
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    if (_heartArray.count != 0)
    {
        long pointCount = _heartArray.count;
        float xWidth = (self.width)/(pointCount);

        NSMutableArray *pointArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < pointCount; i ++)
        {
            float x =  i * xWidth ;

            float value = [_heartArray[i] floatValue];

            float y = (maxHR - value) * (self.height)/(maxHR - 20);
            if (value != 0)
            {
                [pointArray addObject:NSStringFromCGPoint(CGPointMake(x, y))];
            }
        }
        if (pointArray.count == 0)
        {
            return;
        }
        for (int i = 0; i < pointArray.count - 1; i++)
        {
            CGPoint firstPoint = CGPointFromString(pointArray[i]);
            CGPoint secondPoint = CGPointFromString(pointArray[i +1]);
            UIBezierPath* path = [UIBezierPath bezierPath];
            [path setLineWidth:1];
            
            [path moveToPoint:firstPoint];
            [path addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
            UIColor *lineColor = kmainBackgroundColor;
            [lineColor set];
            
            path.lineCapStyle = kCGLineCapRound;
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
        }
    }
}




@end
