//
//  CardOrderTableViewCell.m
//  colourlife
//
//  Created by 李勇 on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardOrderTableViewCell.h"
#import "CardOrderModel.h"

@interface CardOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;

@end

@implementation CardOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
/**
 advice = "";
 amount = 1;
 creationtime = 1452063823;
 id = 3055;
 memo = "";
 orderno = 30228;
 ordertype = 1;
 status = 1;
 totalprice = "0.02";
 
 */
- (void)dataDidChange{
    OrderModel *order = self.data;
    //编号
    self.orderNo.text = [NSString stringWithFormat:@"NO.%@",order.orderno];
    
    //价格
    self.amountL.text = [NSString stringWithFormat:@"合计：￥%@",order.totalprice];
    
    //时间
    self.timeL.text = [NSDate longlongToDayDateTime:order.creationtime];
    
    //状态
    NSString *a_status = [NSString stringWithFormat:@"%@",order.status];//状态
    if ([a_status isEqualToString:@"0"]) {//未处理
        //LIGHTGREEN;
        self.stateL.text = @"状态：未处理";
    }
    if ([a_status isEqualToString:@"1"]) { //确认
        //GREEN;
        self.stateL.text = @"状态：已确认";
    }
    if ([a_status isEqualToString:@"2"]) {//完成
        //BLUE;
        self.stateL.text = @"状态：已完成";
    }
    if ([a_status isEqualToString:@"-1"]) {//拒绝
        //RED;
        self.stateL.text = @"状态：已拒绝";
    }
    if ([a_status isEqualToString:@"-2"]) {//取消
        //GRAY;
        self.stateL.text = @"状态：已取消";
    }
    if ([a_status isEqualToString:@"-3"]) {//过期
        //YELLOW;
        self.stateL.text = @"状态：已过期";
    }
    
    //ordertype;// 订单类型，1普通订单，2在线支付订单
    NSInteger type = [order.ordertype integerValue];
    if (type == 1){
        self.orderTypeLbl.text = @"线下支付";
        self.typeImgV.image = [UIImage imageNamed:@"ordericon1"];
    }else{
        self.orderTypeLbl.text = @"线上支付";
        self.typeImgV.image = [UIImage imageNamed:@"ordericon2"];
    }
    
}
@end
