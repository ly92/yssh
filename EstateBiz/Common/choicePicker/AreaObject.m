//
//  AreaObject.m
//  Wujiang
//
//  Created by zhengzeqin on 15/5/28.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//  make by 郑泽钦 分享

#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    if (self.region && self.province && self.city && self.area){
        return [NSString stringWithFormat:@"%@ %@ %@ %@",self.region,self.province,self.city,self.area];
    }else if (self.region){
    return [NSString stringWithFormat:@"%@",self.region];
    }
    
    return nil;
}

@end
