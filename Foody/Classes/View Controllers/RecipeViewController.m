//
//  RecipeViewController.m
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeViewController.h"
#import "Recipe.h"
#import "RecipeView.h"
#import "CoreDataLocalStore.h"

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

- (void)setRecipeID:(NSInteger)recipeID {
    if (_recipeID == recipeID) {
        return;
    }
    _recipeID = recipeID;
    if (self.isViewLoaded == YES) {
        [self update];
    }
}

- (RecipeMO *)recipe {
    CoreDataLocalStore *localStore = [CoreDataLocalStore threadSafeLocalStore];
    __block RecipeMO *recipe;
    NSInteger recipeID = self.recipeID;
    [localStore performBlockAndWait:^{
        recipe = [localStore recipeWithID:@(recipeID)];
    }];
    return recipe;
}

- (void)update {
    Recipe *recipe = self.recipe;
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
