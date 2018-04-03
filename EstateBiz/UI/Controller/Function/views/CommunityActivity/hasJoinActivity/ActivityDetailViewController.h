//
//  ActivityDetailViewController.h
//  WeiTown
//
//  Created by 王闪闪 on 16/3/25.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PopupImageView.h"

typedef void (^RefreshBlock) ();

@interface ActivityDetailViewController : UIViewController

-(instancetype)initWithActivityId:(NSString *)activityId;

//报名
@property (retain, nonatomic) IBOutlet UIButton *signupBtn;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (retain, nonatomic) IBOutlet UIScrollView *sv;

//view1
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (retain, nonatomic) IBOutlet UILabel *titleDetailLbl;

@property (retain, nonatomic) IBOutlet UILabel *isJoinedLbl;

@property (retain, nonatomic) IBOutlet UILabel *locationLbl;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *locationLblHeight;


@property (retain, nonatomic) IBOutlet UILabel *dateLbl;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *view1Height;

//view2
@property (retain, nonatomic) IBOutlet UILabel *contentLbl;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contentLblHeight;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

//view3

@property (retain, nonatomic) IBOutlet UILabel *nameLbl;

@property (retain, nonatomic) IBOutlet UILabel *mobileLbl;

@property (retain, nonatomic) IBOutlet UILabel *addrLbl;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *addrLblHeight;


@property (retain, nonatomic) IBOutlet UITextField *nameTxtField;

@property (retain, nonatomic) IBOutlet UITextField *mobileTxtField;


@property (retain, nonatomic) IBOutlet UITextView *addrTextView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *addrTextViewHeight;

@property (retain, nonatomic) IBOutlet UILabel *addrPlaceHolder;


@property (nonatomic,copy)RefreshBlock refreshBlock;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *view3Height;



//@property (retain, nonatomic) PopupImageView *imagePopup;


@end
