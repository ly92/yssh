//
//  HomeViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/4/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HomeViewController.h"
#import "WeatherCell.h"
#import "HomeServiceCell.h"
#import "HomeActivityCell.h"
#import "MemberCardCell.h"
#import "MemberCardDetailViewController.h"
#import "NoMemberCardDetailViewController.h"
#import "WebViewController.h"
//#import "RealReachability.h"
#import "ComingSoonController.h"
#import "ScanActivity.h"
#import "SearchMemberCardController.h"
#import "MsgAdViewController.h"
#import "SearchCommunityController.h"
#import "HandlePush.h"
#import "NoMemberCardCell.h"
#import <KJARLib/KJARSCanViewController.h>

static NSString *weatherIdentifier = @"WeatherCell";
static NSString *serviceIdentifier = @"HomeServiceCell";
static NSString *activityIdentifier = @"HomeActivityCell";
static NSString *memberCardIdentifier = @"MemberCardCell";
static NSString *noMemberCardIdentifier = @"NoMemberCardCell";

#define headViewH (SCREENWIDTH * 350 / 750)

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,HomeServiceCellDelegate,HomeActivityCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) NSMutableArray * cellIdentifiers; // 用到的cellIdentifier

@property (nonatomic, strong) NSMutableArray *adArr;
@property (nonatomic, strong) NSMutableArray *functionArr;

@property (nonatomic, strong) LimitActivityModel *limitActivityModel;

@property (nonatomic, strong) NSMutableArray *memberCardArr;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *arrowDownIV;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation HomeViewController

+(instancetype)spawn{
    return [HomeViewController loadFromStoryBoard:@"Home"];
    
}

#pragma mark-生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.view.backgroundColor = VIEW_BG_COLOR;

    //导航栏
    [self setNavigationBar];
    [self registerNoti];
    
    self.cellIdentifiers = [NSMutableArray array];
    self.adArr = [NSMutableArray array];
    self.functionArr = [NSMutableArray array];
    self.memberCardArr = [NSMutableArray array];
    

    [@[weatherIdentifier, serviceIdentifier,activityIdentifier, memberCardIdentifier,noMemberCardIdentifier] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tv registerNib:obj];
    }];
        
    [self setData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ([AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:NO animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"首页";
    
    self.navigationItem.leftBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"d1_search"] handler:^(id sender) {
        
        SearchMemberCardController *searchMember = [SearchMemberCardController spawn];
        
        [self.navigationController pushViewController:searchMember animated:YES];
        
    }];
    
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"home_scan"] handler:^(id sender) {
        //AR扫描
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];//隐藏tabbar
        KJARSCanViewController* scanView = [[KJARSCanViewController alloc] init];
        [scanView SetAccountKey:@"AP9552c0c4cf9a45f3abff78e8cb7f9ebe" : @"981699a775474c189cfd8a249c5be311"];
        [self.navigationController pushViewController:scanView animated:YES];
        
        //20180403ly 之前的扫描
//        ScanActivity *scan = [ScanActivity loadFromNib];
//        scan.whenGetScan = ^(NSString *scanValue){
//        };
//        [self.navigationController pushViewController:scan animated:YES];
        
    }];
    
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 20, SCREENWIDTH-120, 40)];
    
    self.titleView.centerX = self.view.center.x;
    
    
    self.titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.titleView.frame)-20, 40)];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.font = [UIFont systemFontOfSize:17];
    self.titleLbl.textColor = NAV_TEXTCOLOR;
    
    Community *community = [STICache.global objectForKey:@"selected_community"];
    if (community) {
        self.titleLbl.text = community.name;
    }
    
    CGSize titlesize = [self.titleLbl sizeThatFits:CGSizeMake(MAXFLOAT, 40)];
    [self.titleLbl setAdjustsFontSizeToFitWidth:YES];
    self.titleLbl.w = titlesize.width;
    
    if (titlesize.width > SCREENWIDTH-140) {
        self.titleLbl.w = SCREENWIDTH - 140;
    }
    
    if (titlesize.width == 0) {
        self.arrowDownIV.hidden = YES;
    }else{
        self.arrowDownIV.hidden = NO;
        
    }
    
    self.titleView.w = self.titleLbl.w + 20;
    
    if (self.titleView.w > SCREENWIDTH-120) {
        self.titleView.w = SCREENWIDTH-120;
    }
    [self.titleView addSubview:self.titleLbl];
    
    self.arrowDownIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLbl.frame), 12, 15,15)];
    self.arrowDownIV.image = [UIImage imageNamed:@"home_nav_DownArrow"];
    [self.titleView addSubview:self.arrowDownIV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCommunity)];
    [self.titleView addGestureRecognizer:tap];
    
    self.navigationItem.titleView = self.titleView;

}

//选择小区
-(void)clickCommunity{
    SearchCommunityController *searchCommunity = [SearchCommunityController spawn];
    
    [self.navigationController pushViewController:searchCommunity animated:YES];
}

#pragma maek-register noti
-(void)registerNoti{
    
    //从后台进入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeGround) name:@"ENTERFOREGROUND" object:nil];
    
    //添加会员卡成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMemberCardSuccess) name:@"ADDMEMBERCARDSUCCESS" object:nil];
    
    //选择小区
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCommunity:) name:@"SELECTCOMMUNITY" object:nil];
    
    //使用余额支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMyMemberCardData) name:@"RECHARGE_PAY_SUCCESS" object:nil];
    
    //推送信息到达
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushMsg:) name:@"refreshHomeBadgle" object:nil];
    
    //根据公告信息切换小区
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommunityData) name:@"LOADSELEDTCUMMUNITY" object:nil];
    
    // 开门成功切换小区
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDoorChangeCommunity:) name:@"openDoorCommunity" object:nil];
    
    //删除会员卡
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMyMemberCardData) name:@"deleteMember" object:nil];
    
    //商户为我充值,商户给我扣款
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadMyMemberCardData) name:@"chargeMoney" object:nil];
    
    //积分充值,积分消费
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadMyMemberCardData) name:@"pointsTransaction" object:nil];

}


-(void)enterForeGround{
    [self setData];
}

//添加会员卡成功
-(void)addMemberCardSuccess{
    [self loadMyMemberCardData];
}

-(void)selectCommunity:(NSNotification *)noti{
    Community *community = (Community *)noti.object;
    
    [STICache.global setObject:community forKey:@"selected_community"];
    [self loadCommunityData];
    
}


-(void)openDoorChangeCommunity:(NSNotification *)noti{
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
                   
                    id remoteCommunity = [result objectForKey:@"community"];
                    if ([remoteCommunity isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *firstCommunity = (NSDictionary *)remoteCommunity;
                        
                        Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                        
                        [STICache.global setObject:community forKey:@"selected_community"];
                        [self loadCommunityData];
                       
                    }
                    else if ([remoteCommunity isKindOfClass:[NSArray class]]){
                        
                        NSArray *remotCommunity = (NSArray *)remoteCommunity;
                        
                        if ([remotCommunity count]>0) {
                            NSDictionary *firstCommunity = [remotCommunity objectAtIndex:0];
                            Community *community = [Community mj_objectWithKeyValues:firstCommunity];
                            
                            [STICache.global setObject:community forKey:@"selected_community"];
                            [self loadCommunityData];
                            
                            
                        }
                    }
                    
                    
                }
            } failure:^(__kindof YTKBaseRequest *request) {
                
                
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];
            
            
        }
        
        
    }

}

-(void)handlePushMsg:(id)sender
{
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$ handlePushMsg");
    
    //根据气泡数量重新排序会员卡,如果现在没有加载数据，则进行排序
//    if (self.loadingCard==NO) {
        NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$ sortCardByPushMsgCount begin");
//        if (_hasCard) {
            [self sortCardByPushMsgCount];
//        }
//    }
    
    //读取消息中心未读数量
    [self updateMessageCenterBubble];
    
    //获取所有优惠券气泡数
    [self fetchAllCouponPushBubble];
}

/*
*  根据气泡数量重新排序会员卡
*/
-(void)sortCardByPushMsgCount
{
    if ([[LocalData shareInstance]isLogin]) {
        //重新排序
        if (self.tv) {
            
            //推送到来，数据根据气泡数重新排序
            if (self.memberCardArr&&self.memberCardArr.count>0) {
                
                for (MemberCardModel *card in self.memberCardArr) {
                    
                    int count1 = [LocalData getClickCountWithBid:card.bid];
                    
                    card.clickCount = [NSString stringWithFormat:@"%d",count1];
                    int count = [[LocalizePush shareLocalizePush] getHomeBadgle:card.cardid];
                    
                    card.pushcount = [NSString stringWithFormat:@"%d",count];
                    
                    
                    if ([card.pushcount intValue] != 0) {
                        
                    }
                }
                
                if (self.memberCardArr.count > 0) {
                    NSSortDescriptor *descriptor1=[NSSortDescriptor sortDescriptorWithKey:@"clickCount" ascending:NO];
                    NSSortDescriptor *descriptor2=[NSSortDescriptor sortDescriptorWithKey:@"pushcount" ascending:NO];
                    
                    NSArray *array=@[descriptor2,descriptor1];
                    
                    NSArray *sortArray=[NSArray arrayWithArray:array];
                    
                    [self.memberCardArr sortUsingDescriptors:sortArray];
                    
                }
                
                [self.tv reloadData];
                
            }
            
        }
    }
}

/**
 *  更新消息中心红点
 */
- (void)updateMessageCenterBubble
{
    if ([[LocalData shareInstance]isLogin]==NO) {
        return;
    }
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    GetMessageUnreadAPI *getMessageUnreadApi = [[GetMessageUnreadAPI alloc]init];
    
    [getMessageUnreadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [self dismissTips];
            if (![ISNull isNilOfSender:[result objectForKey:@"unreadcount"]]) {
                
                int unreadcount = [[result objectForKey:@"unreadcount"] intValue];
                if (unreadcount > 0) {
                    [[AppDelegate sharedAppDelegate] setBadgeValue:unreadcount foeIndex:1];
                }else{
                    [[AppDelegate sharedAppDelegate]setBadgeValue:0 foeIndex:1];
                }
            }
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
            }else{
                [self presentFailureTips:result[@"reason"]];
            }

//             [self presentFailureTips:result[@"reason"]];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}

#pragma mark - 所有优惠券推送处理
//优惠券推送获取入口
- (void)fetchAllCouponPushBubble
{
    int amount = [[LocalizePush shareLocalizePush] getSettingBadgleWithCoupon];
    [[AppDelegate sharedAppDelegate] setBadgeValue:amount foeIndex:3];
    
}

#pragma mark-加载数据

-(void)setData{
    if ([[LocalData shareInstance] isLogin]){
        
        //会员卡数据
        [self loadMyMemberCardData];
        //加载小区
        [self loadCommunityData];
        //功能栏数据
        [self loadFunction];
        
        [HandlePush fetchPushAmounts];
        
    }
}


#pragma mark-加载小区数据
//加载小区数据
-(void)loadCommunityData{
    
    //判断是否有缓存
    if ([STICache.global objectForKey:@"selected_community"]) {
        //显示当前小区
        [self handelSelectedCommunity];
        //加载小区公告和广告
        [self loadNotice];
        
    }else{
        //没有缓存，加载授权小区
        [self loadMyOwnCommunityList];
    }
    
}

//加载已授权小区
- (void)loadMyOwnCommunityList{
    
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    if (!user) {
        return;
    }
    
     [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    AuthoriseCommunityAPI *authoriseCommunityApi = [AuthoriseCommunityAPI alloc];
    
    [authoriseCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        
        AuthoriseCommunityResultModel *result = [AuthoriseCommunityResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            
            if (![ISNull isNilOfSender:result.list]) {
                Community *community = result.list[0];
                
                [STICache.global setObject:community forKey:@"selected_community"];
                
                //处理默认小区
                [self handelSelectedCommunity];
                
                [self loadNotice];
            }else{
                [self loadNearCommunity];
            }
        }else{
            //加载附近小区
            [self loadNearCommunity];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        //加载附近小区
        [self loadNearCommunity];
        
    }];
}
//加载附近小区
-(void)loadNearCommunity{
    //获取当前位置
    Location *location = [AppLocation sharedInstance].location;
    NSString * lon = [NSString stringWithFormat:@"%@",location.lon];
    NSString * lat = [NSString stringWithFormat:@"%@",location.lat];
    
    
     [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    NearCommunityAPI *nearCommunityApi = [[NearCommunityAPI alloc]initWithLongitude:lon latitude:lat];
    
    [nearCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSDictionary *nearCommunity = result[@"community"];
            
            if (![ISNull isNilOfSender:nearCommunity]) {
                Community *community = [Community mj_objectWithKeyValues:nearCommunity];
                [STICache.global setObject:community forKey:@"selected_community"];
                [self handelSelectedCommunity];
                
                [self loadNotice];
            }
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
            }else{
                [self presentFailureTips:result[@"reason"]];
            }

//             [self presentFailureTips:result[@"reason"]];
        }

        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}

//处理默认选择的小区
-(void)handelSelectedCommunity
{
    
   Community *selectedCommunity = [STICache.global objectForKey:@"selected_community"];
    
    
    //存在已选择的，则判断
    if (selectedCommunity) {
        
        [self setNavigationBar];
        
        
        //切换小区通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMECHANGECOMMUNITY" object:nil];
        
    }
    
    
}

#pragma mark-小区广告和活动广告
-(void)loadNotice{
   
    Community *community  = [STICache.global objectForKey:@"selected_community"];
    if (community) {
        NSString *bid = community.bid;
        if (!bid) {
            return;
        }
        
         [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
         LoadNoticeAPI *loadNoticeApi = [[LoadNoticeAPI alloc]initWithOwnerId:bid];
        
        [loadNoticeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"COMMUNITYCHANGE" object:bid];
            
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {

                 // 小区广告
                NSArray *adv = result[@"adv"];
                [self.adArr removeAllObjects];
                for (NSDictionary *dic in adv) {
                    [self.adArr addObject:[AdModel mj_objectWithKeyValues:dic]];
                }

                //活动
                id dadv = result[@"2ndadv"];
                
                if ([ISNull isNilOfSender:dadv]) {
                    
                }else{
                    
                    if ([dadv isKindOfClass:[NSString class]]) {
                        NSString *adv = (NSString *)dadv;
                        if ([adv integerValue] == 0) {
                            
                        }
                    }else if([dadv isKindOfClass:[NSDictionary class]]){
                        
                        NSDictionary *ndadv = (NSDictionary *)dadv;
                        self.limitActivityModel = [LimitActivityModel mj_objectWithKeyValues:ndadv];
                        if (self.limitActivityModel) {
                             [self.tv reloadData];
                        }else{
                        }
                    }
                }
                [self.tv reloadData];
            }else{
                if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                    [[AppDelegate sharedAppDelegate]showLogin];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
                }else{
                    [self presentFailureTips:result[@"reason"]];
                }

//                 [self presentFailureTips:result[@"reason"]];
            }

            
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }];
    }
    
   
}

#pragma mark-function
-(void)loadFunction{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    FunctionAPI *functionApi = [[FunctionAPI alloc]initWithLimit:@"4"];
    functionApi.functionType = HOME_FUNCTION;
    
    [functionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self.functionArr removeAllObjects];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                [self.functionArr addObject:[FunctionModel mj_objectWithKeyValues:dic]];
            }
            [self.tv reloadData];
            
        }else{
            if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
            }else{
                [self presentFailureTips:result[@"reason"]];
            }

//             [self presentFailureTips:result[@"reason"]];
        }

        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}


#pragma mark-我的会员卡列表
-(void)loadMyMemberCardData{
     [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    MemberCardAPI *memberCardApi = [MemberCardAPI alloc];
    
    [memberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self.memberCardArr removeAllObjects];
        
        MemberCardResultModel *result = [MemberCardResultModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            
            self.memberCardArr = [NSMutableArray arrayWithArray:result.CardList];
            [self.tv reloadData];
            
        }else{
            if ([result.result intValue] == 9001 || [result.result intValue] == 9006 ||[result.result intValue] == 16||[result.result intValue] == 9004) {
                [[AppDelegate sharedAppDelegate]showLogin];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result.reason];
            }else{
                [self presentFailureTips:result.reason];

            }

//             [self presentFailureTips:result.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];

        
    }];
}


#pragma mark-tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self.cellIdentifiers removeAllObjects];
    
    [self.cellIdentifiers addObject:weatherIdentifier];
    
    if (self.functionArr.count > 0) {
        [self.cellIdentifiers addObject:serviceIdentifier];
    }
    
    if (self.limitActivityModel) {
        [self.cellIdentifiers addObject:activityIdentifier];
    }
    
    [self.cellIdentifiers addObject:memberCardIdentifier];
    
    return self.cellIdentifiers.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     NSString * identifier = self.cellIdentifiers[section];
    if ([identifier isEqualToString:memberCardIdentifier]) {
        //会员卡列表
        
        if(self.memberCardArr.count > 0){
            return self.memberCardArr.count;
        }else{
            return 1;
        }
    }else{
        //天气，function，活动广告
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = self.cellIdentifiers[indexPath.section];
    
    UITableViewCell * cell = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([identifier isEqualToString:weatherIdentifier]) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WeatherCell *weatherCell = (WeatherCell *)cell;
        
        weatherCell.selectionStyle = UITableViewCellSelectionStyleNone;
        weatherCell.msgDetail = ^(NSString *imgUrl,NSString *title,NSString *time,NSString *content,NSString *outerurl){
            
            if ([outerurl trim].length > 0) {
                WebViewController *web = [WebViewController spawn];
                web.webURL = outerurl;
                web.title = title;
                [self.navigationController pushViewController:web animated:YES];
            }
            else {
                MsgAdViewController *msg= [[MsgAdViewController alloc] initWithImgUrl:imgUrl Title:title Time:time Content:content];
                [self.navigationController pushViewController:msg animated:YES];
            }
        };
        weatherCell.data = self.adArr;
        
        return weatherCell;
    }else if ([identifier isEqualToString:serviceIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        HomeServiceCell *serviceCell = (HomeServiceCell *)cell;
        serviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        serviceCell.delegate = self;
        serviceCell.data = self.functionArr;
        
        return serviceCell;
    }else if ([identifier isEqualToString:activityIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HomeActivityCell *activityCell = (HomeActivityCell *)cell;
        activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        activityCell.delegate = self;
        activityCell.data = self.limitActivityModel;
        
        return activityCell;
        
    }else if ([identifier isEqualToString:memberCardIdentifier]) {
        
        if (self.memberCardArr.count > 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MemberCardCell *memberCardCell = (MemberCardCell *)cell;
            
            memberCardCell.contentView.left = 0;
            memberCardCell.contentView.width = SCREENWIDTH;
            
            
            if (self.memberCardArr.count > indexPath.row) {
                memberCardCell.data = self.memberCardArr[indexPath.row];
            }
            
            return memberCardCell;
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:noMemberCardIdentifier forIndexPath:indexPath];
            NoMemberCardCell *noMemberCardCell = (NoMemberCardCell *)cell;
            
            return noMemberCardCell;
            
        }
        
       
    }
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString * identifier = self.cellIdentifiers[indexPath.section];
    
    if ([identifier isEqualToString:weatherIdentifier]){
        return headViewH;
    }else if ([identifier isEqualToString:serviceIdentifier]){
        if (self.functionArr.count <= 4) {
            return ((SCREENWIDTH-16)/4.0);
        }else if(self.functionArr.count >= 5){
            return ((SCREENWIDTH-16)/4.0)*2;
        }
    }else if ([identifier isEqualToString:activityIdentifier]){
        return [HomeActivityCell heightForHomeActivityWithDataCount:self.limitActivityModel.attr.count cardStyle:self.limitActivityModel.style];
    }
    else if ([identifier isEqualToString:memberCardIdentifier]) {
        return 130;
    }
    return 0;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
     NSString * identifier = self.cellIdentifiers[section];
    
    if ([identifier isEqualToString:memberCardIdentifier]) {
        return 28;
    }
    if ([identifier isEqualToString:weatherIdentifier]) {
        return 0;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString * identifier = self.cellIdentifiers[section];
    
    
    if([identifier isEqualToString:memberCardIdentifier]){
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 28)];
        sectionView.clipsToBounds = YES;
        sectionView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        UILabel *sectionTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, SCREENWIDTH-20, 20)];
        sectionTitleLbl.backgroundColor = [UIColor clearColor];
        sectionTitleLbl.textColor = HOMEMEMBERCARDCOLOR;
        sectionTitleLbl.font = [UIFont systemFontOfSize:14];
        if (self.memberCardArr.count > 0) {
            sectionTitleLbl.text = @"我的专属服务";
        }else{
            sectionTitleLbl.text = @"推荐专属服务";
        }
    
        [sectionView addSubview:sectionTitleLbl];
        return sectionView;
    }else{
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 5)];
        sectionView.clipsToBounds = YES;
        sectionView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        return sectionView;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * identifier = self.cellIdentifiers[indexPath.section];
    if ([identifier isEqualToString:memberCardIdentifier]) {
        if (self.memberCardArr.count > 0) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
    
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        self.selectedIndexPath = indexPath;
//        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
//}
//
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex ==1) {
//        //删除会员卡
//        MemberCardModel *memberCard = self.memberCardArr[self.selectedIndexPath.row];
//        [self presentLoadingTips:nil];
//
//         [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
//        DeleteMemberCardAPI *deleteMemberCardApi = [[DeleteMemberCardAPI alloc]initWithCardID:memberCard.cardid];
//        [deleteMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
//            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
//                [self dismissTips];
//                
//                [self.memberCardArr removeObjectAtIndex:self.selectedIndexPath.row];
//                
//                if (self.memberCardArr.count == 0) {
//                    
//                    [self loadMyMemberCardData];
//                }
//                
//                if (self.memberCardArr.count > 0) {
//                    [self.tv deleteRowAtIndexPath:self.selectedIndexPath withRowAnimation:UITableViewRowAnimationRight];
//                }
//                
//                 
//            }else{
//                 [self presentFailureTips:result[@"reason"]];
//            }
//
//        } failure:^(__kindof YTKBaseRequest *request) {
//            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
//        }];
//        
//       
//    }
//}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MemberCardModel *memberCard = self.memberCardArr[indexPath.row];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [UIAlertView bk_showAlertViewWithTitle:@"是否确认删除" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //删除会员卡
                [self presentLoadingTips:nil];
                [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                DeleteMemberCardAPI *deleteMemberCardApi = [[DeleteMemberCardAPI alloc]initWithCardID:memberCard.cardid];
                [deleteMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                    NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                    if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                        [self dismissTips];
                        
                        //删除会员成功
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMemberSuccess" object:nil];
                        
                        [self.memberCardArr removeObjectAtIndex:indexPath.row];
                        if (self.memberCardArr.count > 0) {
                            
                            [self.tv deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationRight];
                            
                        }
                        if (self.memberCardArr.count ==0) {
                            [self loadMyMemberCardData];
                        }
                        
                        
                    }else{
                        if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                            [[AppDelegate sharedAppDelegate]showLogin];
                            [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
                        }else{
                            [self presentFailureTips:result[@"reason"]];
                        }
                        
                    }
                    
                } failure:^(__kindof YTKBaseRequest *request) {
                    
                    if (request.responseStatusCode == 0) {
                        [self presentFailureTips:@"网络不可用，请检查网络链接"];
                    }else{
                        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }
                }];
            }
        }];
        
    }];
    
    
    
    UITableViewRowAction *editAction = nil;
    
    if ([memberCard.isfav intValue] == 0) {
        
        //添加
        editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [UIAlertView bk_showAlertViewWithTitle:@"是否确认收藏" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                    MemberCardModel *memberCard = self.memberCardArr[indexPath.row];
                    // 收藏会员卡
                    [self presentLoadingTips:nil];
                    
                    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                    
                    OperateMemberCardAPI *addMemberCardApi = [[OperateMemberCardAPI alloc]initWithCardId:memberCard.cardid cardType:@"2"];
                    addMemberCardApi.operateMemberCardType = collectMemberCardType;
                    [addMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self dismissTips];
                        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                            memberCard.isfav = @"1";
                            
                            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.memberCardArr];
                            [arr replaceObjectAtIndex:indexPath.row withObject:memberCard];
                            self.memberCardArr = arr;
                            
                            [self.tv reloadData];
                            
                        }else{
                            [self presentFailureTips:result[@"message"]];
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }];
                    
                    
                    
                }
            }];
            
        }];
    }
    else {
        //移除
        editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            MemberCardModel *memberCard = self.memberCardArr[indexPath.row];
            [UIAlertView bk_showAlertViewWithTitle:@"是否确认取消收藏" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                    // 收藏会员卡
                    [self presentLoadingTips:nil];
                    
                    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                    
                    OperateMemberCardAPI *addMemberCardApi = [[OperateMemberCardAPI alloc]initWithCardId:memberCard.cardid cardType:@"2"];
                    addMemberCardApi.operateMemberCardType = cancnelCollectMemberCardType;
                    [addMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self dismissTips];
                        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                            
                            memberCard.isfav = @"0";
                            [self.memberCardArr replaceObjectAtIndex:indexPath.row withObject:memberCard];
                            [self.tv reloadData];
                            
                        }else{
                            [self presentFailureTips:result[@"message"]];
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }];
                }
            }];
            
        }];
    }
    
    return @[deleteAction,editAction];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = self.cellIdentifiers[indexPath.section];
    if ([identifier isEqualToString:weatherIdentifier]) {
        //天气
        
    }else if ([identifier isEqualToString:serviceIdentifier]){
         //功能栏
        
    }else if ([identifier isEqualToString:activityIdentifier]){
        //活动
        
    }else if ([identifier isEqualToString:memberCardIdentifier]) {
        //会员卡列表
        if (self.memberCardArr.count == 0){
            SearchMemberCardController *searchMember = [SearchMemberCardController spawn];
            
            [self.navigationController pushViewController:searchMember animated:YES];
        }
        else if (self.memberCardArr.count > indexPath.row) {
            
            MemberCardModel *memberCard = self.memberCardArr[indexPath.row];
            [self goToCardDetail:memberCard];
            
        }
    }
   
    
}
-(void)goToCardDetail:(MemberCardModel *)surrounding{
    //饭票商城（cardtype ==1）、地方饭票支付（cardtype == 2）
    if (surrounding) {
        
        int count=[LocalData getClickCountWithBid:surrounding.bid];
        count+=1;
        NSDictionary *homeCard = [NSDictionary dictionaryWithObjectsAndKeys:surrounding.bid,@"bid",[NSString stringWithFormat:@"%d",count],@"clickCount", nil];
        [LocalData updateHomeCard:homeCard];
        
        NSString *cardnum = surrounding.cardnum;
        NSString *cardtype = surrounding.cardtype;
        NSString *extra = surrounding.extra;
        
        
        if (([cardtype intValue] == 1 || [cardtype intValue] == 2) && cardtype.length > 0){
            //饭票商城   //地方饭票
            if (extra&&[extra trim].length>0) {
                if ([[LocalData shareInstance] isLogin]) {
                    
                    UserModel *user = [[LocalData shareInstance]getUserAccount];
                    
                    NSString *token = [LocalData getDeviceToken];
                    if (user&&token) {
                        if ([surrounding.cardtype intValue] == 1){
                            NSString *urlstring = [NSString stringWithFormat:@"%@%@&token=%@",[surrounding.extra trim],user.cid,token];
                            if (urlstring) {
                                
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.title = @"饭票商城";
                                [self.navigationController pushViewController:web animated:YES];
                                
                                
                            }
                        }else if ([surrounding.cardtype intValue] == 2){
                            //surrounding.extra=http://colour.kakatool.cn/localbonus/shop/index?cid=$cid$&token=$kkttoken$&bid=$bid$&communityid=    $communityid$
                            NSString *urlstring = surrounding.extra;
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:surrounding.cid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$kkttoken$" withString:[token urlEncode]];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$bid$" withString:surrounding.bid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$communityid$" withString:surrounding.bid];
                            
                            if (urlstring) {
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.title = surrounding.cardname;
                                [self.navigationController pushViewController:web animated:YES];
                                
                              
                            }
                        }
                    }
                }
            }
            
        }else{
            //普通卡
            if ([cardnum intValue] != 0){
                
                MemberCardDetailViewController *memberCardDetail = [MemberCardDetailViewController spawn];
                
                memberCardDetail.bid = surrounding.bid;
                memberCardDetail.cardId = surrounding.cardid;
                memberCardDetail.cardType = surrounding.cardtypes;
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = surrounding.bid;
                noMemberCardDetail.reloadData = ^{
                    [self.memberCardArr removeAllObjects];
                    [self loadMyMemberCardData];
                };
                
                [self.navigationController pushViewController:noMemberCardDetail animated:YES];
                
            }
            
        }
    }
}

#pragma mark-HomeServiceCellDelegate
-(void)functionDidSelectCell:(id)data{
    FunctionModel *functionModel = (FunctionModel *)data;
    if (functionModel) {
        NSString *act = functionModel.actiontype;
        if ([act isEqualToString:@"1"]) {
            NSString *proto = functionModel.actionios;
            if (![ISNull isNilOfSender:proto]) {
                //跳转到原生界面
                @try {
                    
                    id myObj = [NSClassFromString(proto) spawn];
                    
                    if ([myObj isKindOfClass:[UIViewController class]]) {
                        
                    
                        UIViewController *con = (UIViewController *)myObj;
                        
                      
                        con.data = functionModel.name;
                        
                        [self.navigationController pushViewController:con animated:YES];
                        
                       
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:@"该功能暂时未开放"];
                        
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }else{
                //跳转到未建设界面
                ComingSoonController *comingSoon = [ComingSoonController spawn];
                
                comingSoon.data = functionModel.name;
                
                [self.navigationController pushViewController:comingSoon animated:YES];
            }
        }else if ([act isEqualToString:@"0"]){
//            RealReachability *reachability = [RealReachability sharedInstance];
//            if ([reachability currentReachabilityStatus]){
                NSString *outerurl = functionModel.actionurl;
                 outerurl =  [WebViewController pingUrlWithUrl:outerurl pushCmd:nil];
                if ([outerurl trim].length>0) {
                    
                    WebViewController *web = [WebViewController spawn];
                    web.webURL = outerurl;
                    web.title = functionModel.name;
                    [self.navigationController pushViewController:web animated:YES];
                    
                }
//            }
        }else if ([act isEqualToString:@"3"]){
            NSString *proto = functionModel.actionios;
            
            //跳转到特定卡详情
            if([proto isEqualToString:@"JumpBizInfo"]){
                
                id extra = functionModel.extra;
                
                if ([extra isKindOfClass:[NSString class]]) {
                    
                    NSString *extraString = (NSString *)extra;
                    NSDictionary *data =(NSDictionary *) [extraString mj_JSONObject];
                    
                    if (![ISNull isNilOfSender:data]) {
                        NSString *bid = [data objectForKey:@"bid"];
                        if (bid) {
                            [self JumpBizInfo:bid];
                        }
                    }
                    
                }
                else if ([extra isKindOfClass:[NSDictionary class]]){
                    NSDictionary *data = (NSDictionary *)extra;
                    
                    if (![ISNull isNilOfSender:data]) {
                        NSString *bid = [data objectForKey:@"bid"];
                        if (bid) {
                            [self JumpBizInfo:bid];
                        }
                    }
                    
                }
                
            }
            
        }
    }
}

//跳转到会员卡
-(void)JumpBizInfo:(NSString *)bid
{
    
    UserModel *user=[[LocalData shareInstance]getUserAccount];
    if (!user) {
        return;
    }
    
    NSString *cid = user.cid;
    
    if (cid&&bid) {
        
        [self presentLoadingTips:nil];
        
        [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
        GetMemberCardAPI *getMemberCardApi =[[GetMemberCardAPI alloc]initWithBid:bid];
        [getMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                
                NSDictionary *info = [result objectForKey:@"info"];
                
                [self functionGoToCardDetail:info];
                
                
            }else{
                [self presentFailureTips:result[@"reason"]];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }];
        
    }
    
}


-(void)functionGoToCardDetail:(NSDictionary *)info{
    //饭票商城（cardtype ==1）、地方饭票支付（cardtype == 2）
    
    
    if (![ISNull isNilOfSender:info]) {
        NSString *cardnum = [info objectForKey:@"cardnum"];
        
        NSString *bid = [info objectForKey:@"bid"];
        
        NSString *cardtype = [[info objectForKey:@"bizcard"] objectForKey:@"cardtype"];
        NSString *extra = [[info objectForKey:@"bizcard"] objectForKey:@"extra"];
        
        NSString *cardid = [[info objectForKey:@"bizcard"] objectForKey:@"cardid"];
        
        NSString *cardname = [[info objectForKey:@"bizcard"] objectForKey:@"cardname"];
        
        
        if (([cardtype intValue] == 1 || [cardtype intValue] == 2) && cardtype.length > 0){
            //饭票商城   //地方饭票
            if (extra&&[extra trim].length>0) {
                if ([[LocalData shareInstance] isLogin]) {
                    
                    UserModel *user = [[LocalData shareInstance]getUserAccount];
                    
                    NSString *token = [LocalData getDeviceToken];
                    if (user&&token) {
                        if ([cardtype intValue] == 1){
                            NSString *urlstring = [NSString stringWithFormat:@"%@%@&token=%@",[extra trim],user.cid,token];
                            if (urlstring) {
                                
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.title = @"饭票商城";
                                [self.navigationController pushViewController:web animated:YES];
                                
                                
                            }
                        }else if ([cardtype intValue] == 2){
                            //surrounding.extra=http://colour.kakatool.cn/localbonus/shop/index?cid=$cid$&token=$kkttoken$&bid=$bid$&communityid=    $communityid$
                            UserModel *user=[[LocalData shareInstance]getUserAccount];
                            NSString *urlstring = extra;
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:user.cid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$kkttoken$" withString:[token urlEncode]];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$bid$" withString:bid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$communityid$" withString:bid];
                            
                            if (urlstring) {
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.title = cardname;
                                [self.navigationController pushViewController:web animated:YES];
                                
                                
                            }
                        }
                    }
                }
            }
            
        }else{
            //普通卡
            if ([cardnum intValue] != 0){
                
                MemberCardDetailViewController *memberCardDetail = [MemberCardDetailViewController spawn];
                
                memberCardDetail.bid = bid;
                memberCardDetail.cardId = cardid;
                memberCardDetail.cardType = @"online";
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = bid;
                noMemberCardDetail.reloadData = ^{
                    
                };
                
                [self.navigationController pushViewController:noMemberCardDetail animated:YES];
                
            }
            
        }
    }
}
#pragma mark-HomeActivityCellDelegate
-(void)activityDidSelectCell:(id)data{
     AttrModel * attr = (AttrModel *)data;
    if (attr) {
        NSString *url = attr.url;
        
        if (url.length == 0) {
            
        }else{
            
            WebViewController *web = [WebViewController spawn];
            web.webURL = url;
            web.title = attr.name;
            [self.navigationController pushViewController:web animated:YES];
           
        }

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
