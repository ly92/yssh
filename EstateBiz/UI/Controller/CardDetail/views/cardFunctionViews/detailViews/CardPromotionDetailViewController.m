//
//  CardPromotionDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardPromotionDetailViewController.h"
#import "CardPromotionModel.h"
#define PHONEREGULAR @"^400-[0-9]{3}-[0-9]{4}|^800[0-9]{7}|\\d{3,4}[- ]?\\d{7,8}|^0[0-9]{2,3}-[0-9]{8}|^03[0-9]{2}-[0-9]{7}|100[0-9]{2,4}"
@interface CardPromotionDetailViewController ()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PromotionModel *promotion;
@property (nonatomic, assign) BOOL isBigImg;

@end

@implementation CardPromotionDetailViewController

- (instancetype)initWithBusName:(NSString *)name Promotion:(PromotionModel *)promotion{
    if (self = [super init]){
        self.name = name;
        self.promotion = promotion;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"信息详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.promotion.bid) {
        
        [[LocalizePush shareLocalizePush] updateLoaclCardId:self.promotion.bid Kind:CardMsg];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
    }
    
   
    
    if ([ISNull isNilOfSender:self.promotion.imageurl]){
        self.imgV.hidden = YES;
        self.imgVH.constant = 0;
    }else{
        self.imgV.hidden = NO;
        self.imgVH.constant = 200;
        [self.imgV setImageURL:[NSURL URLWithString:self.promotion.imageurl]];
        
//        UIImage *img = self.imgV.image;
//        if (img.size.width > img.size.height){
//            self.imgV.image = [UIImage imageWithCGImage:img.CGImage scale:1 orientation:UIImageOrientationRight];
//        }
        
    }
    [self.imgV addTapAction:@selector(imgClick) forTarget:self];
    self.nameL.text = self.name;
    self.timeL.text = [NSDate longlongToDateTime:self.promotion.creationtime];
    self.contentText.text = self.promotion.content;
    self.contentText.width = SCREENWIDTH-20;
    self.contentLblHeight.constant = [self.contentText resizeHeight];
    self.containerViewHeight.constant = 336-20+self.contentLblHeight.constant;
    
    NSString *tempStr = self.contentText.text;
    NSRange stringRange = NSMakeRange(0, tempStr.length);
    //正则匹配
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:PHONEREGULAR options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:tempStr options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            //可能为电话号码的字符串及其所在位置
            NSString *actionString = [NSString stringWithFormat:@"%@",[self.contentText.text substringWithRange:result.range]];
            NSRange phoneRange = result.range;
            //这里需要判断是否是电话号码，并添加链接
            if ([NSString isMobilePhoneOrtelePhone:actionString]) {
                
                [self.contentText addLinkToPhoneNumber:actionString withRange:phoneRange];
                
            }
        }];
    }
    
}

- (void)imgClick{
    if (self.isBigImg){
    
        [UIView animateWithDuration:0.5f animations:^{
            
            self.imgV.frame = CGRectMake(30, 80, SCREENWIDTH - 60, 200);
        }];
        self.imgV.contentMode = UIViewContentModeScaleToFill;
    }else{
        
        self.imgV.backgroundColor = [UIColor blackColor];
        [UIView animateWithDuration:0.5f animations:^{
                self.imgV.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
            self.imgV.contentMode = UIViewContentModeScaleAspectFit;
        }];
        
    }
    
    self.isBigImg = !self.isBigImg;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    
    [UIAlertView bk_showAlertViewWithTitle:@"拨打电话" message:phoneNumber cancelButtonTitle:@"取消" otherButtonTitles:@[@"拨打"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString *callTel = [NSString stringWithFormat:@"tel://%@",phoneNumber];
            callTel = [callTel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *callUrl = [NSURL URLWithString:callTel];
            if (callUrl) {
                [[UIApplication sharedApplication] openURL:callUrl];
            }
        }
        
        
    }];
    
}

@end
