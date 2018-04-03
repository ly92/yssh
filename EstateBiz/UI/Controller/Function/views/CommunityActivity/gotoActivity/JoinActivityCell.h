//
//  JoinActivityCell.h
//  WeiTown
//
//  Created by 王闪闪 on 16/3/24.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

//@property (retain, nonatomic) IBOutlet EGOImageView *leftImageView;

@property (retain, nonatomic) IBOutlet UILabel *titleLbl;

@property (retain, nonatomic) IBOutlet UILabel *addrLbl;

@property (retain, nonatomic) IBOutlet UILabel *dateLbl;

@property (retain, nonatomic) IBOutlet UILabel *userLbl;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cellUserLblWidth;

@end
