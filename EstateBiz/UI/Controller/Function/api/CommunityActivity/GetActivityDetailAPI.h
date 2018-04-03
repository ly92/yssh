//
//  GetActivityDetailAPI.h
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface GetActivityDetailAPI : YTKRequest
//获取活动详情
-(instancetype)initWithId:(NSString *)id;

@end
