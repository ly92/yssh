//
//  AppDelegate.h
//  EstateBiz
//
//  Created by Ender on 10/20/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate*) sharedAppDelegate;

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) RDVTabBarController *tabController;

-(void)registerDevice;

-(void)setBadgeValue:(int)bageValue foeIndex:(NSInteger)index;

//根据用户登录状况设置界面
-(void)setupRootViewController;
-(void)showLogin;
// 统计未读消息数
-(void)setupUnreadMessageCount;


//推送信息提示
-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer;
-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer Block:(void (^)(void))response;

//弹出开门送优惠券
-(void)popOpenDoorCoupon:(NSString *)msg SnID:(NSString *)snid Cmd:(NSString *)cmd;
@end

