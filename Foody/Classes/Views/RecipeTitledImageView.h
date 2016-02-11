//
//  RecipeTitledImageView.h
//  Foody
//
//  Created by Pasha on 2/10/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecipeTitledImageViewStyle) {
    RecipeTitledImageViewSmallStyle,
    RecipeTitledImageViewLargeStyle
};

@interface RecipeTitledImageView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *gradientView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (assign, nonatomic) UIEdgeInsets titleInsets;
@property (assign, nonatomic) UIEdgeInsets subtitleInsets;
@property (assign, nonatomic) RecipeTitledImageViewStyle style;

@end
