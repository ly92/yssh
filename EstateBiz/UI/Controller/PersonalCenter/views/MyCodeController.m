//
//  MyCodeController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MyCodeController.h"
#import "QRCodeGenerator.h"

@interface MyCodeController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

@implementation MyCodeController

+(instancetype)spawn{
    return [MyCodeController loadFromStoryBoard:@"PersonalCenter"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    self.userImageView.layer.cornerRadius = 2;
    
    [self prepareData];
    
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
    
    self.navigationItem.title = @"我的二维码";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}



#pragma mark-prepareData
-(void)prepareData{
    
    UserModel *user = [[LocalData shareInstance] getUserAccount];
    
    if (user) {
        
        [self.userImageView setImageWithURL:[NSURL URLWithString:user.iconurl] placeholder:[UIImage imageNamed:@"icon_default"]];
        self.nameLbl.text = user.realname.length>0?user.realname:user.loginname;
        self.mobileLbl.text = user.mobile;
        
        NSString *content = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@",APPSTOREID];
        
        UIImage *qr = [QRCodeGenerator qrImageForString:content imageSize:self.codeImageView.width];
        
        self.codeImageView.image = qr;
    }
    
    
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
