//
//  HasJoinActivityController.h
//  WeiTown
//
//  Created by 王闪闪 on 16/3/24.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HasJoinActivityController :UIViewController

@property(nonatomic,assign) Boolean isJoinCommunity;

@property(nonatomic, retain) NSString *communityId;

@property (retain, nonatomic) IBOutlet UIView *emptyView;
@property (retain, nonatomic) IBOutlet UILabel *emptyLbl;
@property (retain, nonatomic) IBOutlet UITableView *tv;

@end
