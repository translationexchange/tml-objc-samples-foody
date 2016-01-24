//
//  CategoriesTableViewController.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "CategoriesTableViewController.h"
#import "RecipeCategory.h"
#import "RecipesTableViewController.h"
#import "APIClient.h"

@interface CategoriesTableViewController ()

@property(nonatomic, strong) NSArray *categories;
@property(nonatomic, strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) RecipeCategory *category;

@end

@implementation CategoriesTableViewController

@synthesize refreshControl, categories, category;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self refreshTable];
}

- (void)refreshTable {
    [AppAPIClient listAllCategories:nil
                         completion:^(NSArray *newCategories, NSError *error) {
                             if (error == nil) {
                                 self.categories = newCategories;
                                 [refreshControl endRefreshing];
                                 [self.tableView reloadData];
                             }
                         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
   
    RecipeCategory *aCategory = (RecipeCategory *) [categories objectAtIndex:indexPath.row];
    cell.textLabel.text = aCategory.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.category = [self.categories objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SelectCategory" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RecipesTableViewController *controller = (RecipesTableViewController *) [segue destinationViewController];
    controller.category = self.category;
}

@end
