//
//  CommunityActivityController.m
//  WeiTown
//
//  Created by 王闪闪 on 16/3/24.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "CommunityActivityController.h"
#import "GotoActivityController.h"
#import "HasJoinActivityController.h"

@interface CommunityActivityController ()

@end

@implementation CommunityActivityController

+(instancetype)spawn{
    return [CommunityActivityController loadFromStoryBoard:@"Function"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
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

#pragma mark-点击方法


//要参加活动
- (IBAction)goToEventsClick:(id)sender {

    GotoActivityController *gotoActivity = [[GotoActivityController alloc]init];

    [self.navigationController pushViewController:gotoActivity animated:YES];
}

//已参加活动
- (IBAction)haveJoinEventsClick:(id)sender {
    
    HasJoinActivityController *joinActivity = [[HasJoinActivityController alloc]init];
    
    [self.navigationController pushViewController:joinActivity animated:YES];
    
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
