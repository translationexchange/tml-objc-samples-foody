//
//  RecipeCollectionViewCell.h
//  Foody
//
//  Created by Pasha on 2/5/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeCollectionViewCellProto.h"

@interface RecipeCollectionViewCell : UICollectionViewCell <RecipeCollectionViewCellProto>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;
@property (assign, nonatomic) UIEdgeInsets textLabelInset;
@property (strong, nonatomic) UILabel *subtextLabel;
@property (assign, nonatomic) UIEdgeInsets subtextLabelInset;
- (void)setImage:(UIImage *)image;
@end