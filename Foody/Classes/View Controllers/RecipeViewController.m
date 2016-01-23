//
//  RecipeViewController.m
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeViewController.h"
#import "FRecipe.h"
#import "RecipeView.h"

@interface RecipeViewController ()
@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DONE");
    [self update];
}

- (RecipeView *)recipeView {
    return (RecipeView *)self.view;
}

- (void)setRecipe:(FRecipe *)recipe {
    if (_recipe == recipe
        || [_recipe isEqualToRecipe:recipe] == YES) {
        return;
    }
    _recipe = recipe;
    if (self.isViewLoaded == YES) {
        [self update];
    }
}

- (void)update {
    FRecipe *recipe = self.recipe;
    RecipeView *view = self.recipeView;
    view.nameLabel.text = recipe.name;
    
    NSURL *imageURL = [NSURL URLWithString:recipe.imagePath];
    if (imageURL != nil) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data == nil) {
                    view.imageView.image = [UIImage imageNamed:@"placeholder.png"];
                }
                else {
                    view.imageView.image = [UIImage imageWithData:data];
                }
            });
        });
    }
    else {
        view.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    }
}

@end
