//
//  RecipesTableViewController.m
//  Foody
//
//  Created by Michael Berkovich on 10/15/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "APIClient.h"
#import "AppDelegate.h"
#import "RecipeCategory.h"
#import "Recipe.h"
#import "RecipeTableViewCell.h"
#import "RecipeViewController.h"
#import "RecipesTableViewController.h"

NSString * const RecipeTableViewCellIdentifier = @"RecipeTableViewCell";

@interface RecipesTableViewController()
@property(readwrite, nonatomic, strong) NSArray *recipes;
@end

@implementation RecipesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.category.name;
    UITableView *tableView = self.tableView;
    [tableView registerClass:[RecipeTableViewCell class] forCellReuseIdentifier:RecipeTableViewCellIdentifier];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    [self refreshTable];
}

- (void)refreshTable {
    if (_category) {
        [AppAPIClient recipesForCategoryWithID:_category.uid
                                    parameters:nil
                                    completion:^(TMLAPIResponse *apiResponse, NSArray *newRecipes, NSError *error) {
                                        if (error == nil) {
                                            self.recipes = newRecipes;
                                            [self.refreshControl endRefreshing];
                                            [self.tableView reloadData];
                                        }
                                    }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecipeTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    
    Recipe *recipe = (Recipe *) [self.recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = recipe.name;
    NSURL *thumbURL = [NSURL URLWithString:recipe.imagePath];
    if (thumbURL != nil) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            NSData *thumbData = [NSData dataWithContentsOfURL:thumbURL];
            if (thumbData != nil) {
                UIImage *thumbImage = [UIImage imageWithData:thumbData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = thumbImage;
                    [cell setNeedsLayout];
                });
            }
        });
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"SelectRecipe" sender:self];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = NSNotFound;
}

#pragma mark - Presenting Recipe
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSInteger index = self.selectedIndex;
    if (index == NSNotFound) {
        return;
    }
    
    NSArray *allRecipes = self.recipes;
    Recipe *recipe = nil;
    NSInteger row = index;
    if (allRecipes.count > row) {
        recipe = [allRecipes objectAtIndex:row];
    }
    
    if (recipe == nil) {
        return;
    }
    
    RecipeViewController *viewController = (RecipeViewController *)[segue destinationViewController];
    viewController.recipe = recipe;
}
- (void)showRecipe:(Recipe *)recipe {
    UINavigationController *recipeViewController = nil;
    if (self.navigationController != nil) {
        UIViewController *presenter = self.navigationController.topViewController;
        if (presenter.presentedViewController != nil) {
            [presenter dismissViewControllerAnimated:YES completion:^{
                [self.navigationController pushViewController:recipeViewController animated:YES];
            }];
        }
        else {
            [self.navigationController pushViewController:recipeViewController animated:YES];
        }
    }
    else {
        if (self.presentedViewController != nil) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self presentViewController:recipeViewController animated:YES completion:nil];
            }];
        }
        else {
            [self presentViewController:recipeViewController animated:YES completion:nil];
        }
    }
}

@end
