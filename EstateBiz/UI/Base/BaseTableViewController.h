//
//  BaseTableViewController.h
//  EstateBiz
//
//  Created by Ender on 10/22/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "BaseViewController.h"
#import "UIScrollView+EmptyDataSet.h"

//<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@interface BaseTableViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tv;
@property(nonatomic,strong) UIImage *emptyImage;

-(void)initloading;
//加载完成
-(void)doneLoadingTableViewData;
//下拉刷新
-(void)loadNewData;
//上拉加tableView
-(void)loadMoreData;

//是否还有更多数据
-(void)loadAll;
-(void)resetLoadAll;

@end
