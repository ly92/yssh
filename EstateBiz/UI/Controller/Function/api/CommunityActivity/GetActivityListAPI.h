//
//  GetActivityListAPI.h
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface GetActivityListAPI : YTKRequest

//获取可参加活动列表
-(instancetype)initWithBid:(NSString *)bid;

@end
