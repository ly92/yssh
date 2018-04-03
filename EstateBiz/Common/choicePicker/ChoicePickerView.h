//
//  ChoicePickerView.h
//  Wujiang
//
//  Created by zhengzeqin on 15/5/27.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaObject.h"
@class ChoicePickerView;
typedef void (^ChoicePickerViewBlock)(ChoicePickerView *view,UIButton *btn,AreaObject *locate);
@interface ChoicePickerView : UIView

//选择完成的block
@property (copy, nonatomic)ChoicePickerViewBlock doneBlock;

//取消的block
@property (copy, nonatomic)ChoicePickerViewBlock cancleBlock;

- (void)show;

- (instancetype)initWithComponentsNum:(NSInteger)componentsNum DataArray:(NSArray *)dataArray;

@end
