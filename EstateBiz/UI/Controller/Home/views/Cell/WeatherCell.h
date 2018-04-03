//
//  WeatherCell.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MsgDetail)(NSString *,NSString *,NSString *,NSString *,NSString *);

@interface WeatherCell : UITableViewCell

@property (copy, nonatomic) MsgDetail msgDetail;//

@end
