//
//  RecipeTitledImageView.m
//  Foody
//
//  Created by Pasha on 2/10/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeTitledImageView.h"

@interface RecipeTitledImageView() {
    CAGradientLayer *_imageGradientLayer;
}

@end

@implementation RecipeTitledImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView = imageView;
        [self addSubview:imageView];
        
        UIView *gradientView = [[UIView alloc] initWithFrame:frame];
        gradientView.autoresizingMask = imageView.autoresizingMask;
        self.gradientView = gradientView;
        [self addSubview:gradientView];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame= frame;
        gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,
                                 (id)[UIColor colorWithWhite:0. alpha:0.66].CGColor];
        gradientLayer.locations = @[@(0.5), @(1.)];
        _imageGradientLayer = gradientLayer;
        [gradientView.layer insertSublayer:gradientLayer atIndex:0];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 2;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:frame];
        subtitleLabel.textColor = [UIColor whiteColor];
        subtitleLabel.numberOfLines = 2;
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel = subtitleLabel;
        [self addSubview:subtitleLabel];
        
        [self setStyle:_style];
    }
    return self;
}

- (void)setStyle:(RecipeTitledImageViewStyle)style {
    _style = style;
    CGFloat titleSize = 16.;
    CGFloat subtitleSize = 12.;
    UIEdgeInsets titleInset = UIEdgeInsetsMake(0, 8, 4, 8);
    UIEdgeInsets subtitleInset = UIEdgeInsetsMake(4, 8, 8, 8);
    if (_style == RecipeTitledImageViewLargeStyle) {
        titleSize = 24.;
        subtitleSize = 14.;
        titleInset = UIEdgeInsetsMake(0, 16, 4, 16);
        subtitleInset = UIEdgeInsetsMake(4, 16, 16, 16);
    }
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:titleSize];
    self.subtitleLabel.font = [UIFont fontWithName:@"Helvetica" size:subtitleSize];
    
    self.titleInsets = titleInset;
    self.subtitleInsets = subtitleInset;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect ourBounds = self.bounds;
    self.imageView.frame = ourBounds;
    self.gradientView.frame = ourBounds;
    _imageGradientLayer.frame = self.gradientView.layer.bounds;
    [_imageGradientLayer setNeedsDisplay];
    self.subtitleLabel.frame = [self frameForSubtitleLabel];
    self.titleLabel.frame = [self frameForTitleLabel];
}

- (CGRect)frameForSubtitleLabel {
    CGRect ourBounds = self.bounds;
    UIEdgeInsets subtitleInsets = self.subtitleInsets;
    ourBounds.origin.x = subtitleInsets.left;
    ourBounds.size.width -= subtitleInsets.left + subtitleInsets.right;
    ourBounds.origin.y = subtitleInsets.top;
    ourBounds.size.height -= subtitleInsets.top + subtitleInsets.bottom;
    
    UILabel *label = self.subtitleLabel;
    CGSize fitSize = [label sizeThatFits:ourBounds.size];
    fitSize.width = CGRectGetWidth(ourBounds);
    fitSize.height = fitSize.height;
    
    CGRect frame = label.frame;
    frame.size = fitSize;
    frame.origin.x = floorf(ourBounds.origin.x);
    frame.origin.y = floorf(CGRectGetMaxY(ourBounds) - fitSize.height);
    return frame;
}

- (CGRect)frameForTitleLabel {
    CGRect ourBounds = self.bounds;
    UIEdgeInsets subtitleInsets = self.subtitleInsets;
    UIEdgeInsets titleInsets = self.titleInsets;
    CGRect subtitleFrame = [self frameForSubtitleLabel];
    ourBounds.origin.x = titleInsets.left;
    ourBounds.size.width -= titleInsets.left + titleInsets.right;
    ourBounds.origin.y = titleInsets.top;
    ourBounds.size.height -= titleInsets.top + titleInsets.bottom + subtitleInsets.top + subtitleInsets.bottom + CGRectGetHeight(subtitleFrame);
    
    UILabel *label = self.titleLabel;
    CGRect frame = label.frame;
    CGSize fitSize = [label sizeThatFits:ourBounds.size];
    fitSize.width = CGRectGetWidth(ourBounds);
    frame.size = fitSize;
    frame.origin.x = floorf(ourBounds.origin.x);
    frame.origin.y = floorf(CGRectGetMinY(subtitleFrame) - subtitleInsets.top - titleInsets.bottom - fitSize.height);
    return frame;
}

@end
