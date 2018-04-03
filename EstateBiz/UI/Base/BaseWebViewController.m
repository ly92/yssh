//
//  BaseWebViewController.m
//  EstateBiz
//
//  Created by ly on 16/4/21.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "BaseWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

@interface BaseWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *webTitle;//
@property (strong, nonatomic) NSString *url;//

@end

@implementation BaseWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
}


- (instancetype)initWithTitle:(NSString *)webTitle Url:(NSString *)url{
    if (self = [super init]){
        self.webTitle = webTitle;
        self.url = url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"webview url :%@",self.url);
//    [self defaultNaviBarShowTitle:self.webTitle];
//    
//    UIButton *backBtn = [self defaultNaviBarLeftBtn];
//    [backBtn setTitle:@"" forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"nav_icon_left_arrow"] forState:UIControlStateNormal];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    [self.webView loadRequest:request];
//    [NSString stringWithContentsOfFile:fileString encoding:NSUTF8StringEncoding error:nil];

    
    //测试js调用
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
//    NSString *html = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:html baseURL:nil];
}

//- (void)defaultNaviBarLeftBtnPressed{
//    if ([self.webView canGoBack]){
//        [self.webView goBack];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}



//- (void)webViewDidStartLoad:(UIWebView *)webView{
//
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    [self.context setExceptionHandler:^(JSContext *context, JSValue *value) {
//        NSLog(@"%@", value);
//    }];
    self.context[@"NativeMember"] = self;
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
////    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
////    
////    NSString *str = [webView stringByEvaluatingJavaScriptFromString:lJs];
//    //    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"Document"];
////    NSLog(@"%@",str);
//
//    
//    return YES;
//}


#pragma mark - js 调用方法

-(void)javaScriptTs:(NSString *)param
{
    NSLog(@"%@",@"javaScriptTs CALL");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
@end
