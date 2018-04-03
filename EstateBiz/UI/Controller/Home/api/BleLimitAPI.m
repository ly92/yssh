//
//  BleLimitAPI.m
//  EstateBiz
//
//  Created by ly on 2016/12/9.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "BleLimitAPI.h"

@interface BleLimitAPI (){
    NSString *_logs;
    
    BOOL _isLog;
}

@end

@implementation BleLimitAPI
- (instancetype)initWithLog:(NSArray *)logs{
    if (self = [super init]){
        _logs = [logs modelToJSONString];
        _isLog = YES;
    }
    return self;
}

-(NSString *)requestUrl{
    
    if (_isLog){
        //上传蓝牙开门纪录
    return BLE_OPENDOOR_LOG;
    }
    //获取蓝牙开门权限
    return BLE_OPENDOOR_LIMIT;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    if (_isLog){
        
        if ([ISNull isNilOfSender:_logs]){
            _logs = @"";
        }
        //上传蓝牙开门纪录
        return @{@"log" : _logs};
    }
    //获取蓝牙开门权限
    return nil;
}

@end
