//
//  EmportAddressBook.m
//  MyCardToon
//
//  Created by fengwanqi on 13-9-16.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//

#import "EmportAddressBook.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "NSString+helper.h"

@implementation EmportAddressBook

// 获取通讯录
+ (NSMutableArray *)getMemberInfo
{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    
    //授权
    __block BOOL accessGranted = NO;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        // we're on iOS 6
        NSLog(@"on iOS 6 or later, trying to grant access permission");
        
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        if (ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized) {
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//            dispatch_release(sema);
        }
        else{
            accessGranted = YES;
        }
        
        
    }
    else
    {
        addressBooks = ABAddressBookCreate();
        
        NSLog(@"on iOS 5 or older, it is OK");
        
        accessGranted = YES;
    }
    
    //授权失败返回nil
    if (accessGranted==NO) {
        if (addressBooks!=NULL) {
            CFRelease(addressBooks);
        }
        
        return nil;
    }
    
    CFIndex someone = ABAddressBookGetPersonCount(addressBooks);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    NSString *mobile = @"";
    NSString *membername = @"";
    
    for (int i=0; i<someone; i++) {
        
        NSMutableDictionary *memeberDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);//取出某一个人的信息
        
        //读取联系人姓名属性
        //读取firstname
        NSString *firstname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        //读取lastname
        NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        //读取middlename
        NSString *middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        
        
        NSMutableString *temp = [NSMutableString stringWithString:@""];
        
        
        if (lastname) {
            [temp appendFormat:@"%@",lastname];
        }

        if (middlename) {
            [temp appendFormat:@" %@",middlename];
        }
        
        if (firstname) {
            [temp appendFormat:@" %@",firstname];
        }
  
        
        if ([temp trim].length>0) {
            membername = [[NSString stringWithFormat:@"%@",temp] trim];
            [memeberDic setObject:membername forKey:@"membername"];
        }
        else{
            continue;
        }
        
        
        //读取电话信息，和emial类似，也分为工作电话，家庭电话，工作传真，家庭传真。。。。
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        if ((phone != nil)&&ABMultiValueGetCount(phone)>0) {
            
            for (int m = 0; m < ABMultiValueGetCount(phone); m++) {
                //获取电话号
                NSString * aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, m);
                
                //获取Label值
                //NSString * aLabel = [(NSString *)ABMultiValueCopyLabelAtIndex(phone, m) autorelease];
                //NSLog(@"aPhone = %@",aPhone);
                if (aPhone.length == 11) {
                    mobile = aPhone;
                    NSString *phone = [memeberDic objectForKey:@"mobile"];
                    if ([phone trim].length ==0) {
                        [memeberDic setObject:mobile forKey:@"mobile"];
                        [arr addObject:memeberDic];
                    }else{
                        NSMutableDictionary *memeberDicN = [NSMutableDictionary dictionaryWithCapacity:0];
                        NSString * membername = [[NSString stringWithFormat:@"%@",temp] trim];
                        [memeberDicN setObject:membername forKey:@"membername"];
                        [memeberDicN setObject:mobile forKey:@"mobile"];
                        [arr addObject:memeberDicN];
                    }
                    
                    //                    break;
                }
                if (aPhone!= nil && aPhone.length >= 8 && aPhone.length != 11){
                    mobile = aPhone;
                    NSString *phone = [memeberDic objectForKey:@"mobile"];
                    if ([phone trim].length ==0) {
                        [memeberDic setObject:mobile forKey:@"mobile"];
                        [arr addObject:memeberDic];
                    }else{
                        NSMutableDictionary *memeberDicN = [NSMutableDictionary dictionaryWithCapacity:0];
                        NSString * membername = [[NSString stringWithFormat:@"%@",temp] trim];
                        [memeberDicN setObject:membername forKey:@"membername"];
                        [memeberDicN setObject:mobile forKey:@"mobile"];
                        [arr addObject:memeberDicN];
                    }
                    
                    //                    break;
                }
            }
        }
        
        if (phone) {
            CFRelease(phone);
        }
        
    }
    
    CFRelease(addressBooks);
    CFRelease(allPeople);
    
    return arr;
    
}

@end
