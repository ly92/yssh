//
//  BaseTableViewController.m
//  EstateBiz
//
//  Created by Ender on 10/22/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //上拉下拖
    self.tv.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tv.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //没有数据的时候去掉每行的分割线
    [self setupTableViewHeaderAndHeader];
    
    //空状态
//    self.tv.emptyDataSetSource=self;
//    self.tv.emptyDataSetDelegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableViewHeaderAndHeader{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tv.tableFooterView = footerView;
}
#pragma mark-数据加载
-(void)initloading{
    [self.tv.mj_header beginRefreshing];
}

//下拉刷新
-(void)loadNewData{
    self.tv.userInteractionEnabled = NO;
}
//上拉加tableView
-(void)loadMoreData{
    
}
//加载完全
-(void)loadAll{
    [self.tv.mj_footer endRefreshingWithNoMoreData];
}

//重置加载完全（允许再次下拉）
-(void)resetLoadAll
{
    [self.tv.mj_footer resetNoMoreData];
}

//加载完成
-(void)doneLoadingTableViewData{
    
    self.tv.userInteractionEnabled = YES;
    if ([self.tv.mj_header isRefreshing]) {
        [self.tv.mj_header endRefreshing];
    }
    
    if([self.tv.mj_footer isRefreshing]){
        [self.tv.mj_footer endRefreshing];
    }
}

#pragma mark - DZNEmptyDataSetSource Methods

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"没有任何数据";
//    return [[NSAttributedString alloc] initWithString:text attributes:nil];
//}
//
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
//
//    NSString *text = @"";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
//    
//    
//    return attributedString;
//}
//
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    NSString *text = @"";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
//    
//    
//    return attributedString;
//}
//
//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIColor clearColor];
//}
//
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
//    
//    return self.emptyImage;
//}
//
//#pragma mark - DZNEmptyDataSetDelegate Methods
//
//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
//{
//    return YES;
//}
//
//- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
//{
//    return YES;
//}
//
//- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
//{
//    return NO;
//}


@end
