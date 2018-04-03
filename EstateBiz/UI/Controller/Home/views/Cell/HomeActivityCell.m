//
//  HomeActivityCell.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HomeActivityCell.h"
#import "ActivityCollectionViewCell.h"
#import "HomeCardStyle.h"

//,
@interface HomeActivityCell () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomeActivityCell

+ (CGFloat)heightForHomeActivityWithDataCount:(NSInteger)count cardStyle:(LIMITYACTIVITY_STYLE)cardStyle
{
    CGFloat height = [HomeCardStyle cardHeightWithStyle:cardStyle dataCount:count];
    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
//    UICollectionViewFlowLayout *cardLayout = [[UICollectionViewFlowLayout alloc] init];
//    
//    CGFloat width = (SCREENWIDTH-18)/2.0;
//    
//    
//    cardLayout.itemSize = CGSizeMake(width, width);
//    cardLayout.minimumInteritemSpacing = 0;
//    cardLayout.minimumLineSpacing = 6;
//    
//    //
//    //        CardLayout * cardLayout = [HomeCardStyle cardStyleWithCollection:self.collectionView style:limityActivity.style];
//    
//    
//    [self.collectionView setCollectionViewLayout:cardLayout];

    
    [self.collectionView registerNib:[ActivityCollectionViewCell nib] forCellWithReuseIdentifier:@"ActivityCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dataDidChange
{
    if ( [self.data isKindOfClass:[LimitActivityModel class]] )
    {
        
        LimitActivityModel * limityActivity = (LimitActivityModel *) self.data;
        

    
        CardLayout * cardLayout = [HomeCardStyle cardStyleWithCollection:self.collectionView style:limityActivity.style];
        
        [self.collectionView setCollectionViewLayout:cardLayout];
        
        [self.collectionView reloadData];
    }
}

#pragma mark-collectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    LimitActivityModel * limityActivity = (LimitActivityModel *) self.data;
    NSInteger index = limityActivity.attr.count;
    
    return index;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [[AppDelegate sharedAppDelegate]showNoticeMsg:@"indexpath.item" WithInterval:1.5f];
    LimitActivityModel * limityActivity = (LimitActivityModel *) self.data;
    NSArray * attrs = limityActivity.attr;
    ActivityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCollectionViewCell" forIndexPath:indexPath];
        

    cell.data = attrs[indexPath.item];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCollectionViewCell * cell = (ActivityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(activityDidSelectCell:)]) {
        [self.delegate activityDidSelectCell:cell.data];
    }
}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSUInteger count = [self.collectionView numberOfItemsInSection:indexPath.section];
//
//    
//      LimitActivityModel * limityActivity = (LimitActivityModel *) self.data;
//    
//     switch ( limityActivity.style ) {
//             
//         case LIMITYACTIVITY_STYLE_DEFAULT1:
//         {
//             for ( int i = 0; i < count; i++ )
//             {
//                 
//                 return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                 
//                 //            CGRect frame;
//                 
//                 //            if ( i == 0 )
//                 //            {
//                 //                frame = CGRectMake(origin.x, origin.y, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                 //                lastFrame = frame;
//                 //            }
//                 //            else
//                 //            {
//                 //                frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                 //                lastFrame = frame;
//                 //            }
//                 //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                 //
//                 //            attributes.frame = frame;
//                 //
//                 //            [array addObject:attributes];
//             }
//             break;
//         }
//         case LIMITYACTIVITY_STYLE_DEFAULT2:
//         {
//             for ( int i = 0; i < count; i++ )
//             {
//                 CGRect frame;
//                 
//                 if ( i == 0 )
//                 {
//                     return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                     
//                     //                frame = CGRectMake(origin.x, origin.y, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                     //                lastFrame = frame;
//                 }
//                 else
//                 {
//                     return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                     //                frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                     //                lastFrame = frame;
//                 }
//                 //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                 //
//                 //            attributes.frame = frame;
//                 //
//                 //            [array addObject:attributes];
//             }
//             break;
//         }
//         case LIMITYACTIVITY_STYLE_DEFAULT3:
//         {
//             for ( int i = 0; i < count; i++ )
//             {
//                 CGRect frame;
//                 
//                 NSUInteger row = i / 2 == 0 ? 0 : 1;
//                 if ( i % 2 == 0 )
//                 {
//                     return CGSizeMake([CardLayout sizeThree].width, [CardLayout sizeThree].height);
//                     
//                     //                frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + (row * padding), [CardLayout sizeThree].width, [CardLayout sizeThree].height);
//                     //                lastFrame = frame;
//                 }
//                 else
//                 {
//                     
//                     return CGSizeMake([CardLayout sizeThree].width, [CardLayout sizeThree].height);
//                     
//                     //                frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeThree].width, [CardLayout sizeThree].height);
//                     //                lastFrame = frame;
//                 }
//                 
//                 //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                 //
//                 //            attributes.frame = frame;
//                 //
//                 //            [array addObject:attributes];
//             }
//             break;
//         }
//         case LIMITYACTIVITY_STYLE_DEFAULT4:
//         {
//             for ( int i = 0; i < count; i++ )
//             {
//                 CGRect frame;
//                 NSUInteger row = i / 2 == 0 ? 0 : 1;
//                 if ( i % 2 == 0 )
//                 {
//                     
//                     return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     
//                     //                frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + (row * padding), [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     //                lastFrame = frame;
//                 }
//                 else
//                 {
//                     
//                     return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].width);
//                     
//                     //                frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     //                lastFrame = frame;
//                 }
//                 
//                 //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                 //
//                 //            attributes.frame = frame;
//                 //
//                 //            //                [[AppDelegate sharedAppDelegate]showNoticeMsg:@"4" WithInterval:1.0f];
//                 //
//                 //            [array addObject:attributes];
//             }
//             break;
//         }
//         case LIMITYACTIVITY_STYLE_DEFAULT5:
//         {
//             for ( int i = 0; i < count; i++ )
//             {
//                 CGRect frame;
//                 
//                 if ( i == 0 )
//                 {
//                     
//                     return CGSizeMake([CardLayout sizeThree].width, [CardLayout sizeThree].height);
//                     
//                     //                frame = CGRectMake(origin.x, origin.y, [CardLayout sizeThree].width, [CardLayout sizeThree].height);
//                     //                lastFrame = frame;
//                 }
//                 else if ( i == 1 )
//                 {
//                     return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     
//                     //                frame = CGRectMake(CGRectGetMaxX(lastFrame) + padding, 0, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     //                lastFrame = frame;
//                 }
//                 else if ( i == 2 )
//                 {
//                     
//                     return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     
//                     //                frame = CGRectMake(lastFrame.origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                 }
//                 else
//                 {
//                     //                frame = CGRectZero;
//                     //                lastFrame = frame;
//                 }
//                 //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                 //
//                 //            attributes.frame = frame;
//                 //
//                 //            [array addObject:attributes];
//             }
//             break;
//         }
//         case LIMITYACTIVITY_STYLE_DEFAULT6:
//         {
//             for ( int i = 0; i < count; i++ )
//             {
//                 CGRect frame;
//                 
//                 if ( i == 0 )
//                 {
//                     
//                     return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                     
//                     //                frame = CGRectMake(origin.x, origin.y, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                     //                lastFrame = frame;
//                 }
//                 else if ( i == 1 )
//                 {
//                     return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     //                frame = CGRectMake(0, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     //                lastFrame = frame;
//                 }
//                 else if ( i == 2 )
//                 {
//                     return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                     
//                     //                frame = CGRectMake(CGRectGetMaxX(lastFrame) + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                 }
//                 else
//                 {
//                     //                frame = CGRectZero;
//                     //                lastFrame = frame;
//                     //            }
//                     //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                     //
//                     //            attributes.frame = frame;
//                     //
//                     //            [array addObject:attributes];
//                 }
//                 break;
//             }
//         case LIMITYACTIVITY_STYLE_DEFAULT7:
//             {
//                 for ( int i = 0; i < count; i++ )
//                 {
//                     CGRect frame;
//                     NSUInteger row = i / 2 == 0 ? 0 : 1;
//                     if ( i % 2 == 0 )
//                     {
//                         
//                         return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                         //                frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + (row * padding), [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                         //                lastFrame = frame;
//                     }
//                     else
//                     {
//                         return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                         //                frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                         //                lastFrame = frame;
//                     }
//                     
//                     //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                     //
//                     //            attributes.frame = frame;
//                     //
//                     //            [array addObject:attributes];
//                 }
//                 break;
//             }
//         case LIMITYACTIVITY_STYLE_DEFAULT8:
//             {
//                 for ( int i = 0; i < count; i++ )
//                 {
//                     CGRect frame;
//                     
//                     if ( i == 0 )
//                     {
//                         return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                         //                frame = CGRectMake(0, 0, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                         //                lastFrame = frame;
//                     }
//                     else
//                     {
//                         if ( (i - 1) % 2 == 0 )
//                         {
//                             return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                             //                    frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                             //                    lastFrame = frame;
//                         }
//                         else
//                         {
//                             return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                             
//                             //                    frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                             //                    lastFrame = frame;
//                         }
//                         
//                     }
//                     
//                     //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                     //            
//                     //            attributes.frame = frame;
//                     //            
//                     //            [array addObject:attributes];
//                 }
//                 break;
//             }
//         case LIMITYACTIVITY_STYLE_DEFAULT9:
//             {
//                 for ( int i = 0; i < count; i++ )
//                 {
//                     CGRect frame;
//                     
//                     if ( i == 0 )
//                     {
//                         return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                         
//                         //                frame = CGRectMake(0, 0, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                         //                lastFrame = frame;
//                     }
//                     else if ( i == count - 1 )
//                     {
//                         return CGSizeMake([CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                         
//                         //                frame = CGRectMake(0, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
//                         //                lastFrame = frame;
//                     }
//                     else
//                     {
//                         if ( (i - 1) % 2 == 0 )
//                         {
//                             return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                             //                    frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                             //                    lastFrame = frame;
//                         }
//                         else
//                         {
//                             return CGSizeMake([CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                             
//                             //                    frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
//                             //                    lastFrame = frame;
//                         }
//                         
//                     }
//                     
//                     //            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
//                     //            
//                     //            attributes.frame = frame;
//                     //            
//                     //            [array addObject:attributes];
//                 }
//                 break;
//             }
//         }
//     }
//    
//    return CGSizeMake(0, 0);
//}

@end
