//
//  LoginAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "LoginAPI.h"

@interface LoginAPI ()
{
    NSString *_userName;
    NSString *_pwd;
}
@end

@implementation LoginAPI

-(instancetype)initWithNormalWithMobile:(NSString *)mobile password:(NSString *)pwd{
    if (self == [super init]) {
        [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
        _userName = mobile;
        _pwd = pwd;
    }
    return self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return LOGIN_NORMAL;
}
-(id)requestArgument{
    return @{@"userName":_userName,
             @"pwd":_pwd};
}

@end
