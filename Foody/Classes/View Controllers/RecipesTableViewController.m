//
//  RecipesTableViewController.m
//  Foody
//
//  Created by Michael Berkovich on 10/15/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "RecipesTableViewController.h"
#import "FRecipe.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RecipesTableViewController ()

@property(nonatomic, strong) NSArray *recipes;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation RecipesTableViewController

@synthesize refreshControl, category, recipes;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = [self.category getValue:@"name"];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    FRecipe *recipe = (FRecipe *) [recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = [recipe getValue:@"name"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[recipe getValue:@"image"]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

@end
