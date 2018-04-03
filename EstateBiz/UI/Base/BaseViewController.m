//
//  BaseViewController.m
//  EstateBiz
//
//  Created by Ender on 10/22/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "BaseViewController.h"
#import "JCBaseNaviBarView.h"
#import "JCNormalNavigationBarView.h"

@interface BaseViewController ()
{
    UIImageView *navBarHairlineImageView;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.currentNaviBarView&&[self.currentNaviBarView isKindOfClass:[JCNormalNavigationBarView class]]) {
        JCNormalNavigationBarView *normalNav = (JCNormalNavigationBarView *)self.currentNaviBarView;
        [normalNav.navBg setBackgroundColor:NAV_BG_COLOR];
        [normalNav.titleLabel setTextColor:NAV_TEXTCOLOR];
        normalNav.titleLabel.font = [UIFont systemFontOfSize:17];
         navBarHairlineImageView = [self findHairlineImageViewUnder:normalNav.navBar];
    }
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//去除横线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark-导航栏左右按钮
//返回按钮
-(void)setBackItem{
    //左按钮
    UIButton *backBtn = [self defaultNaviBarLeftBtn];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_left_arrow"] forState:UIControlStateNormal];
}

//左按钮(设置文字)
-(void)setUpNaviBarLeftTitle:(NSString *)leftTitle{
    [self defaultNaviBarSetLeftViewHidden:NO];
    UIButton *rightBtn = [self defaultNaviBarLeftBtn];
    [rightBtn setTitle:leftTitle forState:UIControlStateNormal];
    [rightBtn setTitleColor:NAV_TEXTCOLOR forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
}

//左按钮(设置图片)
-(void)setUpnaviBarLeftImage:(NSString *)imageName{
    [self defaultNaviBarSetLeftViewHidden:NO];
    UIButton *rightBtn = [self defaultNaviBarLeftBtn];
    [rightBtn setTitle:@"" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NAV_TEXTCOLOR forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}


//右按钮(设置文字)
-(void)setUpNaviBarRightTitle:(NSString *)rightTitle{
    [self defaultNaviBarSetRightViewHidden:NO];
    UIButton *rightBtn = [self defaultNaviBarRightBtn];
    [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    [rightBtn setTitleColor:NAV_TEXTCOLOR forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
}
//右按钮(设置图片)
-(void)setUpnaviBarRightImage:(NSString *)imageName{
    [self defaultNaviBarSetRightViewHidden:NO];
    UIButton *rightBtn = [self defaultNaviBarRightBtn];
    [rightBtn setTitle:@"" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NAV_TEXTCOLOR forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

#pragma mark-按钮事件

-(void)setUpNaviBar:(NSString *)title andRightBtnHidden:(BOOL)hidden andRightBtnTitle:(NSString *)btnTitle{
    
    [self defaultNaviBarShowTitle:title];
    
    //左按钮
    UIButton *backBtn = [self defaultNaviBarLeftBtn];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_left_arrow"] forState:UIControlStateNormal];
    
    if (!hidden) {
        //右按钮
        [self defaultNaviBarSetRightViewHidden:NO];
        UIButton *rightBtn = [self defaultNaviBarRightBtn];
        [rightBtn setTitle:btnTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:NAV_TEXTCOLOR forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
}

-(void)setUpNaviBar:(NSString *)title andRightBtnHidden:(BOOL)hidden andRightBtnImage:(NSString *)btnImage{
    
    [self defaultNaviBarShowTitle:title];
    
    //左按钮
    UIButton *backBtn = [self defaultNaviBarLeftBtn];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_left_arrow"] forState:UIControlStateNormal];
    
    if (!hidden) {
        //右按钮
        [self defaultNaviBarSetRightViewHidden:NO];
        UIButton *rightBtn = [self defaultNaviBarRightBtn];
        [rightBtn setTitle:@"" forState:UIControlStateNormal];
    
        [rightBtn setImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
        
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
