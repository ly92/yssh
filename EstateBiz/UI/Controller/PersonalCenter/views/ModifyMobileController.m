//
//  ModifyMobileController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ModifyMobileController.h"

@interface ModifyMobileController ()

@property (weak, nonatomic) IBOutlet UITextField *oldMobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet CountdownButton *sendVerifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

@end

@implementation ModifyMobileController


+(instancetype)spawn{
   return [ModifyMobileController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.modifyButton.backgroundColor = VIEW_BTNBG_COLOR;
    [self.modifyButton setTitleColor:VIEW_BTNTEXT_COLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    [self hideKeyBoard];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"修改手机";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark-hideKeyBoard
-(void)hideKeyBoard{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.oldMobileTextField resignFirstResponder];
    [self.mobileTextField resignFirstResponder];
    [self.verifyCodeTextField resignFirstResponder];
}

#pragma mark-click

//发送验证码
- (IBAction)sendVerifyCodeButtonClick:(id)sender {
    
    
    NSString *mobile = [self.mobileTextField.text trim];
    
    if (mobile.length == 0) {
         [self presentFailureTips:@"请输入新手机号码"];
        [SVProgressHUD showErrorWithStatus:@"请输入新手机号码"];
        return;
    }
    
    if (mobile.length !=11) {
         [self presentFailureTips:@"请输入正确的新手机号码"];
        return;
    }
    
     [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    GetCodeAPI *getCodeApi = [[GetCodeAPI alloc]initWithMoblie:mobile];
    [getCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *) request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self presentSuccessTips:@"已发送至您的手机，请注意查收"];
            //验证码倒计时操作
            [self.sendVerifyCodeButton start];
        }else{
            [self.sendVerifyCodeButton stop];
             [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.sendVerifyCodeButton stop];
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];

}

//修改按钮
- (IBAction)modifyButtonClick:(id)sender {
    
    
    NSString *oldMobile = [self.oldMobileTextField.text trim];
    
    NSString *mobile = [self.mobileTextField.text trim];
    NSString *code = [self.verifyCodeTextField.text trim];
    
    
    if (oldMobile.length == 0) {
         [self presentFailureTips:@"请输入旧手机号码"];
        return;
    }
    
    
    if (oldMobile.length !=11) {
         [self presentFailureTips:@"请输入正确的旧手机号码"];
        return;
    }
    
    if (mobile.length == 0) {
         [self presentFailureTips:@"请输入新手机号码"];
        return;
    }
    
    if (mobile.length !=11) {
         [self presentFailureTips:@"请输入正确的新手机号码"];
        return;
    }
    
    
    if (code.length == 0) {
         [self presentFailureTips:@"请输入验证码"];
        return;
    }
    
     [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    ModifyMobileAPI *modifyMobileApi = [[ModifyMobileAPI alloc]initWithNewMobile:mobile verifyCode:code];
    [self presentLoadingTips:nil];
    [modifyMobileApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            NSDictionary *muser = [result objectForKey:@"user"];
            
            if (![ISNull isNilOfSender:muser] ) {
                
                //更新用户信息
                UserModel *user = [[LocalData shareInstance]getUserAccount];
                user.loginname = muser[@"loginname"];
                user.mobile = muser[@"mobile"];
                [[LocalData shareInstance] updateUserAccount:user];
                
                
                //更新本地账号密码
                NSDictionary *dic = [LocalData fetchNormalUserInfo];
                if (dic) {
                    [LocalData updateNormalUserInfo:mobile Psw:dic[@"psw"]];
                }
                
                self.mobileBlock(self.mobileTextField.text);
                
                [self.navigationController popViewControllerAnimated:YES];

            }
            
            
        }else{
             [self presentFailureTips:result[@"reason"]];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
    
}




#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 10;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
