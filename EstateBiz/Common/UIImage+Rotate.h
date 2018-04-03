//
//  UIImage+Rotate.h
//  BizKaKaTool
//
//  Created by Austin on 1/17/14.
//  Copyright (c) 2014 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
