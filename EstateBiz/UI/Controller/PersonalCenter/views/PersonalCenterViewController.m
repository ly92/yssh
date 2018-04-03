//
//  PersonalCenterViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/24.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonInformationController.h"
#import "ModifyPswController.h"
#import "MyCodeController.h"
#import "VoucherTableViewController.h"
#import "PayOrderListController.h"
#import "AboutViewController.h"
#import "WebViewController.h"

@interface PersonalCenterViewController ()<UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;
@property (weak, nonatomic) IBOutlet UIImageView *pushImg;

@property (weak, nonatomic) IBOutlet UITableViewCell *payOrderCell;


@property (nonatomic, retain) NSString *enable;//是否支持在线支付

@end

@implementation PersonalCenterViewController

+(instancetype)spawn{
    return [PersonalCenterViewController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.enable = @"1";
    //需要判断是否是否开通了支付
    [self checkKakaPay];
    
    self.navigationItem.title = @"我的";
    
    self.tableView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
    
    [self.tableView tableViewRemoveExcessLine];
    
    self.tableView.separatorColor = [AppTheme lineColor];
    self.logoutButton.backgroundColor = VIEW_BTNBG_COLOR;
    self.logoutButton.backgroundColor = VIEW_BTNTEXT_COLOR;
    self.logoutButton.layer.cornerRadius = 4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCoupon) name:@"getCoupon" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkKakaPay) name:@"ENTERFOREGROUND" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:NO animated:YES];
    }
    
    int amount = [[LocalizePush shareLocalizePush] getSettingBadgleWithCoupon];
    NSLog(@"my coupon amount = %d",amount);
    
    if (amount != 0) {
        self.pushImg.hidden = NO;
    }
    else {
        self.pushImg.hidden = YES;
    }
    
 
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self getCounpCount];
//    _user = [UserModel sharedInstance].user;
    [self showUserInformation];
    
}

-(void)checkKakaPay{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    
    CheckForKakaPayAPI *checkForkakaPayApi = [[CheckForKakaPayAPI alloc]initWithAppId:APP_ID];
    [checkForkakaPayApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            self.enable = result[@"enable"];
            if ( [self.enable intValue] == 0) {
                self.payOrderCell.hidden = YES;
            }
            [self.tableView reloadData];
            
        }else{
            [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}

//接收优惠券
-(void)getCoupon{
    
    int amount = [[LocalizePush shareLocalizePush] getSettingBadgleWithCoupon];
    NSLog(@"my coupon amount = %d",amount);
    
    if (amount != 0) {
        self.pushImg.hidden = NO;
    }
    else {
        self.pushImg.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showUserInformation{
   
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    if (user) {
        
        [self.userImageView setImageWithURL:[NSURL URLWithString:user.iconurl] placeholder:[UIImage imageNamed:@"icon_default"]];
        
        self.nameLbl.text = (user.realname.length>0)?user.realname:user.loginname;
        self.mobileLbl.text = user.mobile;
    }
    
}

#pragma mark-tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ( section == 0 )
    {
        return 0.01;
    }
    
    if ( [self.enable intValue] == 0) {
        
        if (section == 3) {
            return 0.01;
        }
    }
    
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ( [self.enable intValue] == 0) {
        if (section == 3) {
            return 0.01;
        }
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        return 232;
    }
    
    if ( [self.enable intValue] == 0) {
        if (indexPath.section == 3) {
            return 0;
        }
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        
    }else if ( indexPath.section == 1 ){
        //修改密码
        ModifyPswController *modifyPsw = [ModifyPswController spawn];
        
        [self.navigationController pushViewController:modifyPsw animated:YES];
        
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                //我的二维码名片
                
                MyCodeController *myCode = [MyCodeController spawn];
                [self.navigationController pushViewController:myCode animated:YES];
                
            }
                break;
            case 1:
            {
                //我的优惠券
                
                
                VoucherTableViewController *voucher = [[VoucherTableViewController alloc]init];
                
                voucher.refreshBadgeBlock = ^(){
                    
                    [[LocalizePush shareLocalizePush] removeSettingWithCouponPushDic];
                    self.pushImg.hidden = YES;
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];

                };
                
                [self.navigationController pushViewController:voucher animated:YES];
                
            }
                break;
            case 2:
            {
                //分享给好友
                
                [self myShare];
                
            }
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section ==3){
        //手机支付订单
        PayOrderListController *payOrder = [PayOrderListController spawn];
        
        [self.navigationController pushViewController:payOrder animated:YES];
        
       
    }else if (indexPath.section == 4){
        switch (indexPath.row) {
            case 0:
            {
                //关于微Town
                
                AboutViewController *about = [AboutViewController spawn];
                [self.navigationController pushViewController:about animated:YES];
                
            }
                break;
            case 1:
            {
                
                
                WebViewController *web = [WebViewController spawn];
                web.webURL = [NSString stringWithFormat:@"http://app.kakatool.cn/policy.php?appid=%@",APP_ID ];
                web.title = @"服务条款";
                [self.navigationController pushViewController:web animated:YES];
                //服务条款
             
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
}

#pragma mark-share
-(void)myShare{
    NSLog(@"分享会员卡");
    //卡详情分享按钮点击
    UserModel *tUserDetail = [[LocalData shareInstance]getUserAccount];
    NSLog(@"cid-%@" ,tUserDetail.cid);
    
    NSString *name = @"";
    if ([tUserDetail.realname trim].length>0) {
        name = tUserDetail.realname;
    }
    else{
        name = tUserDetail.loginname;
    }
    
    NSString *cShareTitle = [NSString stringWithFormat:@"%@邀请您立刻加入",name];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *cShareContent =[NSString stringWithFormat:@"%@微生活，享受智能社区生活",appName];
    
    NSString *cShareurl = [NSString stringWithFormat:@"http://app.kakatool.cn/app.php?appid=%@",APP_ID];
    
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
    
    //定义菜单分享列表
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
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                     [self presentFailureTips:@"分享失败,请重试"];
                                    NSLog(@"分享失败,请重试。");
                                    
                                }
                            }];
}

#pragma mark-click
//个人信息
- (IBAction)personalCenterClick:(id)sender {
    NSLog(@"personclick");
    
    PersonInformationController *personInformation = [PersonInformationController spawn];
    
    [self.navigationController pushViewController:personInformation animated:YES];
    
}
//退出登陆
- (IBAction)logoutButtonClick:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认退出？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
#pragma mark-UIalertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        
        NSString *token = [LocalData getDeviceToken];
        if (user && token) {
            [self presentLoadingTips:nil];
             [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
             UnRegisterDeviceAPI *unregisterDeviceApi = [[UnRegisterDeviceAPI alloc]initWithMemberIDType:@"cid" objid:user.cid];
            
            [unregisterDeviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                    [self dismissTips];
                }else{
                     [self presentFailureTips:result[@"reason"]];
                }

            } failure:^(__kindof YTKBaseRequest *request) {
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];
            
        }
       
        [[LocalData shareInstance] removeUserAccount];
        [LocalData updateAccessToken:nil];
        [STICache.global setObject:@"YES" forKey:@"LOGOUT"];
        //弹出登录页面
        [[AppDelegate sharedAppDelegate] setupRootViewController];
        
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
