//
//  RecipesListViewController.m
//  Foody
//
//  Created by Pasha on 2/5/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "RecipesListViewController.h"
#import "RecipeCollectionViewCell.h"
#import "CoreDataLocalStore.h"

#define FETCH_BRACKET 10

@interface RecipesListViewController() <UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RecipesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Class recipeCellClass = [RecipeCollectionViewCell class];
    [self.collectionView registerClass:recipeCellClass forCellWithReuseIdentifier:NSStringFromClass(recipeCellClass)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, layout.minimumInteritemSpacing, 0, layout.minimumInteritemSpacing);
    
    UICollectionView *collectionView = self.collectionView;
    collectionView.collectionViewLayout = layout;
    collectionView.delegate = self;
    
    self.navigationItem.title = NSLocalizedString(@"Recipes", nil);
    
    [collectionView addObserver:self
                     forKeyPath:@"bounds"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[RecipeMO entityName]];
    fetchRequest.sortDescriptors = @[
                                     [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]
                                     ];
    CoreDataLocalStore *localStore = [[CoreDataLocalStore alloc] init];
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                      managedObjectContext:[localStore managedObjectContext]
                                                                                        sectionNameKeyPath:nil
                                                                                                 cacheName:NSStringFromClass(self.class)];
    fetchController.delegate = self;
    self.fetchedResultsController = fetchController;
    NSError *error;
    if([fetchController performFetch:&error] == NO) {
        TMLError(@"Error fetching recipes: %@", error);
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    [self.collectionView.collectionViewLayout invalidateLayout];
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

    RecipeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RecipeCollectionViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = recipe.name;
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
            TMLError(@"Could not load image from: %@", imageURL);
        }
    });
    
    return cell;
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
    CGSize result = CGSizeZero;
    if (indexPath.row == 0) {
        CGSize size = containerBounds.size;
        CGFloat height = defaultWidth;
        CGFloat width = size.width - (flowLayout.minimumInteritemSpacing * 2);
        result = CGSizeMake(width, height);
    }
    else {
        result = CGSizeMake(defaultWidth, defaultWidth);
    }
    return result;
}

#pragma mark - NSFetchedResultsControllerDelegate

@end
