//
//  RecipesTableViewController.h
//  Foody
//
//  Created by Michael Berkovich on 10/15/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeCategory.h"

@interface RecipesTableViewController : UITableViewController

@property(nonatomic, strong) RecipeCategory *category;
@property(assign, nonatomic) NSInteger selectedIndex;
@property(readonly, nonatomic, strong) NSArray *recipes;

@end
