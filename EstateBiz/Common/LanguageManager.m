//
//  LanguageManager.m
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "LanguageManager.h"
#import "Macros.h"

static NSBundle *bundle = nil;

@implementation LanguageManager

+(NSBundle *)bundle
{
    return bundle;
}

//初始化
+(void)initUserLanguage
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSString *currentLang = [defs objectForKey:@"currentLanguage"];
    
    if (currentLang.length == 0) {
        NSString *current = [self getSystemLanguage];
        NSLog(@"current=%@",current);
        
        if ([current isEqualToString:CHINESE]) {
            current = CHINESE;
        }
        else if ([current isEqualToString:ENGLISH]) {
            current = ENGLISH;
        }
        else if ([current isEqualToString:JAPANESE]) {
            current = JAPANESE;
        }
        else {
            //既不是中文也不是日文的情况，默认中文
            current = CHINESE;
        }
        
        currentLang = current;
        [defs setObject:currentLang forKey:@"currentLanguage"];
        [defs synchronize];
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:currentLang ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

//获取当前语言
+ (NSString *)getPreferredLanguage
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"];
}

//获取系统语言
+ (NSString *)getSystemLanguage
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *current = [languages objectAtIndex:0];
    return current;
}

//设置语言
+ (void)setLanguage:(NSString *)language
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    
    [defs setObject:language forKey:@"currentLanguage"];
    [defs synchronize];
}


@end
