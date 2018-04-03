//
//  SubscribeTableViewCell.m
//  colourlife
//
//  Created by 李勇 on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "SubscribeTableViewCell.h"
#import "SubscribeListModel.h"

@interface SubscribeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation SubscribeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 @interface CARD_SUBSCRIBE_LIST : NSObject
 @property (nonatomic, strong) NSString *aid;
 @property (nonatomic, strong) NSString *anum;
 @property (nonatomic, strong) NSString *bid;
 @property (nonatomic, strong) NSString *bizmemo;
 @property (nonatomic, strong) NSString *booktime;
 @property (nonatomic, strong) NSString *cid;
 @property (nonatomic, strong) NSString *content;
 @property (nonatomic, strong) NSString *creationtime;
 @property (nonatomic, strong) NSString *status;
 @property (nonatomic, strong) CARD_SUBSCRIBE_LIST_USERINFO *userinfo;
 @end
 */
- (void)dataDidChange{
    SubscribeRecordModel *subscribe = self.data;
    
    self.timeL.text = [NSDate longlongToDateTime:subscribe.creationtime];
    self.contentTextView.text = subscribe.content;
    int status= [subscribe.status intValue];
    
    switch (status) {
        case 2:
            self.stateL.text = @"已确认";
            break;
            
        default:
            self.stateL.text = @"已提交";
            break;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self;
}
@end
