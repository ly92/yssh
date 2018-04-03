//
//  MoreMenu.h
//  WeiTown
//
//  Created by kakatool on 15/12/17.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^SetBageNum)(NSInteger BageNum,NSInteger index);

@protocol MoreMenuDelegate <NSObject>

- (void)didSelectedMenuIndex:(NSInteger)row;
- (void)didHiddenMoreMenuView;

@end

@interface MoreMenu : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) NSMutableArray *dataArray;//名字数组
@property (nonatomic, strong) NSMutableArray *imgArray;//图片数组
@property (nonatomic, strong) NSMutableArray *selectedImgArray;//选中时图片数组
@property (nonatomic, strong) UIControl *control;

@property (nonatomic, strong) UITableView *menuTable;
//@property (nonatomic,copy) SetBageNum setBageNum;

@property (nonatomic, assign) NSInteger bageNum;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) id<MoreMenuDelegate>moreDelegate;

- (id)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray ImgNameArray:(NSArray *)imgArray SelectedImgArray:(NSArray *)selectedImgArr;
- (void)show:(BOOL)animated;

- (void)setBageNum:(NSInteger)bageNum Index:(NSInteger)index;
@end
