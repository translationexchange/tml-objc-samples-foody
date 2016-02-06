//
//  RecipeCollectionViewCell.h
//  Foody
//
//  Created by Pasha on 2/5/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;
@property (assign, nonatomic) UIEdgeInsets textLabelInset;
- (void)setImage:(UIImage *)image;
@end
