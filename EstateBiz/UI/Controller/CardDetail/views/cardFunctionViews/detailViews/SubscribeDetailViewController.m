//
//  SubscribeDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "SubscribeDetailViewController.h"
#import "SubscribeListModel.h"

@interface SubscribeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentText;

@property (strong, nonatomic) SubscribeRecordModel *subscribe;//

@end

@implementation SubscribeDetailViewController


- (instancetype)initWithSubscribe:(SubscribeRecordModel *)subscribe{
    if (self = [super init]){
        self.subscribe = subscribe;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"预约详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

    self.timeL.text = [NSDate longlongToDayDateTime:self.subscribe.booktime];
    
    int status= [self.subscribe.status intValue];
    switch (status) {
        case 2:
            self.stateL.text = @"已确认";
            break;
            
        default:
            self.stateL.text = @"已提交";
            break;
    }
    NSLog(@"-----%@",self.subscribe.content);
    self.contentText.text = self.subscribe.content;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
