//
//  VuforiaWindow.h
//  Youlinyi
//
//  Created by imac on 15-11-6.
//  Copyright (c) 2015ƒÍ KJTeam. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PlayRenderController;

@interface VuforiaWindow : UIViewController


- (void)StartInitialize;

- (void)onInitARDone;
- (void)rootViewControllerPresentViewController:(UIViewController*)viewController inContext:(BOOL)currentContext;
- (void)rootViewControllerDismissPresentedViewController;

// 获得AR窗口绘制区域
- (CGRect)GetARViewFrame;
- (void)FlipCamera;
- (void)SetLockVideo : (BOOL)isLock;
// 显示等待动画
- (void)ShowWaitingAnimation : (BOOL)isShow;
// 将要退出
- (void)WillQuit;

@property PlayRenderController * RenderController;

@end
