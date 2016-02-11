//
//  RecipeView.m
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeView.h"

@interface RecipeView(){
    UIView *_imageGradientView;
    CAGradientLayer *_imageGradientLayer;
}
@end

@implementation RecipeView

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
        _imageGradientView = gradientView;
        [self insertSubview:gradientView aboveSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
