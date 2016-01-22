//
//  RecipeTableViewCell.m
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeTableViewCell.h"

#define THUMB_MAX_WIDTH 70

@implementation RecipeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.png"];
        self.imageView.image = placeholderImage;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *imageView = self.imageView;
    CGRect imageFrame = [self frameForImageView];
    imageView.frame = imageFrame;
    
    UILabel *label = self.textLabel;
    CGRect labelFrame = [self frameForLabel];
    label.frame = labelFrame;
}

- (CGRect)frameForImageView {
    UIImageView *imageView = self.imageView;
    CGRect ourBounds = self.bounds;
    CGSize imageSize = [imageView sizeThatFits:ourBounds.size];
    CGRect frame = CGRectZero;
    CGFloat ourHeight = ourBounds.size.height;
    CGSize size = CGSizeMake((ourHeight/imageSize.height)*imageSize.width, ourHeight);
    if (size.width < THUMB_MAX_WIDTH) {
        frame.origin.x += (THUMB_MAX_WIDTH - size.width)/2.;
    }
    frame.origin.x = floorf(frame.origin.x);
    frame.size = size;
    return frame;
}

- (CGRect)frameForLabel {
    UILabel *label = self.textLabel;
    CGRect ourBounds = self.bounds;
    CGRect availableBounds = ourBounds;
    availableBounds.origin.x += 100;
    availableBounds.size.width -= 100;
    CGSize size = [label sizeThatFits:availableBounds.size];
    
    CGRect frame = label.frame;
    frame.size = size;
    frame.origin = availableBounds.origin;
    if (size.height < availableBounds.size.height) {
        frame.origin.y += (availableBounds.size.height - size.height)/2.;
    }
    frame.origin.x = floorf(frame.origin.x);
    frame.origin.y = floorf(frame.origin.y);
    return frame;
}

@end
