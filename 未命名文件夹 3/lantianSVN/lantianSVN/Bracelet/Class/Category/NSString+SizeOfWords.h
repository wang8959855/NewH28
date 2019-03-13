//
//  NSString+SizeOfWords.h
//  
//
//  Created by qianfeng on 15/8/27.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SizeOfWords)

/**
 *  根据文字计算size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
