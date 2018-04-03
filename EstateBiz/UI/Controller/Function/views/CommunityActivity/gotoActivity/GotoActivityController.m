//
//  GotoActivityController.m
//  WeiTown
//
//  Created by 王闪闪 on 16/3/24.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "GotoActivityController.h"
#import "HasJoinActivityController.h"

#import "SelectCommunityController.h"

@interface GotoActivityController ()

@property(nonatomic, retain) NSString *communityId;

@end

@implementation GotoActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navigationbar
-(void)setNavigationBar{
    self.navigationItem.title = @"社区活动";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark-点击

//选择小区
- (IBAction)selectCommunity:(id)sender {
    SelectCommunityController *selectCommunity = [[SelectCommunityController alloc]init];
    
    selectCommunity.isCommunityActivity = YES;
    selectCommunity.selectCommunity = ^(NSDictionary *dic){
        self.selectCommunityLbl.text = dic[@"name"];
        self.communityId = dic[@"bid"];
        
    };
    [self.navigationController pushViewController:selectCommunity animated:YES];
    
    
}
//选择活动
- (IBAction)selectActivity:(id)sender {
    
    if (!self.communityId) {
         [self presentFailureTips:@"请先选择小区"];
        return;
    }
    
    HasJoinActivityController *listActivity = [[HasJoinActivityController alloc]init];
    listActivity.isJoinCommunity = YES;
    listActivity.communityId = self.communityId;
    [self.navigationController pushViewController:listActivity animated:YES];
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
