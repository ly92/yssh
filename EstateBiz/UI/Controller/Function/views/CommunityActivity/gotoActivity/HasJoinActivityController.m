//
//  HasJoinActivityController.m
//  WeiTown
//
//  Created by 王闪闪 on 16/3/24.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "HasJoinActivityController.h"
#import "JoinActivityCell.h"
#import "ActivityDetailViewController.h"

@interface HasJoinActivityController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *comActivityDataArray;

@end

@implementation HasJoinActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBar];
    
    self.comActivityDataArray =
    [NSMutableArray array];
    
    self.emptyView.backgroundColor =RGBCOLOR(240, 240, 240);
    
    [self.tv registerNib:[UINib nibWithNibName:@"JoinActivityCell" bundle:nil] forCellReuseIdentifier:@"JoinActivityCell"];
    
    //加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"活动列表";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-加载数据
//加载数据
-(void)loadData{
    if (self.isJoinCommunity) {
        
        [self presentLoadingTips:nil];
        [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
        GetActivityListAPI *getActivityListApi = [[GetActivityListAPI alloc]initWithBid:self.communityId];
        [getActivityListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                [self dismissTips];
                [self.comActivityDataArray removeAllObjects];
                NSArray *activitylist = result[@"activitylist"];
                
                for (NSDictionary *dic in activitylist) {
                    CommunityActivity *comActivity = [CommunityActivity mj_objectWithKeyValues:dic];
                    [self.comActivityDataArray addObject:comActivity];
                }
                if (self.comActivityDataArray.count == 0) {
                    self.emptyView.hidden = NO;
                    self.emptyLbl.text = @"还没有活动哦" ;
                    self.tv.hidden = YES;
                }else{
                    self.emptyView.hidden = YES;
                    self.tv.hidden = NO;
                }
                
                [self.tv reloadData];
                
                
            }else{
                 [self presentFailureTips:result[@"reason"]];
            }
            
            
        } failure:^(__kindof YTKBaseRequest *request) {
            self.emptyView.hidden = NO;
            self.emptyLbl.text = @"还没有活动哦" ;
            self.tv.hidden = YES;
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }];

        

    }else{
        
        [self presentLoadingTips:nil];
        [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
        GetHasJoinActivityListAPI *getHasJoinActivityListApi = [[GetHasJoinActivityListAPI alloc]init];
        [getHasJoinActivityListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                [self dismissTips];
                
                [self.comActivityDataArray removeAllObjects];
                NSArray *activitylist = result[@"activitylist"];
                
                for (NSDictionary *dic in activitylist) {
                    CommunityActivity *comActivity = [CommunityActivity mj_objectWithKeyValues:dic];
                    [self.comActivityDataArray addObject:comActivity];
                }
                
                if (self.comActivityDataArray.count == 0) {
                    self.emptyView.hidden = NO;
                    self.emptyLbl.text = @"还没有活动？赶紧参加活动吧";
                    self.tv.hidden = YES;
                }else{
                    self.emptyView.hidden = YES;
                    self.tv.hidden = NO;
                }
                [self.tv reloadData];
                
            }else{
                 [self presentFailureTips:result[@"reason"]];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            
            self.emptyView.hidden = NO;
            self.emptyLbl.text = @"还没有活动？赶紧参加活动吧" ;
            self.tv.hidden = YES;
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            
        }];
        
    }
}

#pragma mark-tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comActivityDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"JoinActivityCell";
    JoinActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.comActivityDataArray.count>0) {
        CommunityActivity *comActivity = self.comActivityDataArray[indexPath.row];
        
        [cell.leftImageView setImageWithURL:[NSURL URLWithString:comActivity.image] placeholder:[UIImage imageNamed:@"contentIamge_no_bg.png"]];
    
        cell.titleLbl.text = comActivity.title;
        cell.addrLbl.text = comActivity.location;
        cell.userLbl.text = comActivity.joined;
        
        CGSize size = [cell.userLbl sizeThatFits:CGSizeMake(MAXFLOAT, cell.userLbl.height)];
        if (size.width<20) {
            cell.cellUserLblWidth.constant = 20;
        }else if(size.width>60){
            cell.cellUserLblWidth.constant = 60;
        }else{
            cell.cellUserLblWidth.constant = size.width;
        }
        
        NSDate *lastdate=[NSDate dateWithTimeIntervalSince1970:[comActivity.actiontime integerValue]];
    
        NSInteger day = [lastdate weekday];
        NSString *weekDay=nil;
        switch (day) {
            case 1:
            {
                weekDay = @"周日";
                break;
            }
            case 2:
            {
                weekDay = @"周一";
                break;
            }
            case 3:
            {
                weekDay = @"周二";
                break;
            }
            case 4:
            {
                weekDay = @"周三";
                break;
            }
            case 5:
            {
                weekDay = @"周四";
                break;
            }
            case 6:
            {
                weekDay = @"周五";
                break;
            }
            case 7:
            {
                weekDay = @"周六";
                break;
            }
                
            default:
                break;
        }
        //将获取的时间按照对应的时间格式进行转换
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"MM-dd HH:mm";
        NSString *lastdateStr=[formatter stringFromDate:lastdate];
        cell.dateLbl.text = [NSString stringWithFormat:@"%@ %@",weekDay,lastdateStr];
        
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.comActivityDataArray.count>0) {
         CommunityActivity *comActivity = self.comActivityDataArray[indexPath.row];
        
        ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc]initWithActivityId:comActivity.id];
        activityDetail.refreshBlock = ^(){
            [self loadData];
        };
        [self.navigationController pushViewController:activityDetail animated:YES];
    }
}
#pragma mark-点击

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
