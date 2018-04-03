//
//  GetActivityDetailAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetActivityDetailAPI.h"

@interface GetActivityDetailAPI ()
{
    NSString *_id;
}
@end

@implementation GetActivityDetailAPI
-(instancetype)initWithId:(NSString *)id{
    if (self == [super init]) {
        _id = id;
    }
    return self;
}

-(NSString *)requestUrl{
    return COMACTIVITY_GETINFO;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"id":_id};
}



@end
