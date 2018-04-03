//
//  GetNoticeListAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetNoticeListAPI.h"

@interface GetNoticeListAPI ()
{
    NSString *_ownerid;
    NSString *_skip;
    NSString *_limit;
}
@end

@implementation GetNoticeListAPI

-(instancetype)initWithOwnerid:(NSString *)ownerId skip:(NSString *)skip limit:(NSString *)limit{
    if (self == [super init]) {
        _ownerid = ownerId;
        _skip = skip;
        _limit = limit;
    }
    return self;
}
-(NSString *)requestUrl{
    return NOTICE_LIST;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"ownerid":_ownerid,
             @"skip":_skip,
             @"limit":_limit
             };
}


@end
