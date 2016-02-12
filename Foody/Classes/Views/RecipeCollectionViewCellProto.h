//
//  RecipeCollectionViewCellProto.h
//  Foody
//
//  Created by Pasha on 2/11/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecipeCollectionViewCellProto <NSObject>
@required
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;
@property (assign, nonatomic) UIEdgeInsets textLabelInset;
@property (strong, nonatomic) UILabel *subtextLabel;
@property (assign, nonatomic) UIEdgeInsets subtextLabelInset;
- (void)setImage:(UIImage *)image;
@end
