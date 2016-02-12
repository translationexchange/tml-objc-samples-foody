//
//  FeaturedRecipeCollectionViewCell.m
//  Foody
//
//  Created by Pasha on 2/8/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "FeaturedRecipeCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface FeaturedRecipeCollectionViewCell()
@property (strong, nonatomic) RecipeTitledImageView *titledImageView;
@end

@implementation FeaturedRecipeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        RecipeTitledImageView *titledImageView = [[RecipeTitledImageView alloc] initWithFrame:frame];
        titledImageView.style = RecipeTitledImageViewSmallStyle;
        self.titledImageView = titledImageView;
        titledImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:titledImageView];
    }
    return self;
}

#pragma mark - Accessors

- (UIImageView *)imageView {
    return self.titledImageView.imageView;
}

- (void)setImageView:(UIImageView *)imageView {
    [self.titledImageView setImageView:imageView];
}

- (UILabel *)textLabel {
    return [self.titledImageView titleLabel];
}

- (void)setTextLabel:(UILabel *)textLabel {
    [self.titledImageView setTitleLabel:textLabel];
}

- (UILabel *)subtextLabel {
    return [self.titledImageView subtitleLabel];
}

- (void)setSubtextLabel:(UILabel *)subtextLabel {
    [self.titledImageView setSubtitleLabel:subtextLabel];
}

- (UIEdgeInsets)textLabelInset {
    return self.titledImageView.titleInsets;
}

- (void)setTextLabelInset:(UIEdgeInsets)textLabelInset {
    self.titledImageView.titleInsets = textLabelInset;
}

- (UIEdgeInsets)subtextLabelInset {
    return self.titledImageView.subtitleInsets;
}

- (void)setSubtextLabelInset:(UIEdgeInsets)subtextLabelInset {
    self.titledImageView.subtitleInsets = subtextLabelInset;
}

- (void)setImage:(UIImage *)image {
    self.titledImageView.imageView.image = image;
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titledImageView.frame = [self frameForTitledImageView];
}

- (CGRect)frameForTitledImageView {
    CGRect ourBounds = self.contentView.bounds;
    return ourBounds;
}

@end
