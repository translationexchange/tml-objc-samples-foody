//
//  RecipeViewController.h
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

@class FRecipe, RecipeView;

@interface RecipeViewController : UIViewController

@property (strong, nonatomic) FRecipe *recipe;
@property (readonly, nonatomic) RecipeView *recipeView;

@end
