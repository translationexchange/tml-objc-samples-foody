//
//  RecipeViewController.h
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

@class Recipe, RecipeView;

@interface RecipeViewController : UIViewController

@property (assign, nonatomic) NSInteger recipeID;
@property (readonly, nonatomic) RecipeView *recipeView;

@end
