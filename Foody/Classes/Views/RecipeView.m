//
//  RecipeView.m
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeView.h"

@implementation RecipeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)layoutSubviews {
    UIImageView *imageView = self.imageView;
    CGRect frameForImageView = [self frameForImageView];
    imageView.frame = frameForImageView;
    
    UIView *nameShadowView = self.nameShadeView;
    CGRect nameShadowViewFrame = [self frameForNameShadowView];
    nameShadowView.frame = nameShadowViewFrame;
    
    UILabel *nameLabel = self.nameLabel;
    CGRect frameForNameLabel = [self frameForNameLabel];
    nameLabel.frame = frameForNameLabel;
}

- (CGRect)frameForImageView {
    UIImageView *imageView = self.imageView;
    CGRect ourBounds = self.bounds;
    CGRect frame = imageView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    CGFloat width = CGRectGetWidth(ourBounds);
    CGSize imageSize = [imageView sizeThatFits:ourBounds.size];
    CGFloat height = 0;
    if (imageSize.height * imageSize.width > 0) {
        height = imageSize.height * (width / imageSize.width);
    }
    frame.size = CGSizeMake(width, height);
    return frame;
}

- (CGRect)frameForNameShadowView {
    UIView *view = self.nameShadeView;
    UIImageView *imageView = self.imageView;
    CGRect frame = view.frame;
    frame.origin.y = floorf(CGRectGetMaxY(imageView.frame)-frame.size.height);
    return frame;
}

- (CGRect)frameForNameLabel {
    UILabel *label = self.nameLabel;
    CGRect frame = label.frame;
    UIView *shadeView = self.nameShadeView;
    CGRect ourBounds = self.bounds;
    frame.origin.x = 0;
    frame.origin.y = floorf(CGRectGetMidY(shadeView.frame) - frame.size.height/2.);
    frame.size.width = CGRectGetWidth(ourBounds);
    return frame;
}

@end
