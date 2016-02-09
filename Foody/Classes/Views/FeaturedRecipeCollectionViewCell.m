//
//  FeaturedRecipeCollectionViewCell.m
//  Foody
//
//  Created by Pasha on 2/8/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "FeaturedRecipeCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface RecipeCollectionViewCell()
- (CGRect)frameForImageView;
- (CGRect)frameForTextLabel;
- (CGRect)frameForSubtextLabel;
@end

@interface FeaturedRecipeCollectionViewCell(){
    UIView *_gradientView;
    CAGradientLayer *_imageGradientLayer;
}

@end

@implementation FeaturedRecipeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *gradientView = [[UIView alloc] initWithFrame:frame];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame= frame;
        gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,
                                 (id)[UIColor colorWithWhite:0. alpha:0.66].CGColor];
        gradientLayer.locations = @[@(0.5), @(1.)];
        _imageGradientLayer = gradientLayer;
        [gradientView.layer insertSublayer:gradientLayer atIndex:0];
        _gradientView = gradientView;
        [self.contentView insertSubview:gradientView aboveSubview:self.imageView];
        
        UILabel *textLabel = self.textLabel;
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:24.];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.numberOfLines = 1;
        textLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *subtextLabel = self.subtextLabel;
        subtextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.];
        subtextLabel.textColor = [UIColor whiteColor];
        subtextLabel.numberOfLines = 1;
        subtextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *imageView = self.imageView;
    _gradientView.frame = imageView.frame;
    _imageGradientLayer.frame = imageView.frame;
}

- (CGRect)frameForImageView {
    CGRect ourBounds = self.contentView.bounds;
    return ourBounds;
}

- (CGRect)frameForTextLabel {
    CGRect ourBounds = self.contentView.bounds;
    UIEdgeInsets inset = self.textLabelInset;
    CGFloat top = floorf(CGRectGetHeight(ourBounds) * 0.66);
    CGRect frame = CGRectMake(inset.left,
                              top,
                              CGRectGetWidth(ourBounds) - inset.left - inset.right,
                              CGRectGetHeight(ourBounds) * 0.66);
    CGSize fitSize = [self.textLabel sizeThatFits:ourBounds.size];
    frame.size.height = fitSize.height;
    return frame;
}

- (CGRect)frameForSubtextLabel {
    CGRect frame = [self frameForTextLabel];
    UIEdgeInsets inset = self.subtextLabelInset;
    frame.origin.y = CGRectGetMaxY(frame) + self.textLabelInset.bottom + inset.top;
    frame.origin.x = inset.left;
    CGRect ourBounds = self.contentView.bounds;
    CGSize fitSize = [self.subtextLabel sizeThatFits:ourBounds.size];
    frame.size.height = fitSize.height;
    frame.size.width = CGRectGetWidth(ourBounds) - inset.left - inset.right;
    return frame;
}

@end
