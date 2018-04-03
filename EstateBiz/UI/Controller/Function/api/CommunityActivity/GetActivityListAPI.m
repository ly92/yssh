//
//  GetActivityListAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetActivityListAPI.h"

@interface GetActivityListAPI ()
{
    NSString *_bid;
}
@end

@implementation GetActivityListAPI

-(instancetype)initWithBid:(NSString *)bid{
    if (self == [super init]) {
        _bid = bid;
    }
    return self;
}

-(NSString *)requestUrl{
    return COMACTIVITY_LISTACTIVITY;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid":_bid};
}

@end
