//
//  MemberCardCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MemberCardCell.h"

@interface MemberCardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *frontImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *discountLbl;
@property (weak, nonatomic) IBOutlet UIButton *gotoShopButton;

@end

@implementation MemberCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    MemberCardModel *memberCard = (MemberCardModel *)self.data;
    
    if (memberCard) {
        [self.frontImgView sd_setImageWithURL:[NSURL URLWithString:memberCard.frontimageurl] placeholderImage:[UIImage imageNamed:@"cardImage_no_bg"]];
        self.nameLbl.text = memberCard.cardname;

        if ([memberCard.amounts floatValue] == 0){
            self.balanceLbl.hidden = YES;
        }else{
            self.balanceLbl.hidden = NO;
            self.balanceLbl.text = [NSString stringWithFormat:@"余额: ¥%@",memberCard.amounts];
        }
        
        if ([memberCard.discounts floatValue] == 0 || [memberCard.discounts floatValue] >= 100.0){
            self.discountLbl.hidden = YES;
        }else{
            self.discountLbl.hidden = NO;
            self.discountLbl.text = [NSString stringWithFormat:@"折扣: %.1f折",[memberCard.discounts floatValue]/10];
        }
    }
}

-(void)layoutSubviews{
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            
            // 拿到subView之后再获取子控件
            //            subView.backgroundColor = [UIColor clearColor];
            subView.height = 125;
            // 因为上面删除按钮是第二个加的所以下标是1
            UIView *deleteConfirmationView = subView.subviews[0];
            
            deleteConfirmationView.height = 125;
            //改背景颜色
            //            deleteConfirmationView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:42.0/255.0 blue:62.0/255.0 alpha:1.0];
            for (UIView *deleteView in deleteConfirmationView.subviews) {
                NSLog(@"%@",deleteConfirmationView.subviews);
                deleteView.height = 125;
                //                UIImageView *deleteImage = [[UIImageView alloc] init];
                //                deleteImage.contentMode = UIViewContentModeScaleAspectFit;
                //                deleteImage.image = [UIImage imageNamed:delete];
                //                deleteImage.frame = CGRectMake(0, 0, deleteView.frame.size.width, deleteView.frame.size.height);
                //                [deleteView addSubview:deleteImage];
            }
            
            // 这里是右边的
            UIView *shareConfirmationView = subView.subviews[1];
            shareConfirmationView.height = 125;
            //            shareConfirmationView.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:201.0/255.0 blue:75.0/255.0 alpha:1.0];
            for (UIView *shareView in shareConfirmationView.subviews) {
                shareView.height = 125;
                //                UIImageView *shareImage = [[UIImageView alloc] init];
                //                shareImage.contentMode = UIViewContentModeScaleAspectFit;
                //                shareImage.image = [UIImage imageNamed:share];
                //                shareImage.frame = CGRectMake(0, 0, shareView.frame.size.width, shareView.frame.size.height);
                //                [shareView addSubview:shareImage];
            }
        }
    }
}


@end
