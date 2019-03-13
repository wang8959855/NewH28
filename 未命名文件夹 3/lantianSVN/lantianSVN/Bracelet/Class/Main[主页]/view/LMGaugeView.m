//
//  LMGaugeView.m
//  LMGaugeView
//
//  Created by LMinh on 01/08/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import "LMGaugeView.h"

#define kDefaultStartAngle                      M_PI_4 * 3
#define kDefaultEndAngle                        M_PI_4
#define kDefaultMinValue                        0
#define kDefaultMaxValue                        120
#define kDefaultLimitValue                      50
#define kDefaultNumOfDivisions                  6
#define kDefaultNumOfSubDivisions               10

#define kDefaultRingThickness                   15
#define kDefaultRingBackgroundColor             [UIColor colorWithWhite:0.9 alpha:1]
#define kDefaultRingColor                       [UIColor colorWithRed:76.0/255 green:217.0/255 blue:100.0/255 alpha:1]



#define kDefaultDivisionsRadius                 1.25
#define kDefaultDivisionsColor                  [UIColor colorWithWhite:0.5 alpha:1]
#define kDefaultDivisionsPadding                12

#define kDefaultSubDivisionsRadius              0.75
#define kDefaultSubDivisionsColor               [UIColor colorWithWhite:0.5 alpha:0.5]

#define kDefaultLimitDotRadius                  2
#define kDefaultLimitDotColor                   [UIColor redColor]

#define kDefaultValueFont                       [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:150]
#define kDefaultValueTextColor                  [UIColor colorWithWhite:0.1 alpha:1]

#define kDefaultUnitOfMeasurement               @"km/h"
#define kDefaultUnitOfMeasurementFont           [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]
#define kDefaultUnitOfMeasurementTextColor      [UIColor colorWithWhite:0.3 alpha:1]

@interface LMGaugeView ()

// For calculation
@property (nonatomic, assign) CGFloat divisionUnitAngle;
@property (nonatomic, assign) CGFloat divisionUnitValue;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation LMGaugeView

#pragma mark - INIT

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    // Set default values
    _startAngle = kDefaultStartAngle;
    _endAngle = kDefaultEndAngle;
    
    _value = kDefaultMinValue;
    _minValue = kDefaultMinValue;
    _maxValue = kDefaultMaxValue;
    _limitValue = kDefaultLimitValue;
//    _numOfDivisions = kDefaultNumOfDivisions;
//    _numOfSubDivisions = kDefaultNumOfSubDivisions;
    
    // Ring
    _ringThickness = kDefaultRingThickness;
//    _ringBackgroundColor = kDefaultRingBackgroundColor;
    _ringBackgroundColor = kmainDarkColor;
    
    // Divisions
    _divisionsRadius = kDefaultDivisionsRadius;
    _divisionsColor = kDefaultDivisionsColor;
    _divisionsPadding = kDefaultDivisionsPadding;
    
    // Subdivisions
    _subDivisionsRadius = kDefaultSubDivisionsRadius;
    _subDivisionsColor = kDefaultSubDivisionsColor;
    
    // Limit dot
    _showLimitDot = YES;
    _limitDotRadius = kDefaultLimitDotRadius;
    _limitDotColor = kDefaultLimitDotColor;
    
    // Value Text
    
    // Unit Of Measurement
    _showUnitOfMeasurement = YES;
    _unitOfMeasurement = kDefaultUnitOfMeasurement;
    _unitOfMeasurementFont = kDefaultUnitOfMeasurementFont;
    _unitOfMeasurementTextColor = kDefaultUnitOfMeasurementTextColor;

}


#pragma mark - ANIMATION

- (void)strokeGauge
{
    /*!
     *  Set progress for ring layer
     */
    CGFloat progress ;
    
    if (!self.maxValue)
    {
        progress = 0;
    }else
    {
        CGFloat com = (self.value - self.minValue)/(self.maxValue - self.minValue);
        if (com > 1)
        {
            progress = 1;
        }
        else
        {
            progress = com;
        }
    }
    
    self.progressLayer.strokeEnd = progress;
    
    /*!
     *  Set ring stroke color
     */
    UIColor *ringColor = [UIColor whiteColor];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gaugeView:ringStokeColorForValue:)]) {
        ringColor = [self.delegate gaugeView:self ringStokeColorForValue:self.value];
    }
    self.progressLayer.strokeColor = ringColor.CGColor;
}


#pragma mark - CUSTOM DRAWING

- (void)drawRect:(CGRect)rect
{
    /*!
     *  Prepare drawing
     */
//    self.divisionUnitValue = self.numOfDivisions ? (self.maxValue - self.minValue)/self.numOfDivisions : 0;
//    self.divisionUnitAngle = self.numOfDivisions ? (M_PI * 2 - ABS(self.endAngle - self.startAngle))/self.numOfDivisions : 0;
   
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat ringRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - self.ringThickness/2;
//    CGFloat dotRadius = ringRadius - self.ringThickness/2 - self.divisionsPadding - self.divisionsRadius/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*!
     *  Draw the ring background
     */
    CGContextSetLineWidth(context, self.ringThickness);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, ringRadius, 0, M_PI * 2, 0);
    CGContextSetStrokeColorWithColor(context, [self.ringBackgroundColor colorWithAlphaComponent:0.3].CGColor);
    CGContextStrokePath(context);
    
    /*!
     *  Draw the ring progress background
     */
    CGContextSetLineWidth(context, self.ringThickness);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, ringRadius, self.startAngle, self.endAngle, 0);
    CGContextSetStrokeColorWithColor(context, self.ringBackgroundColor.CGColor);
    CGContextStrokePath(context);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.ringThickness, self.ringThickness,self.width - 2 * self.ringThickness , self.width - 2* self.ringThickness)];
    UIColor *fillColor = [UIColor clearColor];
    [fillColor set];
    [path fill];
    
    [path stroke];
    /*!
     *  Draw divisions and subdivisions
     */

    
    /*!
     *  Draw the limit dot
     */

    
    /*!
     *  Progress Layer
     */
    if (!self.progressLayer)
    {
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.progressLayer.fillColor = [UIColor clearColor].CGColor;
        self.progressLayer.lineCap = kCALineJoinRound;
        self.progressLayer.lineJoin = kCALineJoinRound;
        [self.layer insertSublayer:self.progressLayer atIndex:0];
        self.progressLayer.strokeEnd = 0;
    }
    self.progressLayer.frame = CGRectMake(center.x - ringRadius - self.ringThickness/2,
                                          center.y - ringRadius - self.ringThickness/2,
                                          (ringRadius + self.ringThickness/2) * 2,
                                          (ringRadius + self.ringThickness/2) * 2);
    self.progressLayer.bounds = self.progressLayer.frame;
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:self.progressLayer.position
                                                                radius:ringRadius
                                                            startAngle:self.startAngle
                                                              endAngle:self.endAngle
                                                             clockwise:YES];
    self.progressLayer.path = smoothedPath.CGPath;
    self.progressLayer.lineWidth = self.ringThickness;
    
    /*!
     *  Value Label
     */
}


#pragma mark - SUPPORT

- (CGFloat)angleFromValue:(CGFloat)value
{
    CGFloat level = self.divisionUnitValue ? (value - self.minValue)/self.divisionUnitValue : 0;
    CGFloat angle = level * self.divisionUnitAngle + self.startAngle;
    return angle;
}

- (void)drawDotAtContext:(CGContextRef)context
                  center:(CGPoint)center
                  radius:(CGFloat)radius
               fillColor:(CGColorRef)fillColor
{
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, 0);
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextFillPath(context);
}


#pragma mark - PROPERTIES

- (UIView *)DotView
{
    if (!_DotView)
    {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 0, 0);
        view.backgroundColor = kmainBackgroundColor;
        [self addSubview:view];
        _DotView = view;
    }
    return _DotView;
}

- (void)setValue:(CGFloat)value
{
    float com = (100 * value/_maxValue);
    float maxCom = MIN(com, 100);
    int x = self.width/2. + (self.height/2. - self.ringThickness/2.) *cos((maxCom/100.f + 0.75) *M_PI * 2);//括号内为弧度值
    int y = self.width/2. + (self.height/2. - self.ringThickness/2.) *sin((maxCom/100.f + 0.75) *M_PI * 2);

    self.DotView.frame = CGRectMake(0, 0, _ringThickness * 0.6, _ringThickness * 0.6);
    self.DotView.layer.cornerRadius = _ringThickness * 0.3;
    self.DotView.center = CGPointMake(x, y);

    _value = value;
    _value = MAX(_value, _minValue);
    
    /*!
     *  Set text for value label
     */

    /*!
     *  Trigger the stoke animation of ring layer.
     */
    [self strokeGauge];
}

- (void)setMinValue:(CGFloat)minValue
{
    if (_minValue != minValue && minValue < _maxValue) {
        _minValue = minValue;
        
        [self setNeedsDisplay];
    }
}

- (void)setMaxValue:(CGFloat)maxValue
{

    if (_maxValue != maxValue && maxValue > _minValue) {

        _maxValue = maxValue;
        [self setNeedsDisplay];

        float com = (100 * self.value/_maxValue);
        float maxCom = MIN(com, 100);
        int x = self.width/2. + (self.height/2. - self.ringThickness/2.) *cos((maxCom/100.f + 0.75) *M_PI * 2);//括号内为弧度值
        int y = self.width/2. + (self.height/2. - self.ringThickness/2.) *sin((maxCom/100.f + 0.75) *M_PI * 2);
      
        self.DotView.frame = CGRectMake(0, 0, _ringThickness * 0.6, _ringThickness * 0.6);
        self.DotView.layer.cornerRadius = _ringThickness * 0.3;
        self.DotView.center = CGPointMake(x, y);

    }
}

- (void)setLimitValue:(CGFloat)limitValue
{
    if (_limitValue != limitValue && limitValue >= _minValue && limitValue <= _maxValue) {
        _limitValue = limitValue;
        
        [self setNeedsDisplay];
    }
}



- (void)setRingThickness:(CGFloat)ringThickness
{
    if (_ringThickness != ringThickness) {
        _ringThickness = ringThickness;
        
        [self setNeedsDisplay];
    }
}

- (void)setRingBackgroundColor:(UIColor *)ringBackgroundColor
{
    if (_ringBackgroundColor != ringBackgroundColor) {
        _ringBackgroundColor = ringBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsRadius:(CGFloat)divisionsRadius
{
    if (_divisionsRadius != divisionsRadius) {
        _divisionsRadius = divisionsRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsColor:(UIColor *)divisionsColor
{
    if (_divisionsColor != divisionsColor) {
        _divisionsColor = divisionsColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setDivisionsPadding:(CGFloat)divisionsPadding
{
    if (_divisionsPadding != divisionsPadding) {
        _divisionsPadding = divisionsPadding;
        
        [self setNeedsDisplay];
    }
}

- (void)setSubDivisionsRadius:(CGFloat)subDivisionsRadius
{
    if (_subDivisionsRadius != subDivisionsRadius) {
        _subDivisionsRadius = subDivisionsRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setSubDivisionsColor:(UIColor *)subDivisionsColor
{
    if (_subDivisionsColor != subDivisionsColor) {
        _subDivisionsColor = subDivisionsColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setShowLimitDot:(BOOL)showLimitDot
{
    if (_showLimitDot != showLimitDot) {
        _showLimitDot = showLimitDot;
        
        [self setNeedsDisplay];
    }
}

- (void)setLimitDotRadius:(CGFloat)limitDotRadius
{
    if (_limitDotRadius != limitDotRadius) {
        _limitDotRadius = limitDotRadius;
        
        [self setNeedsDisplay];
    }
}

- (void)setLimitDotColor:(UIColor *)limitDotColor
{
    if (_limitDotColor != limitDotColor) {
        _limitDotColor = limitDotColor;
        
        [self setNeedsDisplay];
    }
}





- (void)setShowUnitOfMeasurement:(BOOL)showUnitOfMeasurement
{
    if (_showUnitOfMeasurement != showUnitOfMeasurement) {
        _showUnitOfMeasurement = showUnitOfMeasurement;
        
    }
}

- (void)setUnitOfMeasurement:(NSString *)unitOfMeasurement
{
    if (_unitOfMeasurement != unitOfMeasurement) {
        _unitOfMeasurement = unitOfMeasurement;
        
    }
}

- (void)setUnitOfMeasurementFont:(UIFont *)unitOfMeasurementFont
{
    if (_unitOfMeasurementFont != unitOfMeasurementFont) {
        _unitOfMeasurementFont = unitOfMeasurementFont;
    }
}

- (void)setUnitOfMeasurementTextColor:(UIColor *)unitOfMeasurementTextColor
{
    if (_unitOfMeasurementTextColor != unitOfMeasurementTextColor) {
        _unitOfMeasurementTextColor = unitOfMeasurementTextColor;
    }
}

@end
