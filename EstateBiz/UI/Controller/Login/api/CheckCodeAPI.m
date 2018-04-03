//
//  CheckCodeAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CheckCodeAPI.h"

@interface CheckCodeAPI ()
{
    NSString *_checkCode;
    NSString *_mobile;
}
@end

@implementation CheckCodeAPI

-(instancetype)initWithCheckCode:(NSString *)checkcode mobile:(NSString *)mobile{
    if (self == [super init]) {
        _checkCode = checkcode;
        _mobile = mobile;
    }
    return self;
}
-(NSString *)requestUrl{
    return REGISTER_CHECK_CODE;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"checkcode":_checkCode,
             @"mobile":_mobile};
}


@end
