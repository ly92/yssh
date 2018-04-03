//
//  FeedbackDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/20.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "FeedbackDetailViewController.h"
#import "FeedbackListmodel.h"
#import "TextView.h"
@interface FeedbackDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet TextView *contentL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTVH;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *replyL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyViewH;
@property (nonatomic, strong) FeedbackModel *feedback;

@end

@implementation FeedbackDetailViewController

- (instancetype)initWFeedback:(FeedbackModel *)feedback{
    if (self = [super init]){
        self.feedback = feedback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"反馈详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.feedback){
        self.timeL.text = [NSDate longlongToDate:self.feedback.creationtime];
        self.contentL.text = self.feedback.content;
        self.contentTVH.constant = [self.contentL resizeFrameWithWithText];
        if (self.feedback.replycontent.length != 0){
            self.stateL.text = @"已回复";
            self.stateL.textColor = RGBCOLOR(113, 213, 78);
            
            self.replyL.text = [NSString stringWithFormat:@"商家回复：%@",self.feedback.replycontent];
            [self.replyL autoCalculateTextViewFrame];
            self.replyViewH.constant = self.replyL.height + 20;
        }else {
            self.stateL.text = @"待回复";
            self.stateL.textColor = [UIColor redColor];
            
            self.replyViewH.constant = 0;
        }
        
    }
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
