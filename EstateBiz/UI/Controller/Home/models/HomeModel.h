//
//  HomeModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@end


@interface AuthoriseCommunityResultModel : NSObject

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSArray *list;

@end

//小区广告
@interface AdModel : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image_md5;
@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, copy) NSString *outerurl;
@property (nonatomic, copy) NSString *ownerid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;


@end

@interface MoreFunctionModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *modules;

@end

//function模块
@interface FunctionModel : NSObject

@property (nonatomic, copy) NSString *actionandroid;
@property (nonatomic, copy) NSString *actionios;
@property (nonatomic, copy) NSString *actiontype;
@property (nonatomic, copy) NSString *actionurl;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *bno;
@property (nonatomic, copy) NSString *bsecret;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *iconurl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mtype;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *weight;


@end

//小区活动
@interface LimitActivityModel : NSObject

@property (nonatomic, strong) NSArray * attr; //

@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) LIMITYACTIVITY_STYLE style;

@end

@interface AttrModel : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end



//我的会员卡列表
@interface MemberCardResultModel : NSObject

@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *last_datetime;
@property (nonatomic, copy) NSString *last_id;

@property (nonatomic, strong) NSArray *CardList;

@end

@interface MemberCardModel : NSObject

@property (nonatomic, copy) NSString *pushcount;
@property (nonatomic, copy) NSString *clickCount;

@property (nonatomic, copy) NSString *amounts;
@property (nonatomic, copy) NSString *backimageurl;
@property (nonatomic, copy) NSString *barcodeurl;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *biz_address;
@property (nonatomic, copy) NSString *bizmemo;
@property (nonatomic, copy) NSString *card_category;
@property (nonatomic, copy) NSString *cardid;
@property (nonatomic, copy) NSString *cardname;
@property (nonatomic, copy) NSString *cardnum;
@property (nonatomic, copy) NSString *cardtype;
@property (nonatomic, copy) NSString *cardtypes;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *clientname;
@property (nonatomic, copy) NSString *coupon_num;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *discounts;
@property (nonatomic, copy) NSString *expriationtime;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *frontimageurl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isfav;
@property (nonatomic, copy) NSString *istop;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *tcid;
@property (nonatomic, copy) NSString *thirdpartmemo;
@property (nonatomic, copy) NSString *updatetimes;

@end


