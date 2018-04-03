//
//  BalanceTableViewCell.m
//  colourlife
//
//  Created by 李勇 on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "BalanceTableViewCell.h"
#import "CardTransactionModel.h"

@interface BalanceTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UILabel *amountL;
@end

@implementation BalanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dataDidChange{
    TransactionModel *transaction = self.data;
    if ([transaction.maintype intValue] == 1){//现金充值
        self.nameL.text = @"充值";
        self.amountL.text = [NSString stringWithFormat:@"%@",transaction.amount];
    }else{//现金消费或二维码消费
        self.nameL.text = @"购买商品";
        self.amountL.text = [NSString stringWithFormat:@"%@",transaction.amount];
    }
    self.timeL.text = [NSDate longlongToDateTime:transaction.creationtime];
    }

@end
