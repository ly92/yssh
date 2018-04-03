//
//  BaseNetConfig.h
//  EstateBiz
//
//  Created by Ender on 10/26/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,YTkServer) {
    WETOWN, //微Town服务器
    KAKATOOL  //卡卡兔服务器
};

@interface BaseNetConfig : NSObject

//@property (nonatomic, assign) BOOL isKKT;


+(BaseNetConfig *)shareInstance;

//配置星生活服务器
-(void)configGlobalAPI:(YTkServer)server;

//配置卡卡兔服务器
//-(void)configKKTGlobalAPI;

@end
