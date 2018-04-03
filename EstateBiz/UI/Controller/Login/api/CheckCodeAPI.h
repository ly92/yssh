//
//  CheckCodeAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CheckCodeAPI : YTKRequest

-(instancetype)initWithCheckCode:(NSString *)checkcode mobile:(NSString *)mobile;

@end
