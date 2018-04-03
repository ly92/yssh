//
//  GetNoticeListAPI.h
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface GetNoticeListAPI : YTKRequest

-(instancetype)initWithOwnerid:(NSString *)ownerId skip:(NSString *)skip limit:(NSString *)limit;

@end
