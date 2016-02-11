//
//  RecipeViewController.m
//  Foody
//
//  Created by Pasha on 1/22/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "APIClient.h"
#import "AppDelegate.h"
#import "CoreDataLocalStore.h"
#import "RecipeView.h"
#import "RecipeViewController.h"
#import "RecipeDirection.h"
#import "RecipeTitledImageView.h"
#import <TMLKit/TMLAPISerializer.h>


/**
 *  RecipeImageCell
 */
@interface RecipeImageCell : UITableViewCell
@property (strong, nonatomic) RecipeTitledImageView *titledImageView;
@end

@implementation RecipeImageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        RecipeTitledImageView *titledImageView = [[RecipeTitledImageView alloc] init];
        titledImageView.style = RecipeTitledImageViewLargeStyle;
        titledImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.titledImageView = titledImageView;
        [self.contentView addSubview:titledImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titledImageView.frame = self.contentView.bounds;
}
@end


/**
 *  RecipeIngredientCell
 */
@interface RecipeIngredientCell : UITableViewCell
@end

@implementation RecipeIngredientCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}
@end


/**
 *  RecipeDirectionCell
 */
@interface RecipeDirectionCell : UITableViewCell
@end
@implementation RecipeDirectionCell
@end


@interface RecipeViewController () {
    NSInteger _recipeID;
}
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *gradientView;
@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchMissingRecipeData];
    UITableView *tableView = self.tableView;
    [tableView registerClass:[RecipeImageCell class]
      forCellReuseIdentifier:NSStringFromClass([RecipeImageCell class])];
    [tableView registerClass:[RecipeIngredientCell class]
      forCellReuseIdentifier:NSStringFromClass([RecipeIngredientCell class])];
    [tableView registerClass:[RecipeDirectionCell class]
      forCellReuseIdentifier:NSStringFromClass([RecipeDirectionCell class])];
    [tableView reloadData];
}

#pragma mark - Recipe

- (void)setRecipe:(RecipeMO *)recipe {
    _recipeID = recipe.uidValue;
    [self.tableView reloadData];
}

- (RecipeMO *)recipe {
    if (_recipeID == 0) {
        return nil;
    }
    CoreDataLocalStore *localStore = [CoreDataLocalStore threadSafeLocalStore];
    __block RecipeMO *recipe;
    NSInteger recipeID = _recipeID;
    [localStore performBlockAndWait:^{
        recipe = [localStore recipeWithID:@(recipeID)];
    }];
    return recipe;
}

- (void)loadRecipeImage {
    RecipeMO *recipe = [self recipe];
    NSURL *imageURL = [NSURL URLWithString:recipe.imagePath];
    if (imageURL != nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data != nil) {
                    self.imageView.image = [UIImage imageWithData:data];
                }
                else {
                    TMLWarn(@"Could not load image");
                }
            });
        });
    }
}

#pragma mark - Ondemand data

- (void)fetchMissingRecipeData {
    RecipeMO *recipe = nil;
    if (_recipeID != 0) {
        recipe = [self recipe];
    }
    if (recipe != nil) {
        if (recipe.directions.count == 0) {
            [self fetchDirections];
        }
        if (recipe.ingredients.count == 0) {
            [self fetchIngredients];
        }
    }
}

// Apparently "index" property on Ingredients and Directions is optional
// the following two methods deal with indexing and sorting arrays representing those objects
- (NSArray *)sortOptionallyIndexedModels:(NSArray *)array {
    return [array sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        NSNumber *aIndex = a[@"index"];
        if (aIndex == nil) {
            aIndex = a[@"id"];
        }
        NSNumber *bIndex = b[@"index"];
        if (bIndex == nil) {
            bIndex = b[@"id"];
        }
        NSInteger ai = [aIndex integerValue];
        NSInteger bi = [bIndex integerValue];
        if (ai > bi) {
            return NSOrderedAscending;
        }
        else if (ai < bi) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];
}

- (NSArray *)indexOrderedArrayOfModels:(NSArray *)array {
    NSInteger i=0;
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in array) {
        if  ([obj isKindOfClass:[NSDictionary class]] == YES) {
            NSMutableDictionary *dict = [(NSDictionary *)obj mutableCopy];
            dict[@"index"] = @(i);
            [result addObject:[dict copy]];
        }
        else {
            [obj setValue:@(i) forKey:@"index"];
            [result addObject:obj];
        }
        i++;
    }
    return [result copy];
}

- (void)fetchDirections {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    APIClient *apiClient = appDelegate.apiClient;
    [apiClient directionsForRecipeWithID:_recipeID parameters:nil completion:^(TMLAPIResponse *apiResponse, NSArray *directions, NSError *error) {
        if ([apiResponse isSuccessfulResponse] == YES) {
            NSArray *results = [self sortOptionallyIndexedModels:apiResponse.results];
            results = [self indexOrderedArrayOfModels:results];
            if (results.count > 0) {
                [self updateRecipeWithBlock:^(RecipeMO *recipe, CoreDataLocalStore *localStore) {
                    for (NSDictionary *info in results) {
                        RecipeDirectionMO *newDirection = [localStore createDirection];
                        [newDirection decodeWithCoder:[[TMLAPISerializer alloc] initForReadingWithData:[TMLAPISerializer serializeObject:info]]];
                        newDirection.recipe = recipe;
                        [recipe.directionsSet addObject:newDirection];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                }];
            }
            else {
                TMLWarn(@"No directions found for recipe with ID: %li", _recipeID);
            }
        }
    }];
}

- (void)fetchIngredients {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    APIClient *apiClient = appDelegate.apiClient;
    [apiClient ingredientsForRecipeWithID:_recipeID parameters:nil completion:^(TMLAPIResponse *apiResponse, NSArray *directions, NSError *error) {
        if ([apiResponse isSuccessfulResponse] == YES) {
            NSArray *results = [self sortOptionallyIndexedModels:apiResponse.results];
            results = [self indexOrderedArrayOfModels:results];
            if (results.count > 0) {
                [self updateRecipeWithBlock:^(RecipeMO *recipe, CoreDataLocalStore *localStore) {
                    for (NSDictionary *info in results) {
                        RecipeIngredientMO *newIngredient = [localStore createIngredient];
                        [newIngredient decodeWithCoder:[[TMLAPISerializer alloc] initForReadingWithData:[TMLAPISerializer serializeObject:info]]];
                        newIngredient.recipe = recipe;
                        [recipe.ingredientsSet addObject:newIngredient];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                }];
            }
            else {
                TMLWarn(@"No ingredients found for recipe with ID: %li", _recipeID);
            }
        }
    }];
}

#pragma mark - Update Recipe
- (void)updateRecipeWithBlock:(void(^)(RecipeMO *recipe, CoreDataLocalStore *localStore))block {
    if (block == nil) {
        return;
    }
    CoreDataLocalStore *localStore = [CoreDataLocalStore threadSafeLocalStore];
    NSInteger recipeID = _recipeID;
    [localStore performBlock:^{
        RecipeMO *recipe = [localStore recipeWithID:@(recipeID)];
        block(recipe, localStore);
        if ([localStore hasChanges] == YES) {
            NSError *saveError = nil;
            [localStore save:&saveError];
            if (saveError != nil) {
                TMLError(@"Error updating recipe object: %@", saveError);
            }
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return NSLocalizedString(@"Ingredients", nil);
    }
    else if (section == 2) {
        return NSLocalizedString(@"Preparation", nil);
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        RecipeMO *recipe = [self recipe];
        if (section == 1) {
            return recipe.ingredients.count;
        }
        else if (section == 2) {
            return recipe.directions.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = UITableViewAutomaticDimension;
    if (indexPath.section == 0) {
        CGRect ourBounds = self.view.bounds;
        height = CGRectGetHeight(ourBounds)/2.;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeMO *recipe = [self recipe];
    if (indexPath.section == 0) {
        RecipeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecipeImageCell class])];
        RecipeTitledImageView *titledImageView = cell.titledImageView;
        titledImageView.titleLabel.text = recipe.name;
        titledImageView.subtitleLabel.text = recipe.recipeDescription;
        NSURL *imageURL = [NSURL URLWithString:recipe.imagePath];
        if (imageURL != nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                if (imageData != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        titledImageView.imageView.image = [UIImage imageWithData:imageData];
                    });
                }
            });
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"index = %li", indexPath.row];
        RecipeIngredientMO *ingredient = [[[recipe ingredients] filteredOrderedSetUsingPredicate:predicate] firstObject];
        RecipeIngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecipeIngredientCell class])];
        NSMutableArray *strings = [NSMutableArray array];
        if (ingredient.quantity.length > 0) {
            [strings addObject:ingredient.quantity];
        }
        if (ingredient.measurement.length > 0) {
            [strings addObject:ingredient.measurement];
        }
        if (ingredient.name.length > 0) {
            [strings addObject:ingredient.name];
        }
        cell.textLabel.text = [strings componentsJoinedByString:@" "];
        return cell;
    }
    else if (indexPath.section == 2) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"index = %li", indexPath.row];
        RecipeDirectionMO *direction = [[[recipe directions] filteredOrderedSetUsingPredicate:predicate] firstObject];
        RecipeDirectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecipeDirectionCell class])];
        cell.textLabel.text = direction.directionDescription;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    if (section > 0) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.];
        headerView.textLabel.text = [headerView.textLabel.text uppercaseString];
        headerView.textLabel.textColor = [UIColor colorWithWhite:0.66 alpha:1.];
    }
}

@end
