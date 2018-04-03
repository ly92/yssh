//
//  CardMsgDetailViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardMsgDetailViewController.h"
#import "SJAvatarBrowser.h"

//#define PHONEREGULAR @"\\d{3,4}[- ]?\\d{7,8}"
//#define PHONEREGULAR @"^(\d{3,4}-)?\d{7,8})$|(13[0-9]{9}"
#define PHONEREGULAR @"^400-[0-9]{3}-[0-9]{4}|^800[0-9]{7}|\\d{3,4}[- ]?\\d{7,8}|^0[0-9]{2,3}-[0-9]{8}|^03[0-9]{2}-[0-9]{7}|100[0-9]{2,4}"
@interface CardMsgDetailViewController ()<TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewheight;

@property (nonatomic, strong) CardMsgDetailModel *cardMsgDetail;
@property (nonatomic, assign) BOOL isBigImg;

//@property (nonatomic, assign) CGFloat imgHeight;
//@property (nonatomic, assign) CGFloat imgWidth;

@property (nonatomic, copy) NSString *imgUrl;

@end

@implementation CardMsgDetailViewController

+(instancetype)spawn{
    return [CardMsgDetailViewController loadFromStoryBoard:@"Message"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    //加载数据
    [self loadData];
    
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
    
    self.navigationItem.title = @"信息详情";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}


#pragma mark-加载数据
-(void)loadData{
    if (!self.relatedId) {
        return;
    }
    
    [self presentLoadingTips:nil];
     [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    MerchantMsgDetailAPI *merchantMsgDetailApi = [[MerchantMsgDetailAPI alloc]initWithMsgId:self.relatedId];
    
    [merchantMsgDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            self.cardMsgDetail = [CardMsgDetailModel mj_objectWithKeyValues:result[@"Msg"]];
            [self prepareData];
            
        }else{
             [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        
    }];
    
    
}

-(void)prepareData{
 
    self.titleLbl.text = self.cardMsgDetail.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    [self.dateTimeLbl setText:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.cardMsgDetail.creationtime intValue]]]];
    
    self.contentLbl.text = self.cardMsgDetail.content;
    NSString *tempStr = self.contentLbl.text;
    NSRange stringRange = NSMakeRange(0, tempStr.length);
    //正则匹配
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:PHONEREGULAR options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:tempStr options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            //可能为电话号码的字符串及其所在位置
            NSString *actionString = [NSString stringWithFormat:@"%@",[self.contentLbl.text substringWithRange:result.range]];
            NSRange phoneRange = result.range;
            //这里需要判断是否是电话号码，并添加链接
            if ([NSString isMobilePhoneOrtelePhone:actionString]) {
                
                [self.contentLbl addLinkToPhoneNumber:actionString withRange:phoneRange];
                
            }
        }];
    }
    
    CGFloat contentHeight = [self.contentLbl resizeHeight];
    
    if (self.cardMsgDetail.imageurl.length == 0) {
        self.contentImageView.hidden = YES;
        [self.contentLbl updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
            make.height.equalTo(@(contentHeight));
        }];
    }else{
        self.contentImageView.hidden = NO;
        
        self.imgUrl = self.cardMsgDetail.imageurl;
        
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.cardMsgDetail.imageurl] placeholderImage:[UIImage imageNamed:@"cardImage_no_bg"]];
        
        UIImage *img = self.contentImageView.image;
        
        if (img.size.width > (SCREENWIDTH-20)) {
            self.imgWidth.constant = SCREENWIDTH-20;
            self.imgHeight.constant = img.size.height * (self.imgWidth.constant/ img.size.width);
            
        }else{
            self.imgWidth.constant = img.size.width;
            self.imgHeight.constant = img.size.height;
        }

        
//        [self.contentImageView updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.width.equalTo(self.imgWidth);
//            make.height.equalTo(self.imgHeight);
//            
//        }];

        
        [self.contentLbl updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentImageView.mas_bottom).with.offset(10);
            make.height.equalTo(contentHeight);
        }];
        
         [self.contentImageView addTapAction:@selector(browseImage) forTarget:self];

    }
    
    
    CGFloat height = 231-100+self.imgHeight.constant - 20 + contentHeight;
    
    self.containerViewheight.constant = height;
    
//    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(height);
//    }];
    
}

-(void)browseImage{
    [SJAvatarBrowser
     showImage:self.contentImageView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
