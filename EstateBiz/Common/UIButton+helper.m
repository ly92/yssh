//
//  UIButton+helper.m
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "UIButton+helper.h"
#import "ISNull.h"
#import "Macros.h"
#import "LanguageManager.h"

@implementation UIButton(helper)


//使用图片拉伸，支持多语言标题
-(void)bgStrechableNormalImageName:(NSString *)normal SelectedImageName:(NSString *)selected HighlightImageName:(NSString *)highlight NormalTitle:(NSString *)normalTitle SelectedTitle:(NSString *)selectedTitle HighlightTitle:(NSString *)highLightTitle StrechaSizeX:(NSInteger)x StrechaSizeY:(NSInteger)y  Localize:(BOOL)yesOrNo
{
    if ([ISNull isNilOfSender:normal] == NO) {
        UIImage *normalImg = [UIImage imageNamed:normal];
        normalImg = [normalImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:normalImg forState:UIControlStateNormal];

    }
    
    if ([ISNull isNilOfSender:highlight] == NO) {
        UIImage *highlightImg = [UIImage imageNamed:highlight];
        highlightImg = [highlightImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:highlightImg forState:UIControlStateSelected];
    }
    
    if ([ISNull isNilOfSender:selected] == NO) {
        UIImage *selectedImg = [UIImage imageNamed:selected];
        selectedImg = [selectedImg stretchableImageWithLeftCapWidth:x topCapHeight:y];
        [self setBackgroundImage:selectedImg forState:UIControlStateSelected];
    }
    
    if (normalTitle) {
        if (yesOrNo) {
            [self setTitle:NSLocalizedStr(normalTitle, nil) forState:UIControlStateNormal];
        }
        else{
           [self setTitle:normalTitle forState:UIControlStateNormal];
        }
        
    }
    
    if (highLightTitle) {
        if (yesOrNo) {
            [self setTitle:NSLocalizedStr(highLightTitle, nil) forState:UIControlStateHighlighted];
        }
        else{
            [self setTitle:highLightTitle forState:UIControlStateHighlighted];
        }
    }
    
    
    if (selectedTitle) {
        if (yesOrNo) {
            [self setTitle:NSLocalizedStr(selectedTitle, nil) forState:UIControlStateSelected];
        }
        else{
            [self setTitle:selectedTitle forState:UIControlStateSelected];
        }
    }
    
    
}

@end
