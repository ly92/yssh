//
//  CommunityActivityModel.h
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityActivityModel : NSObject

@end


@interface CommunityActivity : NSObject

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *actiontime;
@property(nonatomic,retain)NSString *starttime;
@property(nonatomic,retain)NSString *stoptime;
@property(nonatomic,retain)NSString *maxuser;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *image;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *location;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *joined;

@end
