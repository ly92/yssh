//
//  ModifyUsernameController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ModifyUsernameController.h"

@interface ModifyUsernameController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) nameInfoBlock nameBlock;
@property (nonatomic, assign) ActivityType activityType;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@implementation ModifyUsernameController

+(instancetype)spawn{
    return [ModifyUsernameController loadFromStoryBoard:@"PersonalCenter"];
}

-(void)infoWithName:(NSString *)name activityType:(ActivityType)activityType Then:(nameInfoBlock)block{
    
    if (![ISNull isNilOfSender:name]) {
        self.nameString = name;
    }
    
    self.activityType = activityType;
    self.nameBlock = block;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.completeButton.backgroundColor = VIEW_BTNBG_COLOR;
    [self.completeButton setTitleColor:VIEW_BTNTEXT_COLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    
    [self hideKeyBoard];
    if (self.activityType == nameType) {
        self.navigationItem.title = @"修改姓名";
        self.nameTextField.placeholder = @"请输入姓名";
        
    }else if (self.activityType == addressType){
        self.navigationItem.title = @"修改地址";
        self.nameTextField.placeholder = @"请输入地址";
    }else if (self.activityType == emailType){
        self.navigationItem.title = @"修改邮箱";
        self.nameTextField.placeholder = @"请输入邮箱";
    }
    
    self.nameTextField.text = self.nameString;

    
    
    //添加toobar
    UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    toobar.barStyle        = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
    self.nameTextField.inputAccessoryView   = toobar;
    
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


//toobar Action
-(void)resignKeyboard{
    [self.nameTextField resignFirstResponder];
}

#pragma mark-navibar
-(void)setNavigationBar{
    
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
    [self.nameTextField resignFirstResponder];
}

#pragma mark-click

- (IBAction)deleteButtonClick:(id)sender {
 
    self.nameTextField.text =  @"";
}

//完成按钮
- (IBAction)finishButtonClick:(id)sender {
    self.nameBlock(_nameTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}

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
