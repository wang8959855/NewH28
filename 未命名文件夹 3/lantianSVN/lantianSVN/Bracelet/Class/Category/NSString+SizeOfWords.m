//
//  NSString+SizeOfWords.m
//  
//
//  Created by qianfeng on 15/8/27.
//
//

#import "NSString+SizeOfWords.h"

@implementation NSString (SizeOfWords)

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
@end
