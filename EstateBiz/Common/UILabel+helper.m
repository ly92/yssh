//
//  UILabel+helper.m
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "UILabel+helper.h"

@implementation UILabel(helper)
-(void)textLocalizedText:(NSString *)text
{
    self.text = NSLocalizedString(text, nil);
}

/**
 *  真正才计算高度的函数
 */
-(void)autoCalculateTextViewFrame
{
    CGRect frame = self.frame;
    
    CGSize constraint = CGSizeMake(frame.size.width , CGFLOAT_MAX);
    
    CGSize size = [self.text sizeWithFont: self.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    frame.size.height = size.height;
    
    self.frame = frame;
}


//返回高度
-(CGFloat)resizeHeight{
    CGRect frame = self.frame;
    
//    CGSize constraint = CGSizeMake(frame.size.width , CGFLOAT_MAX);
    
    CGSize size = [self sizeThatFits:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
    
//    CGSize size = [self.text sizeWithFont: self.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

//返回宽度
-(CGFloat)resizeWidth{
    CGRect frame = self.frame;
    
//    CGSize constraint = CGSizeMake(CGFLOAT_MAX , frame.size.height);
    
    CGSize size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, frame.size.height)];
    
//    CGSize size = [self.text sizeWithFont: self.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size.width;
}
@end
