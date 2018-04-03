//
//  GetHasJoinActivityListAPI.m
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetHasJoinActivityListAPI.h"

@implementation GetHasJoinActivityListAPI

-(NSString *)requestUrl{
    return COMACTIVITY_LISTJOIN;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}


@end
