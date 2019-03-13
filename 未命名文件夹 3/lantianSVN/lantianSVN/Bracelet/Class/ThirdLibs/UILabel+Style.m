//
//  UILabel+Style.m
//  MasonryDemo
//
//  Created by wtjr on 16/11/9.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#import "UILabel+Style.h"

@implementation UILabel (Style)

- (void)setLabelStyle:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)textFont texrAlignment:(NSTextAlignment)textAlignment
{
    self.text = text;
    self.textColor = textColor;
    self.font = textFont;
    self.textAlignment = textAlignment;
}

- (void) textLeftTopAlign
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [self.text boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGRect dateFrame =CGRectMake(2, 140, CGRectGetWidth(self.frame)-5, labelSize.height);
    self.frame = dateFrame;
}

-(void)alignTop
{
    // 对应字号的字体一行显示所占宽高
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    // 多行所占 height*line
    double height = fontSize.height*self.numberOfLines;
    // 显示范围实际宽度
    double width = self.frame.size.width;
    // 对应字号的内容实际所占范围
    CGSize stringSize = [self.text boundingRectWithSize:CGSizeMake(width, height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil].size;
    // 剩余空行
    NSInteger line = (height - stringSize.height) / fontSize.height;
    // 用回车补齐
    for (int i = 0; i < line; i++) {
        
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

@end
