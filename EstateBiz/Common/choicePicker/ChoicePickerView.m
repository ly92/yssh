//
//  ChoicePickerView.m
//  Wujiang
//
//  Created by zhengzeqin on 15/5/27.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//  make by 郑泽钦 分享

#import "ChoicePickerView.h"

@interface ChoicePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHegithCons;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) AreaObject *locate;
//区域 数组
@property (strong, nonatomic) NSArray *regionArr;
//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;

@property (strong, nonatomic) NSArray *dataArray;//数据数组
@property (assign, nonatomic) NSInteger componentsNum;//选择器的组数

@end
@implementation ChoicePickerView


- (instancetype)initWithComponentsNum:(NSInteger)componentsNum DataArray:(NSArray *)dataArray{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ChoicePickerView" owner:nil options:nil]firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.componentsNum = componentsNum;
        self.dataArray = [NSArray arrayWithArray:dataArray];
        self.locate.region = self.dataArray[0];
        [self customView];
    }
    
    return self;
}

- (instancetype)init{
    
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ChoicePickerView" owner:nil options:nil]firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.regionArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AreaPlist.plist" ofType:nil]];
        self.provinceArr = self.regionArr[0][@"provinces"];
        self.cityArr = self.provinceArr[0][@"cities"];
        self.areaArr = self.cityArr[0][@"areas"];
        self.locate.region = self.regionArr[0][@"region"];
        self.locate.province = self.provinceArr[0][@"province"];
        self.locate.city = self.cityArr[0][@"city"];
        if (self.areaArr.count) {
            self.locate.area = self.areaArr[0];
        }else{
            self.locate.area = @"";
        }
        [self customView];
    }
    return self;
}

- (void)customView{
    self.contentViewHegithCons.constant = 0;
    [self layoutIfNeeded];
}

#pragma mark - setter && getter

- (AreaObject *)locate{
    if (!_locate) {
        _locate = [[AreaObject alloc]init];
    }
    return _locate;
}

#pragma mark - action

//选择完成
- (IBAction)finishBtnPress:(UIButton *)sender {
    if (self.doneBlock) {
        self.doneBlock(self,sender,self.locate);
    }
    [self hide];
}

//隐藏
- (IBAction)dissmissBtnPress:(UIButton *)sender {
    
    [self hide];
}

#pragma  mark - function

- (void)show{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewHegithCons.constant = 250;
        [self layoutIfNeeded];
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentViewHegithCons.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.cancleBlock) {
            self.cancleBlock(self,nil,nil);
        }
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.componentsNum == 1){
        return self.componentsNum;
    }
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.componentsNum == 1){
        return self.dataArray.count;
    }else{
    switch (component) {
        case 0:
            return self.regionArr.count;
            break;
        case 1:
            return self.provinceArr.count;
            break;
        case 2:
            return self.cityArr.count;
            break;
        case 3:
            if (self.areaArr.count) {
                return self.areaArr.count;
                break;
            }
        default:
            return 0;
            break;
    }
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.componentsNum == 1){
        return self.dataArray[row];
    }else{
    switch (component) {
        case 0:
            return [[self.regionArr objectAtIndex:row] objectForKey:@"region"];
            break;
        case 1:
            return [[self.provinceArr objectAtIndex:row] objectForKey:@"province"];
            break;
        case 2:
            return [[self.cityArr objectAtIndex:row] objectForKey:@"city"];
            break;
        case 3:
            if (self.areaArr.count) {
                return [self.areaArr objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
    }
}
#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.componentsNum == 1){
        self.locate.region = self.dataArray[row];
    }else{
    switch (component) {
        case 0:{
            self.provinceArr = self.regionArr[row][@"provinces"];
            [self.pickView reloadComponent:1];
            [self.pickView selectRow:0 inComponent:1 animated:YES];
            
            
            self.cityArr = [[self.provinceArr objectAtIndex:0] objectForKey:@"cities"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            
            
            self.areaArr = [[self.cityArr objectAtIndex:0] objectForKey:@"areas"];
            [self.pickView reloadComponent:3];
            [self.pickView selectRow:0 inComponent:3 animated:YES];
            
            self.locate.region = self.regionArr[row][@"region"];
            self.locate.province = self.provinceArr[0][@"province"];
            self.locate.city = self.cityArr[0][@"city"];
            if (self.areaArr.count) {
                self.locate.area = self.areaArr[0];
            }else{
                self.locate.area = @"";
            }

            
            break;
        }
        case 1:
        {
            self.cityArr = [[self.provinceArr objectAtIndex:row] objectForKey:@"cities"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            
            
            self.areaArr = [[self.cityArr objectAtIndex:0] objectForKey:@"areas"];
            [self.pickView reloadComponent:3];
            [self.pickView selectRow:0 inComponent:3 animated:YES];
            
            self.locate.province = self.provinceArr[row][@"province"];
            self.locate.city = self.cityArr[0][@"city"];
            if (self.areaArr.count) {
                self.locate.area = self.areaArr[0];
            }else{
                self.locate.area = @"";
            }

            break;
        }
        case 2:{
            self.areaArr = [[self.cityArr objectAtIndex:row] objectForKey:@"areas"];
            [self.pickView reloadComponent:3];
            [self.pickView selectRow:0 inComponent:3 animated:YES];
            
            self.locate.city = self.cityArr[row][@"city"];
            if (self.areaArr.count) {
                self.locate.area = self.areaArr[0];
            }else{
                self.locate.area = @"";
            }

            break;
        }
        case 3:{
            if (self.areaArr.count) {
                self.locate.area = self.areaArr[row];
            }else{
                self.locate.area = @"";
            }

            break;
        }
        default:
            break;
    }
}
}


@end
