//
//  RecipeCollectionViewCell.m
//  Foody
//
//  Created by Pasha on 2/5/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeCollectionViewCell.h"

#define THUMB_MAX_WIDTH 70

@implementation RecipeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds = YES;
        self.imageView = imageView;
        
        self.textLabelInset = UIEdgeInsetsMake(8, 8, 8, 8);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.];
        textLabel.numberOfLines = 2;
        textLabel.textColor = [UIColor blackColor];
        self.textLabel = textLabel;
        
        self.subtextLabelInset = UIEdgeInsetsMake(0, 8, 8, 8);
        UILabel *subtextLabel = [[UILabel alloc] initWithFrame:frame];
        subtextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.];
        subtextLabel.numberOfLines = 3;
        subtextLabel.textColor = [UIColor colorWithWhite:0. alpha:0.33];
        self.subtextLabel = subtextLabel;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView sendSubviewToBack:imageView];
    }
    return self;
}

#pragma mark - Accessors
- (void)setImageView:(UIImageView *)imageView {
    if (_imageView == imageView) {
        return;
    }
    [self willChangeValueForKey:@"imageView"];
    UIView *parentView = self.contentView;
    if (_imageView.superview == parentView) {
        [_imageView removeFromSuperview];
    }
    _imageView = imageView;
    if (imageView != nil) {
        [parentView addSubview:imageView];
    }
    [self didChangeValueForKey:@"imageView"];
    [self setNeedsLayout];
}

- (void)setTextLabel:(UILabel *)textLabel {
    if (_textLabel == textLabel) {
        return;
    }
    [self willChangeValueForKey:@"textLabel"];
    UIView *parentView = self.contentView;
    if (_textLabel.superview == parentView) {
        [_textLabel removeFromSuperview];
    }
    _textLabel = textLabel;
    if (textLabel != nil) {
        [parentView addSubview:textLabel];
    }
    [self didChangeValueForKey:@"textLabel"];
    [self setNeedsLayout];
}

- (void)setSubtextLabel:(UILabel *)subtextLabel {
    if (_subtextLabel == subtextLabel) {
        return;
    }
    [self willChangeValueForKey:@"subtextLabel"];
    UIView *parentView = self.contentView;
    if (_subtextLabel.superclass == parentView) {
        [_subtextLabel removeFromSuperview];
    }
    _subtextLabel = subtextLabel;
    if (subtextLabel != nil) {
        [parentView addSubview:subtextLabel];
    }
    [self didChangeValueForKey:@"subtextLabel"];
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image {
    UIImageView *imageView = self.imageView;
    imageView.image = image;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = [self frameForImageView];
    self.textLabel.frame = [self frameForTextLabel];
    self.subtextLabel.frame = [self frameForSubtextLabel];
}

- (CGRect)frameForImageView {
    CGRect ourBounds = self.contentView.bounds;
    return CGRectMake(0, 0, CGRectGetWidth(ourBounds), floorf(CGRectGetHeight(ourBounds)/2.));
}

- (CGRect)frameForTextLabel {
    UILabel *label = self.textLabel;
    CGRect ourBounds = self.contentView.bounds;
    UIEdgeInsets textLabelInset = self.textLabelInset;
    CGRect availableBounds = CGRectMake(textLabelInset.left,
                                        floorf(CGRectGetMidY(ourBounds) + textLabelInset.top),
                                        CGRectGetWidth(ourBounds) - textLabelInset.left - textLabelInset.right,
                                        floorf(CGRectGetMidY(ourBounds)/2. - textLabelInset.top - textLabelInset.bottom));
    
    CGRect frame = availableBounds;
    CGSize size = [label sizeThatFits:availableBounds.size];
    size.width = MIN(size.width, availableBounds.size.width);
    size.height = MIN(size.height, availableBounds.size.height);
    frame.size = size;
    return frame;
}

- (CGRect)frameForSubtextLabel {
    UILabel *label = self.subtextLabel;
    CGRect ourBounds = self.contentView.bounds;
    UIEdgeInsets textLabelInset = self.textLabelInset;
    UIEdgeInsets subtextLabelInset = self.subtextLabelInset;
    CGRect textLabelFrame = [self frameForTextLabel];
    CGRect availableBounds = CGRectMake(subtextLabelInset.left,
                                        floorf(CGRectGetMaxY(textLabelFrame) + textLabelInset.bottom + subtextLabelInset.top),
                                        CGRectGetWidth(ourBounds) - subtextLabelInset.left - subtextLabelInset.right,
                                        CGRectGetMaxY(ourBounds) - CGRectGetMaxY(textLabelFrame) - subtextLabelInset.bottom - subtextLabelInset.top - textLabelInset.bottom);
    
    CGRect frame = availableBounds;
    CGSize size = [label sizeThatFits:availableBounds.size];
    size.width = MIN(size.width, availableBounds.size.width);
    size.height = MIN(size.height, availableBounds.size.height);
    frame.size = size;
    return frame;
}


@end
