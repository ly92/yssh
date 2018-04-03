//
//  HomeModel.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

@end

@implementation AuthoriseCommunityResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"list":@"Community"};
}

@end


@implementation MemberCardResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"CardList":@"MemberCardModel"};
}

@end

@implementation AdModel

@end

@implementation MoreFunctionModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"modules":@"FunctionModel"};
}

@end

@implementation FunctionModel

@end


@implementation LimitActivityModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"attr":@"AttrModel"};
}

@end

@implementation AttrModel

@end



@implementation MemberCardModel

@end

