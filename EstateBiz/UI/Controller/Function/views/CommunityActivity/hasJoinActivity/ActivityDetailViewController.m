//
//  ActivityDetailViewController.m
//  WeiTown
//
//  Created by 王闪闪 on 16/3/25.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "SJAvatarBrowser.h"
//#import "CommunityActivityAPI.h"

@interface ActivityDetailViewController ()<UITextViewDelegate>

@property (nonatomic, retain) NSString *activityId;

@property (nonatomic, strong) NSDictionary *activityInfo;

@end

@implementation ActivityDetailViewController

-(instancetype)initWithActivityId:(NSString *)activityId{
    if (self = [super init]) {
        self.activityId = activityId;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBar];
    
    //加载数据
    [self loadData];
    
    [self listenToKeyboard];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-navigationbar
-(void)setNavigationBar{
    self.navigationItem.title = @"活动详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark-加载数据
-(void)loadData{
    if (!self.activityId) {
        return;
    }
    

    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    GetActivityDetailAPI *getActivityDetailApi = [[GetActivityDetailAPI alloc]initWithId:self.activityId];
    [getActivityDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [self dismissTips];
//            [SVProgressHUD dismiss];
            
            self.activityInfo = result[@"activityinfo"];
             //准备数据
            [self prepareData];
            
        }else{
            [self presentFailureTips:result[@"reason"]];
            
//            [SVProgressHUD showErrorWithStatus:result[@"reason"]];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
//         [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}
//准备数据
-(void)prepareData{
    
    if ([self.activityInfo[@"status"] integerValue] == 1 ) {
        if ([self.activityInfo[@"isjoin"] intValue]==0) {
            //未报名
            self.nameLbl.hidden = YES;
            self.mobileLbl.hidden = YES;
            self.addrLbl.hidden = YES;
            self.nameTxtField.hidden = NO;
            self.mobileTxtField.hidden = NO;
            self.addrTextView.hidden = NO;
            
            
            UserModel *user = [[LocalData shareInstance] getUserAccount];
            if (user) {
                self.nameTxtField.text = user.realname;
                self.mobileTxtField.text = user.mobile;
               
                if ([user.address trim].length == 0) {
                    self.addrPlaceHolder.hidden = NO;
                }else{
                    self.addrPlaceHolder.hidden = YES;
                    self.addrTextView.text = user.address;
                    
                    CGSize size=[self.addrTextView sizeThatFits:CGSizeMake(self.addrTextView.width, MAXFLOAT)];
                    self.addrTextViewHeight.constant=size.height;
                    
                    self.view3Height.constant=128-30+self.addrTextViewHeight.constant;
                }
                
            }
            self.signupBtn.userInteractionEnabled = YES;
            [self.signupBtn setTitle:@"报名" forState:UIControlStateNormal];
            self.signupBtn.backgroundColor = VIEW_BTNBG_COLOR;
            [self.signupBtn setTitleColor:VIEW_BTNTEXT_COLOR forState:UIControlStateNormal];
            [self.signupBtn setBackgroundImage:[UIImage imageNamed:@"signupBtn.png"] forState:UIControlStateNormal];
        }else{
            self.nameLbl.hidden = NO;
            self.mobileLbl.hidden = NO;
            self.addrLbl.hidden = NO;
            self.nameTxtField.hidden = YES;
            self.mobileTxtField.hidden = YES;
            self.addrTextView.hidden = YES;
            
            NSDictionary *userinfo = self.activityInfo[@"userinfo"];
            self.nameLbl.text = userinfo[@"username"];
            self.mobileLbl.text = userinfo[@"mobile"];
            self.addrLbl.text = userinfo[@"addr"];
            
            
            CGFloat addrHeight = [self.addrLbl resizeHeight];
            
            if (addrHeight<20) {
                self.addrLblHeight.constant = 20;
            }else{
                self.addrLblHeight.constant = addrHeight;
            }
             self.view3Height.constant = self.view3Height.constant-20+self.addrLblHeight.constant;
            
            self.signupBtn.userInteractionEnabled = NO;
            [self.signupBtn setTitle:@"已报名" forState:UIControlStateNormal];
            [self.signupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.signupBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn.png"] forState:UIControlStateNormal];
        }

    }else{
        if ([self.activityInfo[@"isjoin"] intValue]==0) {
            self.nameLbl.hidden = YES;
            self.mobileLbl.hidden = YES;
            self.addrLbl.hidden = YES;
            self.nameTxtField.hidden = NO;
            self.mobileTxtField.hidden = NO;
            self.addrTextView.hidden = NO;
            
            UserModel *user = [[LocalData shareInstance] getUserAccount];
            if (user) {
                self.nameTxtField.text = user.realname;
                self.mobileTxtField.text = user.mobile;
                
                if ([user.address trim].length == 0) {
                    self.addrPlaceHolder.hidden = NO;
                }else{
                    self.addrPlaceHolder.hidden = YES;
                    self.addrTextView.text = user.address;
                    
                    CGSize size=[self.addrTextView sizeThatFits:CGSizeMake(self.addrTextView.width, MAXFLOAT)];
                    self.addrTextViewHeight.constant=size.height;
                    
                    self.view3Height.constant=128-30+self.addrTextViewHeight.constant;

                }
            }
            
            self.signupBtn.userInteractionEnabled = NO;
            [self.signupBtn setTitle:self.activityInfo[@"statustext"] forState:UIControlStateNormal];
            [self.signupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.signupBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn.png"] forState:UIControlStateNormal];
        }else{
            self.nameLbl.hidden = NO;
            self.mobileLbl.hidden = NO;
            self.addrLbl.hidden = NO;
            self.nameTxtField.hidden = YES;
            self.mobileTxtField.hidden = YES;
            self.addrTextView.hidden = YES;
            
            NSDictionary *userinfo = self.activityInfo[@"userinfo"];
            self.nameLbl.text = userinfo[@"username"];
            self.mobileLbl.text = userinfo[@"mobile"];
            self.addrLbl.text = userinfo[@"addr"];
            
            
            CGSize addrSize = [self.addrLbl sizeThatFits:CGSizeMake(self.addrLbl.width, MAXFLOAT)];
            if (addrSize.height<20) {
                self.addrLblHeight.constant = 20;
            }else{
                self.addrLblHeight.constant = addrSize.height;
            }
            
            self.view3Height.constant = self.view3Height.constant-20+self.addrLblHeight.constant;
            
            self.signupBtn.userInteractionEnabled = NO;
            [self.signupBtn setTitle:@"已报名" forState:UIControlStateNormal];
            [self.signupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.signupBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn.png"] forState:UIControlStateNormal];
        }
        
       
    }
    
    [self.leftImageView setImageWithURL:[NSURL URLWithString:self.activityInfo[@"image"]] placeholder:[UIImage imageNamed:@"contentIamge_no_bg.png"]];
    
    [self.leftImageView addTapAction:@selector(browseImage) forTarget:self];
    
    self.titleDetailLbl.text = self.activityInfo[@"title"];
    self.isJoinedLbl.text = self.activityInfo[@"joined"];
    self.locationLbl.text = self.activityInfo[@"location"];
    
    
    CGFloat locationHeight = [self.locationLbl resizeHeight];
    if (locationHeight<20) {
        self.locationLblHeight.constant = 20;
    }else{
        self.locationLblHeight.constant = locationHeight;
    }
    self.view1Height.constant = self.view1Height.constant -20 +self.locationLblHeight.constant;
    
    NSDate *startdate=[NSDate dateWithTimeIntervalSince1970:[self.activityInfo[@"starttime"] integerValue]];
    //将获取的时间按照对应的时间格式进行转换
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"MM月dd日HH:mm";
    NSString *startdateStr=[formatter stringFromDate:startdate];
    
    NSDate *stopdate=[NSDate dateWithTimeIntervalSince1970:[self.activityInfo[@"stoptime"] integerValue]];
    NSString *stopdateStr=[formatter stringFromDate:stopdate];
    
    self.dateLbl.text = [NSString stringWithFormat:@"%@ - %@",startdateStr,stopdateStr];
    
    self.contentLbl.text = self.activityInfo[@"content"];
    
    CGFloat contentHeight = [self.contentLbl resizeHeight];
    if (contentHeight <=20) {
        self.contentLblHeight.constant = 20;
    }else{
        self.contentLblHeight.constant = contentHeight;
    }
    self.contentViewHeight.constant = 70-20+self.contentLblHeight.constant;
    
    
    self.containerViewHeight.constant = 410-70+self.contentViewHeight.constant-202+self.view1Height.constant-128+self.view3Height.constant;
}
//图片放大
- (void)browseImage
{
    
    [SJAvatarBrowser
     showImage:self.leftImageView];
}
#pragma mark- 点击


//报名
- (IBAction)signBtnClick:(id)sender {
    
    NSString *username =self.nameTxtField.text;
    NSString *mobile = self.mobileTxtField.text;
    NSString *addr = self.addrTextView.text;
    
    
    if ([[username trim] length]==0) {
        [self presentFailureTips:@"请输入姓名"];
//        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        
        return;
    }
    if ([[mobile trim] length]==0){
        [self presentFailureTips:@"请输入手机号码"];
//        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    if ([[mobile trim] length]<11||[[mobile trim]length]>11) {
        [self presentFailureTips:@"请输入正确的手机号"];
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
        
    }
    if ([[addr trim] length]==0) {
        [self presentFailureTips:@"请输入地址"];
//        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return;
    }
    
//    [[AppPlusAppDelegate sharedAppDelegate]showLoading:nil];
//    
//    [CommunityActivityAPI joinActivityWithActivityId:self.activityInfo[@"id"] username:username mobile:mobile addr:addr BlockSuc:^(NSURL *url, NSDictionary *result) {
//        [[AppPlusAppDelegate sharedAppDelegate]hideLoading];
//        
//        NSLog(@"%@",result);
//        
//        if (![ISNull isNilOfSender:result]&&[result[@"result"] intValue]==0) {
//            [[AppPlusAppDelegate sharedAppDelegate]showSucMsg:@"报名成功" WithInterval:1.0f];
//            self.refreshBlock();
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        
//    } BlockFailed:^(NSURL *url, NSString *error) {
//        [[AppPlusAppDelegate sharedAppDelegate]showErrMsg:error WithInterval:1.0f];
//    }];
    
    
}
- (IBAction)bottomClick:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark-UITextView的代理方法
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [self.addrPlaceHolder setHidden:NO];
        
    }else{
        [self.addrPlaceHolder setHidden:YES];
        
//        CGSize size=[self.addrTextView sizeThatFits:CGSizeMake(self.addrTextView.frameSizeWidth, MAXFLOAT)];
//        self.addrTextViewHeight.constant=size.height;
//        
//        self.view3Height.constant=128-30+self.addrTextViewHeight.constant;
//        self.containerViewHeight.constant = 410-70+self.contentViewHeight.constant-202+self.view1Height.constant-128+self.view3Height.constant;
    }
}
#pragma mark - 键盘

-(void)listenToKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note {
    
    NSDictionary* userInfo = [note userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    self.sv.contentInset = UIEdgeInsetsMake(0,0,keyboardFrame.size.height,0);
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    self.sv.contentInset = UIEdgeInsetsMake(0,0,0,0);
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
