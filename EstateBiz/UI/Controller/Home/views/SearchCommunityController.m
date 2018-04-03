//
//  SearchCommunityController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchCommunityController.h"
#import "SearchCommunityResultController.h"
#import "SearchWordCell.h"

@interface SearchCommunityController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchCommunityResultControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *hotLbl;

@property (weak, nonatomic) IBOutlet UICollectionView *hotTable;
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotViewH;

@property (weak, nonatomic) IBOutlet UICollectionView *historyTable;

@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyViewH;


@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (nonatomic, strong) UITextField *searchTxt;
@property (nonatomic, copy) NSString *searchword;

@end

@implementation SearchCommunityController

+(instancetype)spawn{
    return [SearchCommunityController loadFromStoryBoard:@"Home"];
}

-(NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}

-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationbar];
    [self hideKeyBoard];
    
    [self.historyArr removeAllObjects];
    [self.historyArr addObjectsFromArray:[LocalData getCommunitySearchOfHistoryRecord]];
    
    if (self.historyArr.count != 0){
        NSInteger row = self.historyArr.count / 2;
        if (self.historyArr.count % 2 != 0){
            row ++;
        }
        self.historyView.hidden = NO;
        self.historyViewH.constant = row * 30 + 66;
    }else{
        self.historyViewH.constant = 0;
        self.historyView.hidden = YES;
    }
    
    [self.hotTable registerNib:[SearchWordCell nibWithName:@"SearchWordCell"] forCellWithReuseIdentifier:@"SearchWordCell"];
    [self.historyTable registerNib:[SearchWordCell nibWithName:@"SearchWordCell"] forCellWithReuseIdentifier:@"SearchWordCell"];
    
    [self.searchTxt becomeFirstResponder];
    //加载热门搜索
    [self loadHotSearchList];
    
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


#pragma mark-navibar
-(void)setNavigationbar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 27,SCREENWIDTH-90 , 30)];
    view.backgroundColor = NAV_SEARCHBGCOLOR;
    
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 15, 15)];
    searchImg.backgroundColor = [UIColor clearColor];
    searchImg.image = [UIImage imageNamed:@"d1_search"];
    [view addSubview:searchImg];
    
    
    if (!(GT_IOS7)){
        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 5,SCREENWIDTH-120 , 30)];
    }else{
        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 0,SCREENWIDTH-120 , 30)];
    }
    self.searchTxt.placeholder = @"搜索小区";
    self.searchTxt.backgroundColor = [UIColor clearColor];
    //187 194 199
    [self.searchTxt setValue:RGBACOLOR(187, 194, 199, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTxt setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.searchTxt.borderStyle =UITextBorderStyleNone;
    self.searchTxt.backgroundColor = NAV_SEARCHBGCOLOR;
    self.searchTxt.delegate = self;
    self.searchTxt.textColor = NAV_SEARCHTEXTCOLOR ;
    
    self.searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTxt.returnKeyType = UIReturnKeySearch;
    
    [view addSubview:self.searchTxt];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithCustomView:view];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"取消" handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark-hideKeyBoard
-(void)hideKeyBoard{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.searchTxt resignFirstResponder];
}


#pragma mark-热门搜索

- (void)loadHotSearchList{
    
     [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    AuthoriseCommunityAPI *authoriseCommunityApi = [[AuthoriseCommunityAPI alloc]init];
    [authoriseCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            if (![ISNull isNilOfSender:list]) {
                for (NSDictionary *dic in list) {
                    [self.hotArr addObject:[Community mj_objectWithKeyValues:dic]];
                }
                if (self.hotArr.count == 0) {
                    [self loadNearCommunity];
                }else{
                    if (self.hotArr.count != 0){
                        NSInteger row = self.hotArr.count / 2;
                        if (self.hotArr.count % 2 != 0){
                            row ++;
                        }
                        self.hotView.hidden = NO;
                        self.hotViewH.constant = row * 30 + 70;
                    }else{
                        self.hotViewH.constant = 0;
                        self.hotView.hidden = YES;
                    }
                   self.hotLbl.text = @"授权小区";
                }
            }else{
                [self loadNearCommunity];
            }
            [self.hotTable reloadData];
            
        }else{
             [self presentFailureTips:result[@"reason"]];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}


-(void)loadNearCommunity{
    //获取当前位置
    Location *location = [AppLocation sharedInstance].location;
    NSString * lon = [NSString stringWithFormat:@"%@",location.lon];
    NSString * lat = [NSString stringWithFormat:@"%@",location.lat];
    
    [self presentLoadingTips:nil];
     [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    NearCommunityAPI *nearCommunityApi = [[NearCommunityAPI alloc]initWithLongitude:lon latitude:lat];
    
    [nearCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            NSDictionary *nearCommunity = result[@"community"];
            
            if (![ISNull isNilOfSender:nearCommunity]) {
                Community *community = [Community mj_objectWithKeyValues:nearCommunity];
                [STICache.global setObject:community forKey:@"selected_community"];
                
                
                [self.hotArr addObject:community];
                self.hotLbl.text = @"附近小区";
                
                if (self.hotArr.count != 0){
                    NSInteger row = self.hotArr.count / 2;
                    if (self.hotArr.count % 2 != 0){
                        row ++;
                    }
                    self.hotView.hidden = NO;
                    self.hotViewH.constant = row * 30 + 70;
                }else{
                    self.hotViewH.constant = 0;
                    self.hotView.hidden = YES;
                }
                
            }
            [self.hotTable reloadData];
            
        }else{
             [self presentFailureTips:result[@"reason"]];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];

}

#pragma mark-click

- (IBAction)deleteButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    [LocalData removeCommunitySearchOfHistoryRecord];
    [self.historyArr removeAllObjects];
    [self.historyArr addObjectsFromArray:[LocalData getCommunitySearchOfHistoryRecord]];
    
    if (self.historyArr.count != 0){
        NSInteger row = self.historyArr.count / 2;
        if (self.historyArr.count % 2 != 0){
            row ++;
        }
        self.historyView.hidden = NO;
        self.historyViewH.constant = row * 30 + 66;
    }else{
        self.historyViewH.constant = 0;
        self.historyView.hidden = YES;
    }
    
    [self.historyTable reloadData];
}


#pragma mark- texrfield的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.searchTxt resignFirstResponder];
    
    self.searchword = textField.text;
    
    [self searchCommunity:self.searchword];
    
    return YES;
}

-(void)searchCommunity:(NSString *)searchWord{
    if (searchWord.length == 0) {
         [self presentFailureTips:@"请输入搜索内容"];
        return;
    }
    else {
        [self saveToLocalWithRecord:searchWord];
//        [self.historyTable reloadData];
    }
    
    SearchCommunityResultController * searchCommunity = [SearchCommunityResultController spawn];
    searchCommunity.delegate = self;
    searchCommunity.searchword = searchWord;
    [self.navigationController pushViewController:searchCommunity animated:YES];
    
}

#pragma mark-历史搜索缓存

//SearchListDelegate : 搜索历史关键字保存本地delegate回调
- (void)updateHistoryRecord:(NSString *)record
{
    [self saveToLocalWithRecord:record];
}

//保存历史关键字到本地
- (void)saveToLocalWithRecord:(NSString *)record
{
    if (record == nil && [record trim].length == 0) {
        return;
    }
    
    [LocalData updateCommunitySearchOfHistoryRecord:[record trim]];
    [self.historyArr removeAllObjects];
    [self.historyArr addObjectsFromArray:[LocalData getCommunitySearchOfHistoryRecord]];
    
    if (self.historyArr.count != 0){
        NSInteger row = self.historyArr.count / 2;
        if (self.historyArr.count % 2 != 0){
            row ++;
        }
        self.historyView.hidden = NO;
        self.historyViewH.constant = row * 30 + 66;
    }else{
        self.historyViewH.constant = 0;
        self.historyView.hidden = YES;
    }
    
    [self.historyTable reloadData];
}


#pragma mark-collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.historyTable) {
        return self.historyArr.count;
    }else if (collectionView == self.hotTable) {
        return self.hotArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"SearchWordCell";
    SearchWordCell * cell = (SearchWordCell *) [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.isCommunity = YES;
    if (collectionView == self.hotTable){
        
        cell.data = self.hotArr[indexPath.row];
        
    }else{
        
        cell.searchWordLbl.text = self.historyArr[indexPath.row];
    }
    //    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchTxt resignFirstResponder];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if(collectionView == self.hotTable){
        
        Community *community = self.hotArr[indexPath.row];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTCOMMUNITY" object:community];
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
    else{
        NSString *searchword = @"";
        if (collectionView == self.historyTable) {
            searchword = [self.historyArr objectAtIndex:indexPath.row];
        }
        else {
            
            Community *searCard = self.hotArr[indexPath.row];
            if (searCard) {
                searchword = searCard.name;
            }
        }
        
        if ([searchword trim].length == 0) {
            return;
        }
        self.searchTxt.text = searchword;
        
        [self searchCommunity:searchword];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat w = (SCREENWIDTH - 55)/2;
    return CGSizeMake(w, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 5, 5, 0);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
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
