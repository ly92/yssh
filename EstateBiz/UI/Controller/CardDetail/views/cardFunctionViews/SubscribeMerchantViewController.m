//
//  SubscribeMerchantViewController.m
//  colourlife
//
//  Created by ly on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "SubscribeMerchantViewController.h"
#import "SubscribeHistoryTableViewController.h"
#import "SubscribeMerchantAPI.h"
#import "UIDatePickerSheetController.h"

@interface SubscribeMerchantViewController ()<UIAlertViewDelegate,UIDatePickerSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UITextView *commentT;

@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;
@property (weak, nonatomic) IBOutlet UIButton *byPhoneBtn;

@property (nonatomic, strong) UIButton * bgButton;

@property (nonatomic, strong) NSURL *callUrl;

@property (copy, nonatomic) NSString *bid;//
@property (copy, nonatomic) NSString *tel;//
@property (retain, nonatomic)UIDatePickerSheetController *datePicker;

@end

@implementation SubscribeMerchantViewController
- (instancetype)initWithBid:(NSString *)bid Tel:(NSString *)tel{
    if (self = [super init]){
        self.bid = bid;
        self.tel = tel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"预约商家";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"历史记录" handler:^(id sender) {
        
        [self historyRecord];
    }];
    
    
    
}


//选择时间
- (IBAction)chooseTime:(id)sender {
    [self.view endEditing:YES];
     [self showDatePicker];
}
#pragma mark - 时间选择


-(void)showDatePicker{
    [self.view endEditing:YES];
    if (_datePicker==nil) {
        _datePicker = [[UIDatePickerSheetController alloc] initWithDefaultNibName];
        _datePicker.dateMode=1;
        _datePicker.delegate = self;
    }
    [_datePicker setDate:[NSDate date]  animated:NO];
    [_datePicker showInViewController:self animated:YES];
    [_datePicker setMiniumDate:[NSDate date]];
    
}

- (void)datePickerSheet:(UIDatePickerSheetController *)datePickerSheet didFinishWithDate:(NSDate *)date
{
    
    NSDate * currentDate = date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString * timeStr = [formatter stringFromDate:currentDate];
    
    self.timeTF.text = [NSString stringWithFormat:@"%@", timeStr];
    self.timeTF.textColor = [AppTheme titleColor];
    
//    self.user.birthday = [date toStringWithDateFormat:[NSDate dateFormatString]];
//    
//    self.birthTextField.text = [date toStringWithDateFormat:[NSDate dateFormatString]];
//    
//    [self.tableView reloadData];
}
- (void)datePickerSheetDidCancel:(UIDatePickerSheetController *)datePickerSheet
{
    
}


- (void)historyRecord{
    SubscribeHistoryTableViewController *historyListVC = [[SubscribeHistoryTableViewController alloc] initWithBid:self.bid];
    [self.navigationController pushViewController:historyListVC animated:YES];
}

- (IBAction)subscribeBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *dateStr = self.timeTF.text;
    NSString *content = self.commentT.text;
    
    NSLog(@"dateStr = %@",dateStr);
    if ([ISNull isNilOfSender:dateStr]) {
         [self presentFailureTips:@"请选择预约时间"];
        return;
    }
    
    if ([ISNull isNilOfSender:content]) {
         [self presentFailureTips:@"请输入预约备注"];
        return;
    }
    
    NSString *now = [[NSDate date] toStringWithDateFormat:[NSDate timestampFormatString]];
    if ([now compare:dateStr] == NSOrderedDescending) {
         [self presentFailureTips:@"预约时间过期，请重新填写时间"];
        return;
    }
    
    SubscribeMerchantAPI *subscribeAPI = [[SubscribeMerchantAPI alloc] initWithBid:self.bid BookTime:dateStr Content:content];
    [self presentLoadingTips:nil];
     [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [subscribeAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self presentSuccessTips:@"预约成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
             [self presentFailureTips:result[@"reason"]];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}


- (IBAction)subscribeByPhone:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.tel != nil && [self.tel trim].length>0) {
        
        if ([self.tel containsString:@"-"]) {
            self.tel = [self.tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        self.tel = [self.tel trim];
        
        NSString *realnum = [NSString stringWithFormat:@"tel://%@",self.tel];
        self.callUrl=[NSURL URLWithString:realnum];
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:self.tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
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


@end
