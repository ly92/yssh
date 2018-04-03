//
//  LoadNoticeAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "LoadNoticeAPI.h"

@interface LoadNoticeAPI ()
{
    NSString *_ownerId;
}
@end

@implementation LoadNoticeAPI

-(instancetype)initWithOwnerId:(NSString *)ownerid{
    if (self == [super init]) {
        _ownerId = ownerid;
    }
    return self;
}

-(NSString *)requestUrl{
    return HOME_AD;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"ownerid":_ownerId};
}

@end
