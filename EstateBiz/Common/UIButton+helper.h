//
//  UIButton+helper.h
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIButton(helper)
-(void)bgStrechableNormalImageName:(NSString *)normal SelectedImageName:(NSString *)selected HighlightImageName:(NSString *)highlight NormalTitle:(NSString *)normalTitle SelectedTitle:(NSString *)selectedTitle HighlightTitle:(NSString *)highLightTitle StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y  Localize:(BOOL)yesOrNo;
@end
