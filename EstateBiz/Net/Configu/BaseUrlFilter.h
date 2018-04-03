//
//  BaseUrlFilter.h
//  EstateBiz
//
//  Created by Ender on 10/26/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YTKNetworkConfig.h>
//#import <YTKNetworkPrivate.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"

@interface BaseUrlFilter : NSObject<YTKUrlFilterProtocol>

//配置星生活服务器参数
+ (BaseUrlFilter *)filterWithArguments:(NSDictionary *)arguments;

//配置卡卡兔服务器参数
+ (BaseUrlFilter *)filterKKTWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

@end
