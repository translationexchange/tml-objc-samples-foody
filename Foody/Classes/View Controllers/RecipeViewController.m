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
#import "APISerializer.h"

#define LIGHT_GRAY_COLOR [UIColor colorWithWhite:0.966 alpha:1.]
#define DARK_GRAY_COLOR [UIColor colorWithWhite:0.66 alpha:1.]
#define DARKER_GRAY_COLOR [UIColor colorWithWhite:0.33 alpha:1.]
#define BORDEAUX_COLOR [UIColor colorWithRed:1. green:0. blue:0. alpha:0.22]

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
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titledImageView.frame = self.contentView.bounds;
}
@end

/**
 *  Bullet View is just a shaded circle;
 */
@interface BulletView : UIView
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGFloat padding;
@property (assign, nonatomic) BOOL filled;
@property (assign, nonatomic) CGFloat strokeWidth;
@property (strong, nonatomic) UILabel *textLabel;
@end

@implementation BulletView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:10.];
        self.textLabel = label;
        [self addSubview:label];
        
        self.padding = 2.;
        self.color = LIGHT_GRAY_COLOR;
        self.backgroundColor = [UIColor clearColor];
        self.filled = YES;
        self.strokeWidth = 1.;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.textLabel.textColor = color;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = [self frameForTextLabel];
}

- (CGRect)frameForTextLabel {
    UILabel *label = self.textLabel;
    CGRect frame = label.frame;
    CGRect ourBounds = self.bounds;
    CGFloat padding = self.padding;
    ourBounds = CGRectInset(ourBounds, padding, padding);
    CGFloat min = MIN(CGRectGetWidth(ourBounds), CGRectGetHeight(ourBounds));
    ourBounds.size = CGSizeMake(min, min);
    CGSize fitSize = [label sizeThatFits:ourBounds.size];
    frame.size = CGSizeMake(MIN(fitSize.width, ourBounds.size.width), MIN(fitSize.height, ourBounds.size.height));
    frame.origin.x = floorf(CGRectGetMidX(ourBounds) - frame.size.width/2.);
    frame.origin.y = floorf(CGRectGetMidY(ourBounds) - frame.size.height/2.);
    return frame;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGFloat padding = self.padding;
    CGRect insetRect = CGRectInset(rect, padding, padding);
    CGFloat min = MIN(CGRectGetWidth(insetRect), CGRectGetHeight(insetRect));
    insetRect.size.width = min;
    insetRect.size.height = min;
    insetRect.origin = CGPointMake(floorf(CGRectGetMidX(rect) - (min/2.)),
                                   floorf(CGRectGetMidY(rect) - (min/2.)));
    CGContextClearRect(context, rect);
    CGContextMoveToPoint(context, CGRectGetMinX(insetRect), CGRectGetMinY(insetRect));
    if (self.filled == YES) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextFillEllipseInRect(context, insetRect);
    }
    else {
        CGContextSetLineWidth(context, self.strokeWidth);
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        CGContextStrokeEllipseInRect(context, insetRect);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [self.textLabel sizeThatFits:size];
    return fitSize;
}

@end

/**
 * RecipeDescriptionCell
 */
@interface RecipeDescriptionCell : UITableViewCell
@property (strong, nonatomic) BulletView *bulletView;
@property (assign, nonatomic) UIEdgeInsets bulletInsets;
@property (assign, nonatomic) UIEdgeInsets contentInsets;
@end

@implementation RecipeDescriptionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = LIGHT_GRAY_COLOR;
        UILabel *textLabel = self.textLabel;
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.];
        textLabel.textColor = DARKER_GRAY_COLOR;
        self.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 0;
        
        BulletView *bulletView = [[BulletView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        self.bulletView = bulletView;
        self.bulletInsets = UIEdgeInsetsMake(8., 8., 8., 4.);
        self.accessoryView = bulletView;
        
        self.contentInsets = UIEdgeInsetsMake(8., 0., 8., 8.);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bulletView.frame = [self frameForBulletView];
    self.contentView.frame = [self frameForContentView];
    self.textLabel.frame = [self frameForTextLabel];
}

- (CGRect)frameForBulletView {
    CGRect frame = self.bulletView.frame;
    UIEdgeInsets inset = self.bulletInsets;
    frame.origin.x = inset.left;
    frame.origin.y = inset.top;
    return frame;
}

- (CGRect)frameForContentView {
    CGRect frame = self.contentView.frame;
    CGRect ourBounds = self.bounds;
    UIEdgeInsets bulletInsets = self.bulletInsets;
    UIEdgeInsets contentInsets = self.contentInsets;
    frame.origin.x = CGRectGetWidth(self.bulletView.bounds) + bulletInsets.left + bulletInsets.right + contentInsets.left;
    frame.origin.y = contentInsets.top;
    frame.size.width = CGRectGetWidth(ourBounds) - frame.origin.x - contentInsets.right;
    frame.size.height = CGRectGetHeight(ourBounds)- contentInsets.top - contentInsets.bottom;
    return frame;
}

- (CGRect)frameForTextLabel {
    UILabel *label = self.textLabel;
    CGRect frame = label.frame;
    CGRect ourBounds = self.contentView.bounds;
    CGFloat ourLeftPadding = 4.;
    ourBounds = CGRectInset(ourBounds, ourLeftPadding, 0);
    CGSize fitSize = [label sizeThatFits:ourBounds.size];
    frame.origin.x = ourLeftPadding;
    frame.origin.y = floorf(CGRectGetMidY(ourBounds) - fitSize.height/2.);
    frame.size = fitSize;
    return frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    UIEdgeInsets bulletInsets = self.bulletInsets;
    UIEdgeInsets contentInsets = self.contentInsets;
    BulletView *bulletView = self.bulletView;
    
    CGFloat widthForTitleLabel = size.width - CGRectGetWidth(bulletView.bounds) - bulletInsets.left - bulletInsets.right - contentInsets.left - contentInsets.right;
    CGFloat heightForTitleLabel = size.height - MAX(CGRectGetHeight(bulletView.bounds) + bulletInsets.top + bulletInsets.bottom, contentInsets.top + contentInsets.bottom);
    
    UILabel *textLabel = self.textLabel;
    CGSize labelFitSize = [textLabel sizeThatFits:CGSizeMake(widthForTitleLabel, heightForTitleLabel)];
    
    CGSize boundingSize = CGSizeMake(size.width, MAX(CGRectGetHeight(bulletView.bounds) + bulletInsets.top + bulletInsets.bottom
                                                     , labelFitSize.height + contentInsets.top + contentInsets.bottom));
    return boundingSize;
}

@end


/**
 *  RecipeIngredientCell
 */
@interface RecipeIngredientCell : RecipeDescriptionCell
@end

@implementation RecipeIngredientCell
@end


/**
 *  RecipeDirectionCell
 */
@interface RecipeDirectionCell : RecipeDescriptionCell
@end

@implementation RecipeDirectionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        BulletView *bulletView = self.bulletView;
        bulletView.color = BORDEAUX_COLOR;
        bulletView.filled = NO;
    }
    return self;
}
@end


/**
 *  RecipeViewController
 */
@interface RecipeViewController () {
    NSInteger _recipeID;
    BOOL _observingNotifications;
}
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *gradientView;
@end

@implementation RecipeViewController

- (void)dealloc {
    [self teardownNotificationObserving];
}

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
    
    tableView.allowsSelection = NO;
    [tableView reloadData];
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.bottom = 44;
    tableView.contentInset = contentInset;
    
    [self setupNotificationObserving];
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
                    AppWarn(@"Could not load image");
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
        if (ai < bi) {
            return NSOrderedAscending;
        }
        else if (ai > bi) {
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    APIClient *apiClient = appDelegate.apiClient;
    [apiClient directionsForRecipeWithID:_recipeID parameters:nil completion:^(APIResponse *apiResponse, NSArray *directions, NSError *error) {
        if ([apiResponse isSuccessfulResponse] == YES) {
            NSArray *results = [self sortOptionallyIndexedModels:apiResponse.results];
            results = [self indexOrderedArrayOfModels:results];
            if (results.count > 0) {
                [self updateRecipeWithBlock:^(RecipeMO *recipe, CoreDataLocalStore *localStore) {
                    for (NSDictionary *info in results) {
                        RecipeDirectionMO *newDirection = [localStore createDirection];
                        [newDirection decodeWithCoder:[[APISerializer alloc] initForReadingWithData:[APISerializer serializeObject:info]]];
                        newDirection.recipe = recipe;
                        [recipe.directionsSet addObject:newDirection];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                }];
            }
            else {
                AppWarn(@"No directions found for recipe with ID: %li", _recipeID);
            }
        }
    }];
}

- (void)fetchIngredients {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    APIClient *apiClient = appDelegate.apiClient;
    [apiClient ingredientsForRecipeWithID:_recipeID parameters:nil completion:^(APIResponse *apiResponse, NSArray *directions, NSError *error) {
        if ([apiResponse isSuccessfulResponse] == YES) {
            NSArray *results = [self sortOptionallyIndexedModels:apiResponse.results];
            results = [self indexOrderedArrayOfModels:results];
            if (results.count > 0) {
                [self updateRecipeWithBlock:^(RecipeMO *recipe, CoreDataLocalStore *localStore) {
                    for (NSDictionary *info in results) {
                        RecipeIngredientMO *newIngredient = [localStore createIngredient];
                        [newIngredient decodeWithCoder:[[APISerializer alloc] initForReadingWithData:[APISerializer serializeObject:info]]];
                        newIngredient.recipe = recipe;
                        [recipe.ingredientsSet addObject:newIngredient];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                }];
            }
            else {
                AppWarn(@"No ingredients found for recipe with ID: %li", _recipeID);
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
                AppError(@"Error updating recipe object: %@", saveError);
            }
        }
    }];
}

#pragma mark - Scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIEdgeInsets contentInset = scrollView.contentInset;
    CGPoint contentOffset = scrollView.contentOffset;
    if (contentOffset.y <= 0 - contentInset.top) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        RecipeImageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            return;
        }
        CGFloat delta = ABS(contentOffset.y) - contentInset.top;
        CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = height + delta;
        cellFrame.origin.y = contentOffset.y + contentInset.top;
        cell.frame = cellFrame;
        CGFloat alpha = (delta == 0) ? 1 : 2/delta;
        cell.titledImageView.gradientView.alpha = alpha;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return TMLLocalizedString(@"Ingredients");
    }
    else if (section == 2) {
        return TMLLocalizedString(@"Preparation");
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
        height = CGRectGetHeight(ourBounds)/3.;
    }
    else {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGSize fitSize = [cell sizeThatFits:tableView.bounds.size];
        height = fitSize.height;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeMO *recipe = [self recipe];
    if (indexPath.section == 0) {
        RecipeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecipeImageCell class])];
        RecipeTitledImageView *titledImageView = cell.titledImageView;
        titledImageView.titleLabel.text = TMLLocalizedString(recipe.name);
        titledImageView.subtitleLabel.text = TMLLocalizedString(recipe.recipeDescription);
        NSURL *imageURL = [NSURL URLWithString:recipe.imagePath];
        if (imageURL != nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imageData != nil) {
                        titledImageView.imageView.image = [UIImage imageWithData:imageData];
                    }
                    else {
                        [titledImageView.imageView setImage:[UIImage imageNamed:@"meal_placeholder"]];
                    }
                });
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
            [strings addObject:@"{quantity}"];
        }
        if (ingredient.measurement.length > 0) {
            [strings addObject:ingredient.measurement];
        }
        if (ingredient.name.length > 0) {
            [strings addObject:ingredient.name];
        }
        cell.textLabel.text = TMLLocalizedString([strings componentsJoinedByString:@" "], @{@"quantity": ingredient.quantity});
        return cell;
    }
    else if (indexPath.section == 2) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"index = %li", indexPath.row];
        RecipeDirectionMO *direction = [[[recipe directions] filteredOrderedSetUsingPredicate:predicate] firstObject];
        RecipeDirectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecipeDirectionCell class])];
        cell.textLabel.text = TMLLocalizedString(direction.directionDescription);
        cell.bulletView.textLabel.text = [NSString stringWithFormat:@"%i", direction.indexValue + 1];
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
        headerView.textLabel.text = TMLLocalizedString([headerView.textLabel.text uppercaseString]);
        headerView.textLabel.textColor = DARKER_GRAY_COLOR;
        headerView.contentView.backgroundColor = LIGHT_GRAY_COLOR;
    }
}

#pragma mark - Notifications

- (void)setupNotificationObserving {
    if (_observingNotifications == YES) {
        return;
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(mocDidChange:)
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

- (void)mocDidChange:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSSet *updated = [userInfo valueForKey:NSUpdatedObjectsKey];
    RecipeMO *changedRecipe = nil;
    for (id obj in updated) {
        if ([obj isKindOfClass:[RecipeMO class]] == NO) {
            continue;
        }
        RecipeMO *recipe = (RecipeMO *)obj;
        if (_recipeID == recipe.uidValue) {
            changedRecipe = recipe;
            break;
        }
    }
    if (changedRecipe != nil) {
        [self reload];
        return;
    }
    
    NSSet *deleted = [userInfo valueForKey:NSDeletedObjectsKey];
    for (id obj in deleted) {
        if ([obj isKindOfClass:[RecipeMO class]] == NO) {
            continue;
        }
        RecipeMO *recipe = (RecipeMO *)obj;
        if (_recipeID == recipe.uidValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
            break;
        }
    }
}


#pragma mark -
- (void)reload {
    [self.tableView reloadData];
}

- (void)dismiss {
    if (self.presentingViewController != nil) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
