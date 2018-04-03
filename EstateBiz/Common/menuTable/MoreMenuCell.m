//
//  MoreMenuCell.m
//  WeiTown
//
//  Created by kakatool on 15/12/17.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import "MoreMenuCell.h"

@implementation MoreMenuCell

- (void)awakeFromNib {
    // Initialization code
    self.icon.clipsToBounds = YES;
    self.icon.layer.cornerRadius = 3;
    self.icon.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imgBtn.selected = selected;
    // Configure the view for the selected state
}

@end
