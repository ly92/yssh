//
//  NSString+helper.m
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "NSString+helper.h"
#import "ISNull.h"
#import <CommonCrypto/CommonHMAC.h>
#import "pinyin.h"

@implementation NSString (helper)

- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b {
    NSRange r;
    r.location = a;
    r.length = b - a;
    return [self substringWithRange:r];
}

- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts {
    NSRange r;
    r.location = starts;
    r.length = [self length] - r.location;
    
    NSRange index = [self rangeOfString:substring options:NSLiteralSearch range:r];
    if (index.location == NSNotFound) {
        return -1;
    }
    return index.location + index.length;
}

- (NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)startsWith:(NSString*)s {
    if([self length] < [s length]) return NO;
    return [s isEqualToString:[self substringFrom:0 to:[s length]]];
}

- (BOOL)containsString:(NSString *)aString
{
    NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
    return range.location != NSNotFound;
}

- (NSString *)urlEncode
{
    NSString* encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef) self,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));
    return encodedString;
}


- (BOOL) isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//判断手机号码的合法性
- (BOOL)isMobileNumber
{
    if ([self trim].length!=11) {
        return NO;
    }
    return YES;
    //    NSString *mobile = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    //    return [regextestmobile evaluateWithObject:self];
}

//判断身份证号码是否合法
- (BOOL)validateIdentityCard
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}



-(NSMutableDictionary *)separatedByJinAndAnte
{
    NSMutableArray *keywordArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![ISNull isNilOfSender:self]) {
        
        NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //判断第一个字符是否是@或#
        BOOL b = NO;
        char s1 = [str characterAtIndex:0];
        NSString *ss1 = [NSString stringWithFormat:@"%c",s1];
        if ([ss1 isEqualToString:@"@"] || [ss1 isEqualToString:@"#"]) {
            b = YES;
        }
        
        //判断最后一个字符是否为#
        BOOL bj = NO;
        char sj = [str characterAtIndex:str.length-1];
        NSString *ssj = [NSString stringWithFormat:@"%c",sj];
        if (![ssj isEqualToString:@"#"]) {
            bj = YES;
        }
        
        
        
        NSMutableArray *array =  [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"@"]];
        [array removeObject:@""];
        //NSLog(@"array = %@",array);
        
        for (int n=0; n<array.count; n++) {
            //NSLog(@"string = %@",string);
            NSString *string = [array objectAtIndex:n];
            
            NSArray *arr = [string componentsSeparatedByString:@"#"];
            //NSLog(@"arr = %@",arr);
            
            if (arr.count==1) {
                if (!b && (n == 0)) {
                    //表示既没有@也没有#
                    if (![keywordArray containsObject:[arr objectAtIndex:0]]) {
                        [keywordArray addObject:[arr objectAtIndex:0]];
                    }
                    
                }
                else
                {
                    if (![mArray containsObject:[arr objectAtIndex:0]]) {
                        [mArray addObject:[arr objectAtIndex:0]];
                    }
                }
                
            }
            else if (arr.count > 1)
            {
                if (!b && (n == 0)) {
                    //表示既没有@也没有#
                    if (![keywordArray containsObject:[arr objectAtIndex:0]]) {
                        [keywordArray addObject:[arr objectAtIndex:0]];
                    }
                }
                else
                {
                    if (![mArray containsObject:[arr objectAtIndex:0]]) {
                        [mArray addObject:[arr objectAtIndex:0]];
                        
                    }
                }
                
                for (int i=1; i<arr.count; i++) {
                    if (n == (array.count-1) && i == (arr.count-1) && bj == YES) {
                        if (![keywordArray containsObject:[arr objectAtIndex:i]]) {
                            [keywordArray addObject:[arr objectAtIndex:i]];
                        }
                    }
                    else
                    {
                        if (![tArray containsObject:[arr objectAtIndex:i]]) {
                            [tArray addObject:[arr objectAtIndex:i]];
                        }
                    }
                }
            }
            
        }
        
        [mArray removeObject:@""];
        [tArray removeObject:@""];
        [keywordArray removeObject:@""];
        //NSLog(@"marray = %@",mArray);
        //NSLog(@"tarray = %@",tArray);
        
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:tArray,@"topic",mArray,@"member",keywordArray,@"keyword", nil];
    
    NSLog(@"dic = %@",dic);
    return dic;
    
}

//处理电话号码
-(NSMutableString *)handleMobile
{
    
    NSMutableString *str = [NSMutableString stringWithString:self];
    
    
    if (str.length > 4) {
        
        NSUInteger begin = (str.length-4)/2;//中间四位
        NSRange range = NSMakeRange(begin, 4);
        
        //NSRange range = NSMakeRange(str.length-4, 4);//后四位
        [str replaceCharactersInRange:range withString:@"xxxx"];
    }
    
    
    return str;
}

//提取拼音
-(NSString *)pickUpPinYingName
{
    if (!self || self.length == 0) {
        return @"";
    }
    NSString *pinYinResult=[NSString string];
    
    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([self characterAtIndex:0])]uppercaseString];
    
    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
    
    return pinYinResult;
}

//判断字符串是否为纯数字
-(BOOL)isNumText
{
    if (!self && [self trim].length == 0) {
        return NO;
    }
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] trim].length > 0) {
        //不是纯数字
        return NO;
    }
    else {
        //纯数字
        return YES;
    }
}

//判断图片是否合法
- (BOOL)complyWithTheRulesOfImage
{
    if (!self && [self trim].length == 0) {
        return NO;
    }
    
    NSString *urlStr = [[self lowercaseString] pathExtension];
    if ([urlStr isEqualToString:@"jpg"] || [urlStr isEqualToString:@"jpeg"] || [urlStr isEqualToString:@"png"]) {
        return YES;
    }
    
    return NO;
}

//判断一个正整数是几位数
- (int)judgePositiveIntegerNumberOfDigits
{
    int num = 0;
    int m = [[self trim] intValue];
    do {
        m /= 10;
        num++;
    } while (m != 0);
    
    return num;
}

//判断是否网址
-(BOOL)isURL
{
    NSString *urlStr = [self lowercaseString];
//    NSString *urlRegEx = @"^((https|http|ftp|rtsp|mms)?://)?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?(([0-9]{1,3}\\.){3}[0-9]{1,3}|([0-9a-z_!~*'()-]+\\.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.[a-z]{2,6})(:[0-9]{1,4})?((/?)|(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
    
    NSString *urlRegEx = @"(http|ftp|https)://[\\w-_]+(.[\\w-_]+)+([\\w-.,@?^=%&:/~+#]* [\\w-\\@?^=%&/~+#])?";
    
    NSPredicate *urlPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegEx];
    
    
    return [urlPre evaluateWithObject:urlStr];
}

#pragma mark - 随机字符串

+(NSString *)randString
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    
    [nsdf2 setDateFormat:@"HHmmss"];
    
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
    
    
    int timestamp = arc4random() % 10000;
    
    NSString *rand=[NSString stringWithFormat:@"%@%d",t2,timestamp];
    
    //    NSLog(@"rand:%@",rand);
    
    return rand;
}

+(NSString *)randStringLong
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    
    [nsdf2 setDateFormat:@"yyyyMMddHHmmssSSSS"];
    
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
    
    
    int timestamp = arc4random() % 100000;
    
    NSString *rand=[NSString stringWithFormat:@"%@%d",t2,timestamp];
    
    //    NSLog(@"Long rand:%@",rand);
    
    return rand;
}


//MD5
- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}


// 验证是固话或者手机号
/*
*  @param mobileNum 手机号
*
*  @return 是否
*/
+ (BOOL)isMobilePhoneOrtelePhone:(NSString *)mobileNum {
    if (mobileNum==nil || mobileNum.length ==0) {
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^((13)|(14)|(15)|(17)|(18))\\d{9}$";// @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^((0\\d{2,3}-?)\\d{7,8}(-\\d{2,5})?)$";// @"^0(10|2[0-5789]-|\\d{3})\\d{7,8}$";
    
    
    /**
     25         * 客服电话
     26         * 400
     27         * 号码：七位或八位
     28         */
    
    NSString *server = @"^400-[0-9]{3}-[0-9]{4}";
    
    NSString *server1 = @"^03[0-9]{2}-[0-9]{7}";
    NSString *server2 = @"^100[0-9]{2,4}";
    
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSPredicate *regextestServer = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", server];
    NSPredicate *regextestServer1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", server1];
    NSPredicate *regextestServer2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", server2];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestPHS evaluateWithObject:mobileNum]==YES)
        || ([regextestServer evaluateWithObject:mobileNum]==YES)
        || ([regextestServer1 evaluateWithObject:mobileNum]==YES)
        || ([regextestServer2 evaluateWithObject:mobileNum]==YES)) {
        return YES;
    }
    else{
        return NO;
    }
}


@end
