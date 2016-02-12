//
//  CategoriesTableViewController.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "APIClient.h"
#import "AppDelegate.h"
#import "CategoriesTableViewController.h"
#import "CoreDataLocalStore.h"
#import "RecipeCategory.h"
#import "RecipesTableViewController.h"

@interface CategoriesTableViewController () {
    BOOL _observingNotifications;
    NSUInteger _numberOfCategories;
}

@property(nonatomic, strong) NSMutableArray *categories;
@property(nonatomic, strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) RecipeCategory *category;

@end

@implementation CategoriesTableViewController

@synthesize refreshControl, categories, category;

- (void)dealloc {
    [self teardownNotificationObserving];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotificationObserving];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self refreshTable];
}

- (void)refreshTable {
    CoreDataLocalStore *localStore = [[[CoreDataLocalStore alloc] init] threadSafeLocalStore];
    _numberOfCategories = [localStore countCategories];
    UITableView *tableView = self.tableView;
    NSInteger maxIndex = 0;
    NSArray *visibleCells = [tableView visibleCells];
    for (UITableViewCell *cell in visibleCells) {
        if (cell.tag > maxIndex) {
            maxIndex = cell.tag;
        }
    }

    NSInteger limit = (maxIndex < 100) ? 100 : maxIndex;
    self.categories = [[localStore listCategoriesFromOffset:0 limit:limit] mutableCopy];
    
    [refreshControl endRefreshing];
    [tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberOfCategories;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    if (categories.count <= indexPath.row) {
        CoreDataLocalStore *localStore = [[[CoreDataLocalStore alloc] init] threadSafeLocalStore];
        NSArray *additions = [localStore listCategoriesFromOffset:categories.count-1 limit:10];
        if (additions.count > 0) {
            [categories addObjectsFromArray:additions];
        }
    }
    
    if (categories.count <= indexPath.row) {
        return nil;
    }
   
    RecipeCategoryMO *aCategory = (RecipeCategoryMO *) [categories objectAtIndex:indexPath.row];
    cell.textLabel.text = aCategory.name;
    cell.tag = indexPath.row;
    
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

#pragma mark - Notifications

- (void)setupNotificationObserving {
    if (_observingNotifications == YES) {
        return;
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(mocChanged:)
                   name:NSManagedObjectContextObjectsDidChangeNotification
                 object:nil];
    _observingNotifications = YES;
}

- (void)teardownNotificationObserving {
    if (_observingNotifications == NO) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _observingNotifications = NO;
}

- (void)mocChanged:(NSNotification *)aNotification {
    [self refreshTable];
}

@end
