//
//  NoticeViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/8.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"

@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic,retain)NSString *ownerid;
@property (nonatomic,retain)NSString *skip;
@property (nonatomic,retain)NSString *limit;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation NoticeViewController

+(instancetype)spawn{
    return [NoticeViewController loadFromStoryBoard:@"Function"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.tv.backgroundColor = VIEW_BG_COLOR;
    
    
    [self navigationBar];
    [self setMessage];
    
    [self setHeaderAndFooter];
    [self.tv registerNib:@"NoticeCell" identifier:@"NoticeCell"];
    [self.tv tableViewRemoveExcessLine];
    
    [self initloading];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark-navibar
-(void)navigationBar{
    
    self.titleName = (NSString *)self.data;
    
    self.navigationItem.title = self.titleName;
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark-setMessage
-(void)setMessage{
    Community *community = [STICache.global objectForKey:@"selected_community"];
    self.ownerid = community.bid;
    if (self.ownerid == nil) {
        self.ownerid = @"";
    }
    
    self.skip = @"0";
    self.limit = @"10";
    
    
    
}

#pragma mark-loadData
-(void)loadNewData{
    [self.dataArray removeAllObjects];
    self.skip = @"0";

    [self loadData];
}

-(void)loadMoreData{
     self.skip = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count ];
    [self loadData];
}

-(void)loadData{
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    GetNoticeListAPI *getNoticeListApi = [[GetNoticeListAPI alloc]initWithOwnerid:self.ownerid skip:self.skip limit:self.limit];
    [getNoticeListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self doneLoadingTableViewData];
            [self dismissTips];
            NSArray *notice = [result objectForKey:@"notice"];
            if (![ISNull isNilOfSender:notice]) {
                for (NSDictionary *dic in notice) {
                    NoticeModel *model = [NoticeModel mj_objectWithKeyValues:dic];
                    [self.dataArray addObject:model];
                }
                if (self.dataArray.count == 0) {
                    self.emptyView.hidden = NO;
                    
                    self.tv.hidden = YES;
                }
                else {
                    self.tv.hidden = NO;
                    self.emptyView.hidden = YES;
                    
                }
                
                if (notice.count < 10) {
                    [self loadAll];
                }else{
                    [self resetLoadAll];
                }
                [self.tv reloadData];
            }else{
                self.emptyView.hidden = NO;
                
                self.tv.hidden = YES;
            }

            [self.tv reloadData];

        }else{
             [self presentFailureTips:result[@"reason"]];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeCell *cell = (NoticeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return [cell cellHeight];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"NoticeCell";
    NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];

    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row <  self.dataArray.count) {
        NoticeModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if (model) {
            cell.data = model;
        }
        
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
