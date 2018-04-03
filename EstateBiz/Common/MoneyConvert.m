//
//  MoneyConvert.m
//  TestProject
//
//  Created by fengwanqi on 13-8-5.
//  Copyright (c) 2013年 fengwanqi. All rights reserved.
//

#import "MoneyConvert.h"

@implementation MoneyConvert



+(NSString *)convertToCapitalMoney:(NSString *)moneyStr
{
    double moneyValue = [moneyStr doubleValue];
    double money = moneyValue + 0.005;
    
    NSString *str = @"";
    NSString *str1 = @"零壹贰叁肆伍陆柒捌玖";
    NSString *str2 = @"分角圆拾佰仟万拾佰仟亿拾佰仟万拾佰仟亿拾佰仟";
    
    NSString *tempCapital = nil;
    NSString *tempUite = nil;
    
    int zhengshu = 0; //整数部分
    int xiaoshu = 0; //小数部分
    
    int tempValue = 0; //钱的每一位值
    
    zhengshu = (int)money;
    
    if (zhengshu == 0) {
        str = @"零元";
    }
    xiaoshu = (int)(100 * (money - (float)zhengshu));
    for (int i=1; zhengshu>0; i++) {
        tempValue = (zhengshu % 10);
        NSString *s = @"";
        tempCapital = [str1 substringWithRange:NSMakeRange(tempValue, 1)];
        s = [s stringByAppendingFormat:@"%@",tempCapital];
        tempUite = [str2 substringWithRange:NSMakeRange(i+1, 1)];
        //NSLog(@"-------s = %@",s);
        s = [s stringByAppendingFormat:@"%@",tempUite];
        
        str = [s stringByAppendingFormat:@"%@",str];
        zhengshu = (zhengshu/10);
        
        
    }
    
    tempValue = (xiaoshu /10);
    
    for (int i=1; i>-1; i--) {
        tempCapital = [str1 substringWithRange:NSMakeRange(tempValue, 1)];
        NSString *s = @"";
        s = [s stringByAppendingFormat:@"%@",tempCapital];
        tempUite = [str2 substringWithRange:NSMakeRange(i, 1)];
        s = [s stringByAppendingFormat:@"%@",tempUite];
        str = [str stringByAppendingFormat:@"%@",s];
        tempValue = (xiaoshu % 10);
        
    }
    
    return str;
}

@end
