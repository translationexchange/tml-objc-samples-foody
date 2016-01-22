//
//  RecipesTableViewController.m
//  Foody
//
//  Created by Michael Berkovich on 10/15/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "FRecipe.h"
#import "RecipeTableViewCell.h"
#import "RecipesTableViewController.h"

NSString * const RecipeTableViewCellIdentifier = @"RecipeTableViewCell";

@interface RecipesTableViewController ()

@property(nonatomic, strong) NSArray *recipes;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation RecipesTableViewController

@synthesize refreshControl, category, recipes;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.category getValue:@"name"];
    UITableView *tableView = self.tableView;
    [tableView registerClass:[RecipeTableViewCell class] forCellReuseIdentifier:RecipeTableViewCellIdentifier];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refreshControl];
    
    [self refreshTable];
}

- (void)refreshTable {
    if (category) {
        [category getRecipes: @{} success:^(NSArray *fetchedRecipes) {
            self.recipes = fetchedRecipes;
            [refreshControl endRefreshing];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            self.recipes = @[];
            [refreshControl endRefreshing];
            [self.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecipeTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    
    FRecipe *recipe = (FRecipe *) [recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = [recipe getValue:@"name"];
    NSURL *thumbURL = [NSURL URLWithString:[recipe getValue:@"image"]];
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

@end
