//
//  RecipesListViewController.m
//  Foody
//
//  Created by Pasha on 2/5/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "CoreDataLocalStore.h"
#import "FeaturedRecipeCollectionViewCell.h"
#import "RecipeCollectionViewCell.h"
#import "RecipeViewController.h"
#import "RecipesListViewController.h"
#import "AppDelegate.h"
#import "SyncEngine.h"

#define FETCH_BRACKET 10

@interface RecipesListViewController() <UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate> {
    BOOL _observingNotifications;
    UIRefreshControl *_refreshControl;
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation RecipesListViewController

- (void)dealloc {
    [self teardownNotificationObserving];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Class recipeCellClass = [RecipeCollectionViewCell class];
    [self.collectionView registerClass:recipeCellClass forCellWithReuseIdentifier:NSStringFromClass(recipeCellClass)];
    Class featuredCellClass = [FeaturedRecipeCollectionViewCell class];
    [self.collectionView registerClass:featuredCellClass forCellWithReuseIdentifier:NSStringFromClass(featuredCellClass)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, layout.minimumInteritemSpacing, 0, layout.minimumInteritemSpacing);
    
    UICollectionView *collectionView = self.collectionView;
    collectionView.collectionViewLayout = layout;
    collectionView.delegate = self;
    
    self.navigationItem.title = TMLLocalizedString(@"Recipes");
    
    [collectionView addObserver:self
                     forKeyPath:@"bounds"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[RecipeMO entityName]];
    fetchRequest.sortDescriptors = @[
                                     [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]
                                     ];
    CoreDataLocalStore *localStore = [CoreDataLocalStore threadSafeLocalStore];
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                      managedObjectContext:[localStore managedObjectContext]
                                                                                        sectionNameKeyPath:nil
                                                                                                 cacheName:NSStringFromClass(self.class)];
    fetchController.delegate = self;
    self.fetchedResultsController = fetchController;
    NSError *error;
    if([fetchController performFetch:&error] == NO) {
        AppError(@"Error fetching recipes: %@", error);
    }
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [collectionView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshCollectionView) forControlEvents:UIControlEventValueChanged];
    [collectionView alwaysBounceVertical];
    _refreshControl = refreshControl;
    
    [self setupNotificationObserving];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Refreshing
- (void)refreshCollectionView {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [[delegate syncEngine] sync];
}

# pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSFetchedResultsController *fetchController = self.fetchedResultsController;
    NSInteger numberOfSections = [[fetchController sections] count];
    if (numberOfSections == 0) {
        return 0;
    }
    id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSFetchedResultsController *fetchController = self.fetchedResultsController;
    RecipeMO *recipe = [fetchController objectAtIndexPath:indexPath];
    if (recipe == nil) {
        return nil;
    }
    
    RecipeCollectionViewCell *cell;
    if (indexPath.row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FeaturedRecipeCollectionViewCell class]) forIndexPath:indexPath];
    }
    else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RecipeCollectionViewCell class]) forIndexPath:indexPath];
    }

    cell.textLabel.text = TMLLocalizedString(recipe.name);
    cell.subtextLabel.text = TMLLocalizedString(recipe.recipeDescription);
    [cell setImage:nil];
    
    CGRect frame = cell.frame;
    cell.frame = frame;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:recipe.imagePath];
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        if (data.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setImage:[UIImage imageWithData:data]];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setImage:[UIImage imageNamed:@"meal_placeholder"]];
            });
            AppError(@"Could not load image from: %@", imageURL);
        }
    });
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showRecipe" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = self.selectedIndexPath;
    if (indexPath == nil) {
        return;
    }
    RecipeMO *recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (recipe == nil) {
        return;
    }
    
    RecipeViewController *viewController = (RecipeViewController *)[segue destinationViewController];
    viewController.recipe = recipe;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *containerView = self.collectionView;
    CGRect containerBounds = containerView.bounds;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat defaultWidth = CGRectGetWidth(containerBounds)/2. - (flowLayout.minimumInteritemSpacing * 1.5);
    CGFloat defaultHeight = defaultWidth * 1.33;
    CGSize result = CGSizeZero;
    if (indexPath.row == 0) {
        CGSize size = containerBounds.size;
        CGFloat height = defaultHeight;
        CGFloat width = size.width - (flowLayout.minimumInteritemSpacing * 2);
        result = CGSizeMake(width, height);
    }
    else {
        result = CGSizeMake(defaultWidth, defaultHeight);
    }
    return result;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UICollectionView *collectionView = self.collectionView;
    NSArray *visibleCells = [collectionView visibleCells];
    UICollectionViewCell *targetCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([visibleCells containsObject:targetCell] == YES) {
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
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
    [self.collectionView reloadData];
    if ([_refreshControl isRefreshing] == YES) {
        [_refreshControl endRefreshing];
    }
}

@end
