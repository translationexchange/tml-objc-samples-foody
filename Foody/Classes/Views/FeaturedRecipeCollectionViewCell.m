//
//  FeaturedRecipeCollectionViewCell.m
//  Foody
//
//  Created by Pasha on 2/8/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "FeaturedRecipeCollectionViewCell.h"

@interface RecipeCollectionViewCell()
- (CGRect)frameForImageView;
- (CGRect)frameForTextLabel;
- (CGRect)frameForSubtextLabel;
@end

@interface FeaturedRecipeCollectionViewCell(){
    CAGradientLayer *_imageGradientLayer;
}

@end

@implementation FeaturedRecipeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame= frame;
        gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                                 (id)[UIColor blackColor].CGColor];
        _imageGradientLayer = gradientLayer;
        self.imageView.layer.mask = gradientLayer;
        
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
    UIImageView *imageView = self.imageView;
    CGRect originalImageFrame = imageView.frame;
    [super layoutSubviews];
    CGRect newImageFrame = imageView.frame;
    if (CGRectEqualToRect(originalImageFrame, newImageFrame) == NO) {
        CAGradientLayer *gradientLayer = _imageGradientLayer;
        gradientLayer.frame = newImageFrame;
    }
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
