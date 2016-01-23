//
//  RecipeView.h
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *nameShadeView;

@end
