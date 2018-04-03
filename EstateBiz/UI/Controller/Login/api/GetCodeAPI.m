//
//  GetCodeAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "GetCodeAPI.h"


@interface GetCodeAPI ()
{
    NSString *_mobile;
}
@end

@implementation GetCodeAPI


-(instancetype)initWithMoblie:(NSString *)mobile{
    if (self == [super init]) {
        _mobile = mobile;
    }
    return self;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(NSString *)requestUrl{
    switch (self.codeType) {
        case REGISTERTYPE:
            return REGISTER_CODE;
            break;
        case FINDPSWTYPE:
            return FINDPWD_CHECKCODE;
            break;
            
        default:
            break;
    }
    
}


-(id)requestArgument{
    switch (self.codeType) {
        case REGISTERTYPE:
             return @{@"mobile":_mobile};
            break;
        case FINDPSWTYPE:
             return @{@"Mobile":_mobile};
            break;
            
        default:
            break;
    }
    
   
}

@end
