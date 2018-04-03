//
//  LanguageManager.h
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageManager : NSObject
+(NSBundle *)bundle;

//初始化
+(void)initUserLanguage;

//获取当前语言
+ (NSString*)getPreferredLanguage;

//获取系统语言
+ (NSString *)getSystemLanguage;

//设置语言
+ (void)setLanguage:(NSString *)language;
@end
