//
//  AppDelegate.m
//  EstateBiz
//
//  Created by Ender on 10/20/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarItem.h"
#import "SBNavigationController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "SurroundingViewController.h"
#import "PersonalCenterViewController.h"
#import "LoginViewController.h"

#import "BaseNetConfig.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
//#import "RealReachability.h" //网站状态
#import "AJNotificationView.h"//通知
#import "NEHTTPEye.h" //网络调试
#import "EMSDK.h" //环信聊天
#import "HandlePush.h"

#import "OpenCouponView.h"
#import "OpenMoneyView.h"
#import "VoucherDetailViewController.h"
#import "NoticeViewController.h"
#import "Reachability.h"


@interface AppDelegate ()<UIAlertViewDelegate,RDVTabBarControllerDelegate,WXApiDelegate>

@property(nonatomic,retain) OpenCouponView *openCouponView;
@property(nonatomic,retain) OpenMoneyView *openMoneyView;

//推送消息c19
@property (nonatomic, retain) NSDictionary *userInfoC19;
//推送消息c20
@property (nonatomic, retain) NSDictionary *userInfoC20;

@end

@implementation AppDelegate

+ (AppDelegate*) sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - 程序生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //网络请求配置
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    
//    //设置状态栏字体颜色
//    if (GT_IOS7) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
    // 注册推送通知
    if (GT_IOS8) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else{
        // 推送信息
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    NSDictionary *pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(pushDict)
    {
        [self opratePushMSG: pushDict];
    }
    //默认样式
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //设置默认弹出时间为1秒
//    [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupRootViewController];
    
    [STICache.global setObject:@"NO" forKey:@"LOGOUT"];
    
    [self registerNoti];
    //向微信注册分享
    [WXApi registerApp:WECHAT_SHARE_KEY];

    //微信注册支付
    [WXApi registerApp:WECHAT_PAY_KEY];
    
    //监测网络状态
    [self moniterNetwork];
    
    //网络调试
    [self httpDebug];
    
    //环信注册
    [self configHuanxinApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //设置分享
    [self setupShare];
    
    //检查是否已经在其他手机上登陆
    [self checkDevice];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //重新计算badge数量
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=[[LocalizePush shareLocalizePush] getUnReadBadgleCount];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self checkDevice];
    
    //获取开门权限以及提交开门纪录
    [self getAndCommitDoorLimit];
    
    //从后台进入前台，刷新首页数据
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ENTERFOREGROUND" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark-通知
-(void)registerNoti{
    //小区公告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCommunityNotice:) name:@"Community_Notice" object:nil];
    
    //小区公告点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelCommunityNoticeClicked:) name:@"Community_Notice_Clicked" object:nil];
    
    //开门送红包点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelOpenCouponClicked:) name:@"Open_Coupon_Clicked" object:nil];
    
    //开门奖励的view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMoneyOrCoupon) name:@"showMoneyView" object:nil];
    
    // 开门成功上传数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commitDoorLog) name:@"OPENDOORRESULT" object:nil];
    
}


//小区公告处理
-(void)handleCommunityNotice:(NSNotification *)noti
{
    
    NSDictionary *dic=(NSDictionary *)noti.userInfo;
    NSString *msg=dic[@"msg"];
    NSString *bid=dic[@"bid"];
    
    if (msg) {
        NSString *moreMsg = [NSString stringWithFormat:@"%@[点击查看]",msg];
        
        [self showNoticeMsg:moreMsg WithInterval:3.0 Block:^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Community_Notice_Clicked" object:bid];
        }];
        
    }
}

//公告信息点击处理
-(void)handelCommunityNoticeClicked:(NSNotification *)noti
{
    
    NSString *communityid = (NSString *)noti.object;
    
    BOOL shouldChange=NO;
    if (communityid) {
        
        Community *selectedCommunity = [STICache.global objectForKey:@"selected_community"];
        if (selectedCommunity) {
            
            if ([communityid isEqualToString:selectedCommunity.bid]==NO) {
                shouldChange=YES;
            }
        }
        else{
            shouldChange=YES;
        }
        
        if (shouldChange) {
            
            
            [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
            SearchCommunityAPI *searchCommunityApi = [[SearchCommunityAPI alloc]initWithKeyword:communityid];
            [searchCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                    [self.window.rootViewController dismissTips];
                    [SVProgressHUD dismiss];
                    [self.window.rootViewController dismissTips];
                    id remoteCommunity = [result objectForKey:@"community"];
                    if ([remoteCommunity isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *firstCommunity = (NSDictionary *)remoteCommunity;
                        
                        Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                        
                        [STICache.global setObject:community forKey:@"selected_community"];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOADSELEDTCUMMUNITY" object:nil];
                        
                    }
                    else if ([remoteCommunity isKindOfClass:[NSArray class]]){
                        
                        NSArray *remotCommunity = (NSArray *)remoteCommunity;
                        
                        if ([remotCommunity count]>0) {
                            NSDictionary *firstCommunity = [remotCommunity objectAtIndex:0];
                            Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                            
                            [STICache.global setObject:community forKey:@"selected_community"];
                            
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOADSELEDTCUMMUNITY" object:nil];
                            
                        }
                    }
                    if (self.tabController) {
                        
                        if (self.tabController.selectedViewController) {
                            
                            //隐藏导航栏
                            if (!self.tabController.tabBarHidden) {
                                
                                [self.tabController setTabBarHidden:YES];
                                
                            }
                            
                            if ([self.tabController.selectedViewController isKindOfClass:[SBNavigationController class]]) {
                                
                                SBNavigationController *navController = (SBNavigationController *)self.tabController.selectedViewController;
                                
                                NoticeViewController *noticeController =[NoticeViewController spawn];
                                
                                [navController pushViewController:noticeController animated:YES];
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }else{
                     [self.window.rootViewController presentFailureTips:result[@"reason"]];
                }
            } failure:^(__kindof YTKBaseRequest *request) {
                [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];
            
        }
        else{
            
            if (self.tabController) {
                
                if (self.tabController.selectedViewController) {
                    
                    //隐藏导航栏
                    if (!self.tabController.tabBarHidden) {
                        
                        [self.tabController setTabBarHidden:YES];
                        
                    }
                    
                    if ([self.tabController.selectedViewController isKindOfClass:[SBNavigationController class]]) {
                        
                        SBNavigationController *navController = (SBNavigationController *)self.tabController.selectedViewController;
                        
                        NoticeViewController *noticeController =[NoticeViewController spawn];
                        
                        [navController pushViewController:noticeController animated:YES];
                        
                        
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
}

//开门送优惠券处理
-(void)handelOpenCouponClicked:(NSNotification *)noti
{
    NSString *snid = (NSString *)noti.object;
    
    [self.window.rootViewController presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    
    CouponOverdueAPI *couponOverdueApi = [[CouponOverdueAPI alloc]initWithSnid:snid];
    
    [couponOverdueApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [self.window.rootViewController dismissTips];
            NSDictionary *info = [result objectForKey:@"info"];
            if ([ISNull isNilOfSender:info]) {
                [self.window.rootViewController presentFailureTips:@"优惠券无效"];
                return ;
            }
            CouponModel *couponModel = [CouponModel mj_objectWithKeyValues:info];
            
            if (self.tabController) {
                
                if (self.tabController.selectedViewController) {
                    
                    //隐藏导航栏
                    if (!self.tabController.tabBarHidden) {
                        [self.tabController setTabBarHidden:YES];
                    }
                    if ([self.tabController.selectedViewController isKindOfClass:[SBNavigationController class]]) {
                        
                        SBNavigationController *navController = (SBNavigationController *)self.tabController.selectedViewController;
                        
                        
                        VoucherDetailViewController *voucherDetail = [[VoucherDetailViewController alloc]initWithVOUCHER:couponModel];
                        voucherDetail.reloadTable = ^(){
                            
                        };
                        
                        [navController pushViewController:voucherDetail animated:YES];
                    }
                }
            }
            
            
        }else{
             [self.window.rootViewController presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}

#pragma mark - 推送

//注册设备
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token= [[[[deviceToken description]
                        stringByReplacingOccurrencesOfString:@"<" withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
                      stringByReplacingOccurrencesOfString:@" " withString:@""];
    [LocalData updateDeviceToken:token];
    [self registerDevice];
}

//注册设备失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (error.code == 3010) {
        //NSLog(@"Push notifications are not supported in the iOS Simulator.");
        
#ifdef DEBUG
        [LocalData updateDeviceToken:@"iOSSIMULATOR"];
        
        [self registerDevice];
#endif
        
        
    }else{
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
    }
}

//远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    [[AppDelegate sharedAppDelegate] showNoticeMsg:@"收到推送" WithInterval:1.0f];
//    NSString *paramStr = [userInfo objectForKey:@"m"];
//    if (paramStr) {
//        NSArray *param = [paramStr componentsSeparatedByString:@"|"];
//        if (param&&param.count>0) {
//            
//            NSString *cmd = [param objectAtIndex:0];
//            
//            //如果是c19和c20则保存推送信息，等通知
//            if (cmd) {
//                if ([cmd isEqualToString:@"c19"]){
//                    
//                    self.userInfoC19 = userInfo;
//                    
//                }else if([cmd isEqualToString:@"c20"]){
//                    self.userInfoC20 = userInfo;
//                }else {
                    [self opratePushMSG: userInfo];
//                }
//                
//            }
//        }
//    }
    
    NSLog(@"didReceiveRemoteNotification");
}

//本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification");
}


-(void)opratePushMSG:(NSDictionary *)dic
{
    [HandlePush handelPushMessage:dic];
}

//注册设备
-(void)registerDevice{
    if ([[LocalData shareInstance] isLogin]) {
        
         [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
        UserModel *user=[LocalData shareInstance].getUserAccount;
        
        NSString *token = [LocalData getDeviceToken];
        
        if (user&&token&&token.length>5) {
            NSString *cid = user.cid;
            
            RegisterDeviceAPI *registerDeviceApi = [[RegisterDeviceAPI alloc]initWithMemberIDType:@"cid" objid:cid pushtoken:token];
            
           [registerDeviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
               
           } failure:^(__kindof YTKBaseRequest *request) {
               
           }];
            
        }
    }

}


//检查设备唯一性
-(void)checkDevice{
    
    if ([[LocalData shareInstance] isLogin]) {
        
        UserModel *user=[LocalData shareInstance].getUserAccount;
        
        NSString *token = [LocalData getDeviceToken];
        
        if (user&&token&&token.length>5) {
            NSString *cid = user.cid;
            
            [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
            
            CheckDeviceAPI *checkDeviceApi = [[CheckDeviceAPI alloc]initWithMemberIDType:@"cid" objid:cid pushtoken:token];
            
            
            [checkDeviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                    
                    int code = [[result objectForKey:@"r"] intValue];
                    //账号在另外一台手机上面登陆
                    if (code==1) {
                        
                        
                        SBNavigationController * login = [[SBNavigationController alloc] initWithRootViewController:[LoginViewController spawn]];
                        self.window.rootViewController = login;
                        
                        [[LocalData shareInstance] removeUserAccount];
                        [LocalData updateAccessToken:nil];
                        [LocalData updateDeviceToken:nil];
                        
                        [self performSelector:@selector(showMessage) withObject:nil afterDelay:0.8];
                       
                        
                    }
                    else
                    {
                        //检测其用户信息是否被更改过
                        [self checkUserInfo];
                    }

                    
                    
                }else{
                     [self.window.rootViewController presentFailureTips:result[@"reason"]];
                }
                
                
            } failure:^(__kindof YTKBaseRequest *request) {
                [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];
            
        }
    }
    
    
    
}

-(void)showMessage{
     [self.window.rootViewController presentFailureTips:@"你的账号在另一台机器上登录，请重新登录"];
}

-(void)checkUserInfo
{
    if ([[LocalData shareInstance]isLogin] == NO) {
        return;
    }
    
    
    NSMutableDictionary *userInfo = [LocalData fetchNormalUserInfo];
    if (userInfo) {
        NSString *psw = [userInfo objectForKey:@"password"];
        NSString *name = [userInfo objectForKey:@"account"];
        //登录
         [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
        LoginAPI *loginApi = [[LoginAPI alloc]initWithNormalWithMobile:name password:psw];
        [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                
                UserModel *user = [UserModel mj_objectWithKeyValues:result[@"user"]];
                
                if (user) {
                    
                    //更新user到本地
                    [[LocalData shareInstance] updateUserAccount:user];
                    //更新access_token到本地
                    [LocalData updateAccessToken:user.access_token];
                    //更新用户名、密码
                    [LocalData updateNormalUserInfo:name Psw:psw];
                    
                    //从后台进入前台，刷新首页数据
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ENTERFOREGROUND" object:nil];
                   
                }
                
            }else{
                 [self.window.rootViewController presentFailureTips:result[@"reason"]];
                
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [self.window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            
        }];
        
    }
}
#pragma mark - 弹出开门送优惠券
-(void)popOpenDoorCoupon:(NSString *)msg SnID:(NSString *)snid Cmd:(NSString *)cmd
{
    if ([cmd isEqualToString:@"c19"]){
        if (!_openCouponView) {
            _openCouponView = [[OpenCouponView alloc] initWithParentController:self.tabController];
            
        }
        _openCouponView.snid = snid;
        //测试
        //                [_openCouponView show:@"恭喜您获得开门奖励，来自【魔幻软件】的\"优惠券名\" 99993张。"];
        //测试
        
        [_openCouponView show:msg];
        
    }else if ([cmd isEqualToString:@"c20"]){
        if (!_openMoneyView) {
            
            _openMoneyView = [[OpenMoneyView alloc] initWithParentController:self.tabController];
            
        }
        _openMoneyView.snid = snid;
        //                        [_openMoneyView show:@"恭喜您参加\"扫码送大米\"活动获得【千丝发艺】开门奖励3.94元。"];
        [_openMoneyView show:msg];
        
    }
    
}

//接收到通知再显示保存的推送（money 和 coupon ）
- (void)showMoneyOrCoupon{
    
    if (self.userInfoC20){
        [self opratePushMSG:self.userInfoC20];
    }
    
    if (self.userInfoC19){
        [self opratePushMSG:self.userInfoC19];
    }
}
#pragma mark-设置主界面
#pragma mark - 界面
-(void)setupRootViewController{
    
    if(self.tabController){
        //所有nav显示首页
        for (UIViewController *controller in [self.tabController viewControllers]) {
            if ([controller isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)controller;
                if ([nav viewControllers].count>1) {
                    [nav popToRootViewControllerAnimated:NO];
                }
            }
        }
        //切换到首页
        [self.tabController setSelectedIndex:0];
    }
    
    UserModel *user = [LocalData shareInstance].getUserAccount;
    if (user) {
        [self setupViewControllers];
        //获取开门权限以及提交开门纪录
        [self getAndCommitDoorLimit];
    }else{
        [self showLogin];
    }
}

//登陆界面
-(void)showLogin{
    
    SBNavigationController * login = [[SBNavigationController alloc] initWithRootViewController:[LoginViewController spawn]];
    
    self.window.rootViewController = login;
    
    //消除气泡
    [[LocalizePush shareLocalizePush] removePushDic];
    
    [[LocalData shareInstance] removeUserAccount];
    [LocalData updateAccessToken:nil];
    
    
}

- (void)setupViewControllers {
    
    HomeViewController *firstViewController = [HomeViewController spawn];
    SBNavigationController *firstNavigationController = [[SBNavigationController alloc]
                                                         initWithRootViewController:firstViewController];
    
    MessageViewController *secondViewController = [MessageViewController spawn];
    SBNavigationController *secondNavigationController = [[SBNavigationController alloc]
                                                          initWithRootViewController:secondViewController];
    
    SurroundingViewController *fourthViewController = [SurroundingViewController spawn];
    SBNavigationController *fourthNavigationController = [[SBNavigationController alloc]
                                                          initWithRootViewController:fourthViewController];
    
    PersonalCenterViewController *fifthViewController = [PersonalCenterViewController spawn];
    SBNavigationController *fifthNavigationController = [[SBNavigationController alloc]
                                                         initWithRootViewController:fifthViewController];
    
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           fourthNavigationController,fifthNavigationController ]];
    
    tabBarController.tabBar.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_tab_bg"]];
    tabBarController.delegate = self;
    
    self.tabController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
    
    [self.window setRootViewController:self.tabController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    NSArray *tabBarItemTitles = @[@"首页", @"信息",@"周边",@"我的"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        
        //标题
        [item setSelectedTitleAttributes: @{
                                            NSFontAttributeName: [UIFont systemFontOfSize:11],
                                            NSForegroundColorAttributeName: TAB_SELECTTEXT_COLOR,
                                            }];
        
        [item setUnselectedTitleAttributes: @{
                                              NSFontAttributeName: [UIFont systemFontOfSize:11],
                                              NSForegroundColorAttributeName: TAB_TEXT_COLOR,
                                              }];
        
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        
        //icon
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_icon_%ld_pre",
                                                      index+1]];
        
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_icon_%ld",
                                                        index+1]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        
        index++;
    }
}

#pragma mark - 网络监测
-(void)moniterNetwork
{
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [self fk_observeNotifcation:kReachabilityChangedNotification usingBlock:^(NSNotification *note) {
        Reachability *reachability = (Reachability *)note.object;
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        if (status == NotReachable)
        {
            NSLog(@"Network unreachable!");
            [self.window.rootViewController presentFailureTips:@"网络不可用，请检查网络连接"];
        }else{
            //获取开门权限以及提交开门纪录
            [self getAndCommitDoorLimit];
        }
        
        if (status == ReachableViaWiFi)
        {
            NSLog( @"Network wifi! Free!");
        }
        
        if (status == ReachableViaWWAN)
        {
            NSLog( @"Network WWAN! In charge!");
        }
        

    }];
    
    [reach startNotifier];

    
//    GLobalRealReachability.hostForPing = @"www.baidu.com";
//    
//    [GLobalRealReachability startNotifier];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(networkChanged:)
//                                                 name:kRealReachabilityChangedNotification
//                                               object:nil];
}

-(void)networkChanged:(NSNotification *)notification
{
//    RealReachability *reachability = (RealReachability *)notification.object;
//    ReachabilityStatus status = [reachability currentReachabilityStatus];
//    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
//    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
//    
//    if (status == RealStatusNotReachable)
//    {
//        NSLog(@"Network unreachable!");
//         [self.window.rootViewController presentFailureTips:@"网络不可用，请检查网络连接"];
////        [SVProgressHUD showErrorWithStatus:@"网络不可用，请检查网络连接"];
//    }else{
//        //获取开门权限以及提交开门纪录
////        [self getAndCommitDoorLimit];
//    }
//    
//    if (status == RealStatusViaWiFi)
//    {
//        NSLog( @"Network wifi! Free!");
//    }
//    
//    if (status == RealStatusViaWWAN)
//    {
//        NSLog( @"Network WWAN! In charge!");
//    }
//    
//    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
//    
//    if (status == RealStatusViaWWAN)
//    {
//        if (accessType == WWANType2G)
//        {
//            NSLog(@"RealReachabilityStatus2G");
//        }
//        else if (accessType == WWANType3G)
//        {
//            NSLog( @"RealReachabilityStatus3G");
//        }
//        else if (accessType == WWANType4G)
//        {
//            NSLog( @"RealReachabilityStatus4G");
//        }
//        else
//        {
//            NSLog( @"Unknown RealReachability WWAN Status, might be iOS6");
//        }
//    }
    
}


#pragma mark - 网络调试
-(void)httpDebug
{
#ifdef DEBUG
    [NEHTTPEye setEnabled:YES];
#endif
    

}

#pragma mark - 环信聊天

//注册环信（包括推送）
-(void)configHuanxinApplication:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //AppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    
    NSString *apnsCertName = nil;
    NSString *appKey = nil;
//#ifdef DEBUG
    apnsCertName = @"chatdemoui_dev";
    appKey =@"dongeejiao2016#testdeyxpt";
//#else
//    apnsCertName = @"chatdemoui";
//    appKey =@"dongeejiao2016#deyxpt";
//#endif
    
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if ([[self.tabController viewControllers] count]>3) {
        UIViewController *chatController =[[self.tabController viewControllers] objectAtIndex:2];
        if (chatController) {
            if (unreadCount>0) {
                [chatController rdv_tabBarItem].badgeValue =[NSString stringWithFormat:@"%i",(int)unreadCount];
            }
            else{
                [chatController rdv_tabBarItem].badgeValue =@"";
            }
            
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

#pragma mark - 设置分享

-(void)setupShare
{
    //iosv1101 1d8a8577bbcc
    [ShareSDK registerApp:SHARE_SDK_KEY];
    
    //QQ空间
    [ShareSDK connectQZoneWithAppKey:QQ_SHARE_KEY
                           appSecret:QQ_SHARE_SECRET
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    //QQ
    [ShareSDK connectQQWithAppId:QQ_SHARE_KEY qqApiCls:[QQApiInterface class]];
    
    //新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:SINA_SHARE
                               appSecret:SINA_SHARE_SECRET
                             redirectUri:@"http://www.kakatool.com"
                             weiboSDKCls:[WeiboSDK class]];
    
    //连接微信
    [ShareSDK connectWeChatWithAppId:WECHAT_SHARE_KEY wechatCls:[WXApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
}

#pragma mark-openurl

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:WECHAT_PAY_KEY]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [ShareSDK handleOpenURL:url wxDelegate:self];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            
        }];
        return YES;
    }
    
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:WECHAT_PAY_KEY]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
    
    return YES;
    
}

//iOS 9以上的回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            
        }];
        return YES;
    }

    
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:WECHAT_PAY_KEY]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [ShareSDK handleOpenURL:url sourceApplication:@"" annotation:@"" wxDelegate:self];
    }
    
    return YES;
}

/**
 微信回调
 */
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        
        switch (resp.errCode) {
            case WXSuccess:
                //支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PAY_BACK" object:nil];
                break;
            default:
                 [self.window.rootViewController presentFailureTips:@"支付失败"];
//                [SVProgressHUD showErrorWithStatus:@"支付失败"];
                
                break;
        }
    }
    
}

#pragma mark - 全局提示信息

-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer
{
    [AJNotificationView showNoticeInView:self.window
                                    type:AJNotificationTypeBlue
                                   title:msg
                         linedBackground:AJLinedBackgroundTypeStatic
                               hideAfter:timer
                                response:^{
                                    // NSLog(@"Response block");
                                }];
}

-(void)showNoticeMsg:(NSString *)msg WithInterval:(float)timer Block:(void (^)(void))response
{
    [AJNotificationView showNoticeInView:self.window
                                    type:AJNotificationTypeBlue
                                   title:msg
                         linedBackground:AJLinedBackgroundTypeAnimated
                               hideAfter:timer offset:0.0f delay:0.0f detailDisclosure:NO
                                response:response];
}


#pragma mark- 未读消息

//设置tabbar下标
-(void)setBadgeValue:(int)bageValue foeIndex:(NSInteger)index{
    if ([[self.tabController viewControllers] count]>3) {
       
        UIViewController *badgeController =[[self.tabController viewControllers] objectAtIndex:index];
        if (badgeController) {
            if (bageValue>0) {
                [badgeController rdv_tabBarItem].badgeValue =[NSString stringWithFormat:@"%i",(int)bageValue];
            }
            else{
                [badgeController rdv_tabBarItem].badgeValue =@"";
            }
            
        }
    }
}


#pragma mark - 获取权限以及提交开门纪录

- (void)getAndCommitDoorLimit{
    
    UserModel *user = [LocalData shareInstance].getUserAccount;
    if (user) {
        [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
        //1.获取权限
        [self getDoorLimit];
        //2.提交纪录
        [self commitDoorLog];
    }
}

//1.获取权限
- (void)getDoorLimit{
    
    //两个小时获取一次门禁
    //    NSDate *nowDate = [NSDate date];
    //    NSDate *beginDate = [LocalDataAccessor getBeginDate];
    //    NSLog(@"%ld",(long)[nowDate  hoursAfterDate:beginDate]);
    //    if ([nowDate hoursAfterDate:beginDate] >= 2){
    
    BleLimitAPI *bleApi = [[BleLimitAPI alloc] init];
    [bleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [[result objectForKey:@"result"] intValue] == 0){
            NSArray *doors = [result objectForKey:@"Doors"];
            [LocalData updateDoorLimit:doors];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        NSString *code = [NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode];
        NSLog(@"%@",code);
    }];
}

//2.提交纪录
- (void)commitDoorLog{
    
    NSArray *doorLog = [LocalData getOpenDoorLog];
    
    if (doorLog){
        if (doorLog.count > 20){
            //超过20个则截取前20个元素
            NSRange range = NSMakeRange(0, 20);
            NSArray *logs = [doorLog subarrayWithRange:range];
            BleLimitAPI *bleApi = [[BleLimitAPI alloc] initWithLog:logs];
            [bleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = request.responseJSONObject;
                if (![ISNull isNilOfSender:result] && [[result objectForKey:@"result"] intValue] == 0){
                    //清除已上传，继续未上传
                    [LocalData removeOpenDoorLog:logs];
                    [self commitDoorLog];
                }
            } failure:^(__kindof YTKBaseRequest *request) {
                NSString *code = [NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode];
                NSLog(@"%@",code);
            }];
        }else if (doorLog.count != 0){
            BleLimitAPI *bleApi = [[BleLimitAPI alloc] initWithLog:doorLog];
            [bleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = request.responseJSONObject;
                if (![ISNull isNilOfSender:result] && [[result objectForKey:@"result"] intValue] == 0){
                    //清除已上传，继续未上传
                    [LocalData removeOpenDoorLog:doorLog];
                    [self commitDoorLog];
                }
            } failure:^(__kindof YTKBaseRequest *request) {
                NSString *code = [NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode];
                NSLog(@"%@",code);
            }];
        }
    }
}

@end
