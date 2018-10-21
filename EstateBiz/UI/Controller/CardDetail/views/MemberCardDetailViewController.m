//
//  MemberCardDetailViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MemberCardDetailViewController.h"

#import "FeedBackViewController.h"
#import "CardOrderListTableViewController.h"
#import "CardSubBranchViewController.h"
#import "SubscribeMerchantViewController.h"
#import "CardPromotionTableViewController.h"
#import "CardPointTableViewController.h"
#import "CardTransactionTableViewController.h"
#import "VoucherTableViewController.h"
#import "RechargeComboListControllerViewController.h"
#import "PopCouponSN.h"

#define CARTOON_B_C_URL @"http://kakatool.com/?B=%@&C=%@"

@interface MemberCardDetailViewController ()<UIAlertViewDelegate>

//控件
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet UIView *containerView;
//frontimgurl
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *shopName;
//类别
@property (weak, nonatomic) IBOutlet UILabel *shopCategory;
@property (weak, nonatomic) IBOutlet UILabel *shopTel;
//@property (weak, nonatomic) IBOutlet UIButton *telButton;

@property (weak, nonatomic) IBOutlet UILabel *shopAddress;

//@property (weak, nonatomic) IBOutlet UIButton *addressButton;

//无分店时，显示成没有其他分店，并且不可点
@property (weak, nonatomic) IBOutlet UILabel *subbranchShopLbl;
//@property (weak, nonatomic) IBOutlet UIButton *subbranchShopbutton;

@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;//余额
@property (weak, nonatomic) IBOutlet UILabel *pointLbl;//积分

//折扣（无折扣时，隐藏该view）
@property (weak, nonatomic) IBOutlet UILabel *discountLbl;

//底部按钮的视图
@property (strong, nonatomic) UIView *bottomView;//

//
//@property (assign, nonatomic) int numOfSecFive;//需要判断是否有折扣
@property (assign, nonatomic) BOOL haveSubBranch;//是否有分店

@property (nonatomic, strong)Card *card;
@property (nonatomic,strong)Bizswitch *bizswitch;
@property (nonatomic, copy) NSString *kakapay;
@property (nonatomic, retain) NSString *enable;//app是否支持在线支付
@property (nonatomic, strong) NSArray *subbranchArray;

@property (nonatomic, strong) NSURL *callUrl;

@property(nonatomic,assign) NSNumber *LonLct;
@property(nonatomic,assign) NSNumber *LatLct;
@property (strong, nonatomic) UIButton *qrCodeBtn;//二维码按钮
@property (nonatomic, strong) PopCouponSN *popView;

@end

@implementation MemberCardDetailViewController

+(instancetype)spawn{
    return [MemberCardDetailViewController loadFromStoryBoard:@"CardDetail"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    [self setNavigationBar];
    
    [self registerNoti];
    
    [self checkKakaPay];
    [self loadData];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    //设置底部按钮栏
    [self prepareBottomView];
    //卡信息：推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgCardAdWithPush:) name:@"PushMsgCardAd" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //去除底部按钮栏
    [self.bottomView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark-navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"详情";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    
    self.qrCodeBtn = [[UIButton alloc] initWithSize:CGSizeMake(30, 30)];
    
    [self.qrCodeBtn setImage:[UIImage imageNamed:@"d1_crcode"] forState:UIControlStateNormal];
    self.qrCodeBtn.hidden = YES;
    [self.qrCodeBtn addTapAction:@selector(showQrcode) forTarget:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.qrCodeBtn];
    
    self.LatLct = [AppLocation sharedInstance].location.lat;
    self.LonLct = [AppLocation sharedInstance].location.lon;
    
    //    [self loadCardInfo];
    
    //    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"d1_crcode"] handler:^(id sender) {
    //
    //
    //
    //    }];
    
}
#pragma mark - 二维码
- (void)showQrcode{
    //会员卡二维码
    
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    NSString *qrcode = [NSString stringWithFormat:CARTOON_B_C_URL,self.card.bid,user.cid];
    
    if (self.popView == nil) {
        self.popView = [[PopCouponSN alloc] initWithParentController:self.parentViewController];
    }
    if (self.popView) {
        [self.popView showCard:qrcode];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.popView];
}
#pragma mark-registerNoti
-(void)registerNoti{
    
    //卡信息：推送
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgCardAdWithPush:) name:@"PushMsgCardAd" object:nil];
    
    
    //使用余额或优惠券支付，刷新余额和优惠券
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RECHARGE_PAY_SUCCESS" object:nil];
    
    //积分，充值推送
    //商户为我充值,商户给我扣款
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"chargeMoney" object:nil];
    
    //积分充值,积分消费
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"pointsTransaction" object:nil];
    
    
}
-(void)msgCardAdWithPush:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSString *cardId = [userInfo objectForKey:@"cardId"];
    
    [[LocalizePush shareLocalizePush] removeBudgleCardId:cardId KindArray:[NSArray arrayWithObjects:CardMsg,Votes,Events, nil]];
}

#pragma mark-bottom
- (void)prepareBottomView{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 50)];
    
    //反馈，我的订单，分享会员卡
    NSArray *nameArray = @[@"反馈",@"订单",@"分享会员卡"];
    NSArray *imgArray = @[@"d1_feedback",@"d1_order",@"d1_share"];
    CGFloat w = SCREENWIDTH / 3.0;
    CGFloat imgX = (w - 20) / 2.0;
    for (int i = 0; i < nameArray.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(w * i, 0, w, 50)];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 10, 20, 20)];
        imgV.image = [UIImage imageNamed:imgArray[i]];
        [view addSubview:imgV];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, w, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = RGBCOLOR(39, 162, 240);
        label.text = nameArray[i];
        [view addSubview:label];
        
        switch (i) {
            case 0:
                [view addTapAction:@selector(feedbackClick) forTarget:self];
                break;
            case 1:
                [view addTapAction:@selector(myorderClick) forTarget:self];
                break;
            case 2:
                [view addTapAction:@selector(shareMemberCardClick) forTarget:self];
                break;
                
            default:
                break;
        }
        
        [self.bottomView addSubview:view];
    }
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    topLine.backgroundColor = RGBCOLOR(240, 240, 240);
    [self.bottomView addSubview:topLine];
    
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bottomView];
}

//反馈
- (void)feedbackClick{
    NSLog(@"反馈");
    //    if (!self.card.businessinfo.bid) {
    //        return;
    //    }
    
    NSString *bid = @"";
    
    if (self.card.businessinfo.bid) {
        bid = self.card.businessinfo.bid;
        //                    return;
    }
    FeedBackViewController *feedbackVC = [[FeedBackViewController alloc] initWithBid:bid];
    
    [self.navigationController pushViewController:feedbackVC animated:YES];
}
//我的订单
- (void)myorderClick{
    NSLog(@"我的订单");
    NSString *bid = @"";
    
    if (self.card.bid) {
        bid = self.card.bid;
        //                    return;
    }
    //    if (!self.card.bid) {
    //        return;
    //    }
    CardOrderListTableViewController *orderListVC = [[CardOrderListTableViewController alloc] initWithBid:bid];
    [self.navigationController pushViewController:orderListVC animated:YES];
}

//预约商家
- (IBAction)bookClick {
    NSLog(@"预约商家");
    
    NSString *bid = @"";
    
    if (self.card.bid) {
        bid = self.card.bid;
        //                    return;
    }
    //    if (!self.card.bid) {
    //        return;
    //    }
    SubscribeMerchantViewController *subscribeVC = [[SubscribeMerchantViewController alloc] initWithBid:bid Tel:self.card.businessinfo.tel];
    [self.navigationController pushViewController:subscribeVC animated:YES];
}

//全部商品
- (IBAction)allShopsClick {
    NSLog(@"全部商品");
    
    /**
     1021---ly
     将url替换为类似下面的url注意参数排序必须按照顺序来拼接 第一个参数 bid 第二个参数 appid 第三个参数 token
     http://kkt.wwwcity.net/production/xing_production_frontend/index.html?bid=10002863&appid=111&token=10000122#92d00187dce05131265fd02afd582f8d
     
     之前的逻辑--ly
     NSString *baseURL = [NSString stringWithFormat:@"%@",@"https://api.kakatool.com/v1/"];
     baseURL = [baseURL stringByReplacingOccurrencesOfString:@"v1/" withString:@""];
     //商品列表不支持https协议
     if ([baseURL containsString:@"https"]) {
     baseURL = [baseURL stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@""];
     }
     NSLog(@"baseURL = %@",baseURL);
     NSString *urlStr     = [NSString stringWithFormat:@"%@production/index.html?bid=%@&token=%@",baseURL,self.card.bid,[LocalData getAccessToken]];
     
     WebViewController *web = [WebViewController spawn];
     web.isShop = YES;
     web.webURL = urlStr;
     web.title = @"全部商品";
     [self.navigationController pushViewController:web animated:YES];
     
     */
    
    
    NSString *baseURL = @"http://kkt.wwwcity.net/production/xing_production_frontend/index.html";
    NSLog(@"baseURL = %@",baseURL);
    NSString *urlStr = [NSString stringWithFormat:@"%@?bid=%@&appid=%@&token=%@",baseURL,self.card.bid,APP_ID,[LocalData getAccessToken]];
    WebViewController *web = [WebViewController spawn];
    web.isShop = YES;
    web.webURL = urlStr;
    web.title = @"全部商品";
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark-加载数据
//网络加载数据
-(void)loadData{
    
    if (!self.cardId || !self.cardType) {
        return;
    }
    
    [self presentLoadingTips:nil];
    MemberCardDetailAPI *memberCardDetailApi = [[MemberCardDetailAPI alloc]initWithCardId:self.cardId cardType:self.cardType];
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [memberCardDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        MemberCardDetailResultModel *result = [MemberCardDetailResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            [self dismissTips];
            self.card = result.Card;
            self.subbranchArray = result.branch;
            self.bizswitch = result.bizswitch;
            self.kakapay = result.kakapay;
            [self.tv reloadData];
            [self prepareData];
        }
        else{
            [self presentFailureTips:result.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}

//布局数据
-(void)prepareData{
    
    if ([self.bizswitch.p2p intValue] == 1) {
        
        self.qrCodeBtn.hidden = NO;
    }else{
        self.qrCodeBtn.hidden = YES;
    }
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:self.card.frontimageurl] placeholderImage:[UIImage imageNamed:@"cardImage_no_bg"]];
    
    self.shopName.text = self.card.cardname;
    self.shopCategory.text = self.card.businessinfo.industryname;
    
    self.shopTel.text = self.card.businessinfo.tel;
    
    self.shopAddress.text = self.card.businessinfo.address;
    
    if (self.subbranchArray.count == 0) {
        self.subbranchShopLbl.text = @"没有其他分店";
        self.haveSubBranch = NO;
    }else{
        self.haveSubBranch = YES;
    }
    
    self.balanceLbl.text = self.card.amounts;
    self.pointLbl.text = self.card.points;
    self.discountLbl.text = self.card.discounts;
    
    [self.tableView reloadData];
}

-(void)checkKakaPay{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    
    CheckForKakaPayAPI *checkForkakaPayApi = [[CheckForKakaPayAPI alloc]initWithAppId:APP_ID];
    [checkForkakaPayApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            self.enable = result[@"enable"];
            
            [self.tv reloadData];
        }else{
            [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
        {
            if ([self.kakapay intValue] != 0 && [self.enable intValue] != 0){
                return 3;
            }else{
                return 2;
            }
            
        }
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 4;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 85;
            break;
        case 1:
            
            if (indexPath.row == 0){
                return 44;
            }else if (indexPath.row == 1){
                return 70;
            }else{
                if (self.shopAddress.resizeHeight > 21){
                    return 70 - 21 + self.shopAddress.resizeHeight;
                }else{
                    return 70;
                }
            }
            break;
        case 4:
            
            self.balanceLbl.text = self.card.amounts;
            self.pointLbl.text = self.card.points;
            self.discountLbl.text = self.card.discounts;
            
//            if (indexPath.row == 0){
//                if ([self.card.discounts floatValue] || [self.card.points floatValue] || [self.card.amounts floatValue]){
//                    return 44;
//                }else{
//                    return 0;
//                }
//            }else if (indexPath.row == 1){
//                if ([self.card.amounts floatValue]){
//                    return 44;
//                }else{
//                    return 0;
//                }
//            }else if (indexPath.row == 2){
//                if ([self.card.points floatValue]){
//                    return 44;
//                }else{
//                    return 0;
//                }
//            }else
            if (indexPath.row == 3){
                if ([self.card.discounts floatValue]){
                    return 44;
                }else{
                    return 0;
                }
            }
            return 44;
            break;
        default:
            return 44;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 || section == 1)
    {
        return 0.01;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:
            if(indexPath.row == 1){
                //商家电话
                NSLog(@"商家电话");
                NSString *tel = self.card.businessinfo.tel;
                if ([tel containsString:@"-"]) {
                    tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
                }
                tel = [tel trim];
                
                NSString *realnum = [NSString stringWithFormat:@"tel://%@",tel];
                self.callUrl=[NSURL URLWithString:realnum];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (indexPath.row == 2){
                //商家地址，导航
                NSLog(@"商家地址，导航");
                [self callMapShowPathFromCurrentLocation];
            }
            break;
        case 2:
            if (indexPath.row == 0){
                //商家代金券
                NSLog(@"商家代金券");
                NSString *bid = @"";
                
                if (self.card.bid) {
                    bid = self.card.bid;
                    //                    return;
                }
                VoucherTableViewController *voucherVC = [[VoucherTableViewController alloc] initWithBid:bid];
                voucherVC.refreshBadgeBlock = ^(){
                };
                
                [self.navigationController pushViewController:voucherVC animated:YES];
                
            }else if(indexPath.row == 1){
                //商家促销
                NSLog(@"商家促销");
                NSString *bid = @"";
                
                if (self.card.bid) {
                    bid = self.card.bid;
                    //                    return;
                }
                CardPromotionTableViewController *promotionVC = [[CardPromotionTableViewController alloc] initWithBid:bid Name:self.card.cardname];
                
                [self.navigationController pushViewController:promotionVC animated:YES];
                if (self.cardId) {
                    
                    
                    [[LocalizePush shareLocalizePush] updateLoaclCardId:self.cardId Kind:Events];
                    [[LocalizePush shareLocalizePush] updateLoaclCardId:self.cardId Kind:CardMsg];
                    [[LocalizePush shareLocalizePush] updateLoaclCardId:self.cardId Kind:Votes];
                    [[LocalizePush shareLocalizePush] removeBudgleCardId:self.cardId  KindArray:[NSArray arrayWithObjects:CardMsg,Votes,Events, nil]];
                    
                }
                
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
                
                
                
            }else if(indexPath.row == 2){
                //充值套餐
                NSString *bid = @"";
                
                if (self.bid) {
                    bid = self.bid;
                    //                    return;
                }
                RechargeComboListControllerViewController *recharge = [[RechargeComboListControllerViewController alloc]initWithBid:bid IconUrl:self.card.frontimageurl Name:self.card.cardname];
                
                [self.navigationController pushViewController:recharge animated:YES];
                
            }
            break;
        case 3:
            //其他分店
            if (self.haveSubBranch){
                NSLog(@"其他分店");
                CardSubBranchViewController *subBranch = [[CardSubBranchViewController alloc] initWithBranchArray:self.subbranchArray];
                [self.navigationController pushViewController:subBranch animated:YES];
                
            }
            break;
        case 4:
            if(indexPath.row == 1){
                //余额
                NSLog(@"余额");
                NSString *bid = @"";
                
                if (self.card.bid) {
                    bid = self.card.bid;
                    //                    return;
                }
                CardTransactionTableViewController *transactionVC = [[CardTransactionTableViewController alloc] initWithBid:bid Name:self.card.cardname];
                [self.navigationController pushViewController:transactionVC animated:YES];
                
            }else if (indexPath.row == 2){
                //积分
                NSLog(@"积分");
                NSString *bid = @"";
                
                if (self.card.bid) {
                    bid = self.card.bid;
                    //                    return;
                }
                UserModel *user = [[LocalData shareInstance] getUserAccount];
                CardPointTableViewController *pointVC = [[CardPointTableViewController alloc] initWithBid:bid Cid:user.cid Name:self.card.cardname];
                [self.navigationController pushViewController:pointVC animated:YES];
                
            }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[UIApplication sharedApplication] openURL:self.callUrl]) {
            [[UIApplication sharedApplication] openURL:self.callUrl];
        }
        else
        {
            [self presentFailureTips:@"此设备无法拨打电话"];
        }
    }
}


-(void)callMapShowPathFromCurrentLocation{
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.card.businessinfo.latitude doubleValue], [self.card.businessinfo.longitude doubleValue]) addressDictionary:nil]];
    toLocation.name = self.card.businessinfo.address;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    
}

//分享会员卡
- (void)shareMemberCardClick{
    NSLog(@"分享会员卡");
    //卡详情分享按钮点击
    UserModel *tUserDetail = [[LocalData shareInstance] getUserAccount];
    NSLog(@"cid-%@" ,tUserDetail.cid);
    
    NSString *cShareTitle = [NSString stringWithFormat:@"%@邀请您立刻加入",self.card.cardname];
    NSString *cShareContent = [NSString stringWithFormat:@"一卡在手，优惠我有！还等什么？%@会员火热招募中……",self.card.cardname];
    
    NSString *cShareurl = [NSString stringWithFormat:@"http://kkt.me/w/%@/%@/%@",self.card.bid,tUserDetail.cid,APP_ID];
    NSLog(@"cShareurl-%@" ,cShareurl);
    
    NSString *cShareTheme = [NSString stringWithFormat:@"%@%@",cShareContent,cShareurl];
    NSString *cShareAllContent = [NSString stringWithFormat:@"%@！%@",cShareTitle,cShareTheme];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:cShareAllContent
                                       defaultContent:nil
                                                image:nil
                                                title:nil
                                                  url:cShareurl
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:cShareTitle
                                        url:cShareurl
                                       site:nil
                                    fromUrl:nil
                                    comment:nil
                                    summary:cShareContent
                                      image:nil
                                       type:nil
                                    playUrl:nil
                                       nswb:nil];
    //微信朋友圈
    [publishContent addWeixinTimelineUnitWithType:SSPublishContentMediaTypeText
                                          content:cShareAllContent
                                            title:nil
                                              url:cShareurl
                                            image:nil
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData: nil
                                     emoticonData:nil];
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:SSPublishContentMediaTypeText
                                         content:cShareAllContent
                                           title:nil
                                             url:cShareurl
                                      thumbImage:nil
                                           image:nil
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:SSPublishContentMediaTypeText
                              content:cShareAllContent
                                title:nil
                                  url:cShareurl
                                image:nil];
    
    
    //定制短信信息
    [publishContent addSMSUnitWithContent:cShareAllContent];
    
    
    //定制邮件信息
    //    [publishContent addMailUnitWithSubject:cShareTitle
    //                                   content:cShareTheme
    //                                    isHTML:[NSNumber numberWithBool:NO]
    //                               attachments:nil
    //                                        to:nil
    //                                        cc:nil
    //                                       bcc:nil];
    
    //定义菜单分享列表
    //ShareTypeTencentWeibo,ShareTypeMail,
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeQQSpace,ShareTypeQQ,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSMS,nil];
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [self presentSuccessTips:@"分享成功"];
                                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [self presentFailureTips:@"分享失败,请重试"];
                                    
                                    NSLog(@"分享失败,请重试。");
                                    
                                }
                            }];
    
}

@end
