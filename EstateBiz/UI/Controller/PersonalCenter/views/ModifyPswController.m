//
//  ModifyPswController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ModifyPswController.h"

@interface ModifyPswController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPswTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@implementation ModifyPswController

+(instancetype)spawn{
    return [ModifyPswController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    self.completeButton.backgroundColor = VIEW_BTNBG_COLOR;
    [self.completeButton setTitleColor:VIEW_BTNTEXT_COLOR forState:UIControlStateNormal];
    
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
    
    self.navigationItem.title = @"修改密码";
    
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
    [self.oldPswTextField resignFirstResponder];
    [self.pswTextField resignFirstResponder];
}
#pragma marl-click

- (IBAction)completeButtonClick:(id)sender {
    NSString *oldpsw = [self.oldPswTextField text];
    NSString *psw = [self.pswTextField text];
    
    if ([oldpsw trim].length==0) {
         [self presentFailureTips:@"请输入旧密码"];
       
        return;
    }
    if ([psw trim].length==0) {
         [self presentFailureTips:@"请输入新密码"];
       
        return;
    }
    NSMutableDictionary *userInfo = [LocalData fetchNormalUserInfo];
    if (userInfo) {
        NSString *oldpsww = [userInfo objectForKey:@"password"];
        
        
        if (![[oldpsw trim] isEqualToString:[oldpsww trim]]) {
             [self presentFailureTips:@"旧密码输入不正确"];
            return;
        }
        
        if ([[psw trim] isEqualToString:[oldpsww trim]]) {
             [self presentFailureTips:@"新密码不能与旧密码相同"];
            return;
        }
        
    }
    
    [self presentLoadingTips:nil];
     [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    ModifyPswAPI *modifyPswApi = [[ModifyPswAPI alloc]initWithPldPsw:oldpsw newPsw:psw];
    [modifyPswApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            UserModel *user = [UserModel mj_objectWithKeyValues:result[@"user"]];
            if (user) {
                [self dismissTips];
                [[LocalData shareInstance] updateUserAccount:user];
                [LocalData updateAccessToken:user.access_token];
                
                
//                if ([STICache.global objectForKey:@"RemberPsw"]) {
//                    [LocalData updateNormalUserInfo:user.loginname Psw:psw];
//
//                }
                
                [LocalData updateNormalUserInfo:user.loginname Psw:psw];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                 [self presentFailureTips:@"未获取到用户信息"];

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
