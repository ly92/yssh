//
//  LoadNoticeAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface LoadNoticeAPI : YTKRequest

-(instancetype)initWithOwnerId:(NSString *)ownerid;

@end
