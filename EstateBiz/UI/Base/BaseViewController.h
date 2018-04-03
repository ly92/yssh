//
//  BaseViewController.h
//  EstateBiz
//
//  Created by Ender on 10/22/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "JCNaviSubViewController.h"

@interface BaseViewController : JCNaviSubViewController


-(void)setBackItem;
-(void)setUpNaviBarLeftTitle:(NSString *)leftTitle;
-(void)setUpnaviBarLeftImage:(NSString *)imageName;
-(void)setUpNaviBarRightTitle:(NSString *)rightTitle;
-(void)setUpnaviBarRightImage:(NSString *)imageName;


-(void)setUpNaviBar:(NSString *)title andRightBtnHidden:(BOOL)hidden andRightBtnTitle:(NSString *)btnTitle;

-(void)setUpNaviBar:(NSString *)title andRightBtnHidden:(BOOL)hidden andRightBtnImage:(NSString *)btnImage;

@end
