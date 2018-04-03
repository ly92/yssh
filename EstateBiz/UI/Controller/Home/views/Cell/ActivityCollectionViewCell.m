//
//  ActivityCollectionViewCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ActivityCollectionViewCell.h"

@interface ActivityCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;

@end

@implementation ActivityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.activityImgView.layer.cornerRadius = 3;
}

- (void)dataDidChange
{
    
//    [[AppDelegate sharedAppDelegate] showNoticeMsg:@"activityCollectionCell" WithInterval:2.5f];
    
    if ([self.data isKindOfClass:[AttrModel class]]) {
        AttrModel * attr = (AttrModel *)self.data;
//        [self.activityImgView setImageURL:[NSURL URLWithString:attr.img] ];
        
        [self.activityImgView setImageWithURL:[NSURL URLWithString:attr.img] placeholder:[UIImage imageNamed:@"activity_noimage"]];
    }
   
}


@end
