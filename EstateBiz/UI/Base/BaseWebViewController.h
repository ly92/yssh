//
//  BaseWebViewController.h
//  EstateBiz
//
//  Created by ly on 16/4/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

//@protocol NativeMemberExport <JSExport>
//- (void)javaScriptTs;
//@end

@protocol WebViewJSExport <JSExport>

JSExportAs(javaScriptTs, -(void)javaScriptTs:(NSString *)param);
//- (void)javaScriptTs;
@end

@interface BaseWebViewController : UIViewController<UIWebViewDelegate,WebViewJSExport>

@property (strong, nonatomic) JSContext *context;

- (instancetype)initWithTitle:(NSString *)webTitle Url:(NSString *)url;

@end
