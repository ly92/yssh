//
//  NoticeCell.m
//  WeiTown
//
//  Created by kakatool on 15/6/10.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import "NoticeCell.h"
#define T_IOS_VERSION_7_OR_ABOVE [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0

@interface NoticeCell ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (retain, nonatomic) IBOutlet UILabel *titelLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UIImageView *telImg;
@property (retain, nonatomic) IBOutlet UILabel *telLbl;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *descHeight;

@property (nonatomic, strong) NSURL *callUrl;
@end

@implementation NoticeCell
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.contentView.backgroundColor = VIEW_BG_COLOR;
    self.backgroundColor = [UIColor blueColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 8.f;
    self.bgView.layer.borderWidth = 1.f;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  
}

-(void)dataDidChange{
    if ([self.data isKindOfClass:[NoticeModel class]]) {
        NoticeModel *model = (NoticeModel *)self.data;
        
        [self.image setImageWithURL:[NSURL URLWithString:model.imageurl] placeholder:[UIImage imageNamed:@"notice"]];
        
        
        self.titelLabel.text = [NSString stringWithFormat:@"%@",model.title];
        self.timeLabel.text =  [NSDate longlongToDateTime:model.creationtime];
        
        self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
        
        NSString *imageurl = [NSString stringWithFormat:@"%@",model.imageurl];
        if ([imageurl complyWithTheRulesOfImage]) {
            self.image.imageURL = [NSURL URLWithString:imageurl];
        }
        
        if (model.tel&&[model.tel trim].length>0) {
            
            self.telImg.hidden=NO;
            self.telLbl.hidden=NO;
            self.telLbl.text = model.tel;
            
            [self.telLbl addTapAction:@selector(callContact:) forTarget:self];
            
        }
        else{
            self.telImg.hidden=YES;
            self.telLbl.hidden=YES;
        }
        
        CGFloat contentHeight = [self.contentLabel resizeHeight];
        
        if (contentHeight > 21) {
            self.descHeight.constant = contentHeight;
        }else{
            self.descHeight.constant = contentHeight;
        }
        
    }
    
  
    
    
}

-(void)callContact:(id)sender
{
    
    if ([self.data isKindOfClass:[NoticeModel class]]) {
        NoticeModel *model = (NoticeModel *)self.data;
        
        if (model.tel && [model.tel trim].length > 0) {
            NSString *number = [NSString stringWithFormat:@"tel://%@",model.tel];
            self.callUrl=[NSURL URLWithString:number];
            if (self.callUrl) {
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:model.tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }

        }
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[UIApplication sharedApplication] openURL:self.callUrl]) {
            
            //[[UIApplication sharedApplication] openURL:callUrl];
        }else{
             [self presentFailureTips:@"该设备不支持此功能哦"];
        }
    }
}

-(CGFloat)cellHeight{
    
    if ([self.data isKindOfClass:[NoticeModel class]]) {
        NoticeModel *model = (NoticeModel *)self.data;
    
        if (model.tel && [model.tel trim].length > 0) {
            return (151-21 + self.descHeight.constant);
        }else{
            return (151-21 -21 + self.descHeight.constant);
        }
    
    }
    return 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
