//
//  MoreMenu.m
//  WeiTown
//
//  Created by kakatool on 15/12/17.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import "MoreMenu.h"
#import "MoreMenuCell.h"

@implementation MoreMenu

- (id)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray ImgNameArray:(NSArray *)imgArray SelectedImgArray:(NSArray *)selectedImgArr{

    self = [super initWithFrame:frame];
    if (self) {
        
        _control = [[UIControl alloc] initWithFrame:self.bounds];
        _control.backgroundColor = [UIColor clearColor];
        [_control addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_control];
        _control.hidden = YES;
        
        if (menuArray != nil) {
            _dataArray = [[NSMutableArray alloc] initWithArray:menuArray];
        }
        else{
            _dataArray = [[NSMutableArray alloc] init];
        }
        
        if (imgArray != nil){
            self.imgArray = [[NSMutableArray alloc]initWithArray:imgArray];
        }
        else{
            _imgArray = [[NSMutableArray alloc] init];
        }
        
        if (selectedImgArr != nil){
            self.selectedImgArray = [[NSMutableArray alloc]initWithArray:selectedImgArr];
        }
        else{
            _selectedImgArray = [[NSMutableArray alloc] init];
        }
        
        //        self.contentV = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 150, 0, 130, 175)];
        CGFloat h = _dataArray.count * 35;
        self.contentV = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 130, 0, 115, h)];
        self.contentV.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.contentV.bounds];
        imgV.image = [UIImage imageNamed:@"moer_bg_white"];
        //        imgV.alpha = 0.8;
        [self.contentV addSubview:imgV];
        
        //         UITableView *menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, 130, 160)];
        if (!self.menuTable) {
            _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 115, h)];
        }
        
        _menuTable.dataSource = self;
        _menuTable.delegate = self;
        _menuTable.backgroundColor = [UIColor clearColor];
        _menuTable.bounces = NO;
        _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.contentV addSubview:_menuTable];
        
        [self addSubview:self.contentV];
        
        self.clipsToBounds = YES;
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadge:) name:@"REFRESHTASKBADGE" object:nil];
    }
    return self;

}

//-(void)refreshBadge:(NSNotification *)noti{
//    
//    
//}

- (void)setBageNum:(NSInteger)bageNum Index:(NSInteger)index{
    self.bageNum = bageNum;
    self.index = index;
    
    [self.menuTable reloadData];
}

#pragma mark - 菜单的下拉开关

- (void)show:(BOOL)animated
{
//    if (animated) {
//        self.contentV.frameSizeHeight = 0;
//    }
//    
    if (animated == YES) {
        
//        [UIView animateWithDuration:0.35 animations:^{
        
            self.hidden = NO;
            _control.hidden = NO;
            self.contentV.height = _dataArray.count * 35;
            
//        } completion:^(BOOL finished) {
//            
//        }];
    }
    else {
        
//        [UIView animateWithDuration:0.35 animations:^{
        
            self.contentV.height = 0;
            
//        } completion:^(BOOL finished) {
            _control.hidden = YES;
            self.hidden = YES;
//        }];
    }
}

#pragma mark - 关闭下拉菜单

- (void)hide:(id)sender
{
    if (self.moreDelegate && [self.moreDelegate respondsToSelector:@selector(didHiddenMoreMenuView)]) {
        [self.moreDelegate didHiddenMoreMenuView];
    }
}

#pragma mark - tableView:datasource && delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *menuCellID = @"MoreMenuCell";
    MoreMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:menuCellID];
    if (menuCell == nil) {
        menuCell = [[[NSBundle mainBundle] loadNibNamed:menuCellID owner:nil options:nil] lastObject];
    
    }
    menuCell.backgroundColor = [UIColor clearColor];
    menuCell.nameL.text = self.dataArray[indexPath.row];
    if (![ISNull isNilOfSender:self.imgArray] && self.imgArray.count > 0){
        [menuCell.imgBtn setImage:[UIImage imageNamed:self.imgArray[indexPath.row]] forState:UIControlStateNormal];
    }
    if (![ISNull isNilOfSender:self.selectedImgArray] && self.selectedImgArray.count > 0){
        [menuCell.imgBtn setImage:[UIImage imageNamed:self.selectedImgArray[indexPath.row ]] forState:UIControlStateSelected];
    }
    
    //未读气泡
    if (self.bageNum && self.index == indexPath.row){
        menuCell.icon.hidden = NO;
    }else{
        menuCell.icon.hidden = YES;
    }
    
    return menuCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //MARK:选中菜单栏第几项并做相应操作
    if (_moreDelegate && [_moreDelegate respondsToSelector:@selector(didSelectedMenuIndex:)]) {
        [self.moreDelegate didSelectedMenuIndex:indexPath.row];
    }
}

@end
