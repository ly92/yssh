//
//  CardPromotionTableViewCell.m
//  colourlife
//
//  Created by 李勇 on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardPromotionTableViewCell.h"
#import "CardPromotionModel.h"

#define PHONEREGULAR @"^400-[0-9]{3}-[0-9]{4}|^800[0-9]{7}|^1(3|4|7|5|8)([0-9]{9})|^0[0-9]{2,3}-[0-9]{8}|^03[0-9]{2}-[0-9]{7}|100[0-9]{2,4}"
@interface CardPromotionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *stypeL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentL;

@end

@implementation CardPromotionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)dataDidChange{
    PromotionModel *promotion = self.data;
    if (promotion && [promotion.msg_type isEqualToString:@"msg"]) {
        self.stypeL.text = @"通知信息";
    }
    else if (promotion && [promotion.msg_type isEqualToString:@"vote"])
    {
        self.stypeL.text = @"请您投票";
    }
    else if (promotion && [promotion.msg_type isEqualToString:@"events"])
    {
        self.stypeL.text = @"活动报名";
    }
    
    NSDate *date = [NSDate dateFromStr:[NSDate longlongToDateTime:promotion.creationtime] withFormat:[NSDate timestampFormatString]];
    self.timeL.text = [date timeAgo];
    
    self.contentL.text = promotion.content;

    
    
    }
@end
