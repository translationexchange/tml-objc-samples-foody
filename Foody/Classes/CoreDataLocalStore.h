//
//  CoreDataLocalStore.h
//  Foody
//
//  Created by Pasha on 1/24/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RecipeMO.h"
#import "RecipeCategoryMO.h"
#import "RecipeDirectionMO.h"
#import "RecipeIngredientMO.h"

@interface CoreDataLocalStore : NSObject

@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)threadSafeLocalStore;
- (instancetype)threadSafeLocalStore;

#pragma mark - Saving
- (void)save:(NSError *__autoreleasing*)error;

#pragma mark - Executing Requests
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request;

- (NSUInteger)countForFetchRequest:(NSFetchRequest *)request;

- (NSPersistentStoreResult *)executeRequest:(NSPersistentStoreRequest *)request;

#pragma mark - 
- (void)performBlock:(void (^)(void))block;
- (void)performBlockAndWait:(void (^)(void))block;
- (BOOL)hasChanges;

#pragma mark - Categories
- (RecipeCategoryMO *)createCategory;
- (RecipeCategoryMO *)categoryWithID:(NSNumber *)uid;
- (NSArray *)listCategoriesFromOffset:(NSInteger)offset limit:(NSInteger)limit;
- (NSInteger)countCategories;
- (NSArray *)categoriesWithIDs:(NSArray *)ids;
- (void)deleteCategoriesExcludingIDs:(NSArray *)ids;

#pragma mark - Recipes
- (RecipeMO *)createRecipe;
- (RecipeMO *)recipeWithID:(NSNumber *)uid;
- (NSArray *)listRecipesFromOffset:(NSInteger)offset limit:(NSInteger)limit;
- (NSInteger)countRecipes;
- (NSArray *)recipesWithIDs:(NSArray *)ids;
- (void)deleteRecipesExcludingIDs:(NSArray *)ids;
//- (NSArray *)recipesInCategoryWithID:(NSNumber *)categoryID offset:(NSInteger)offset limit:(NSInteger)limit;

#pragma mark - Ingredients
- (RecipeIngredientMO *)createIngredient;
- (RecipeIngredientMO *)ingredientWithID:(NSNumber *)uid;
- (NSArray *)ingredientsWithIDs:(NSArray *)ids;
- (void)deleteIngredientsExcludingIDs:(NSArray *)ids;
//- (NSArray *)listIngredientsForRecipeWithID:(NSNumber *)recipeID;

#pragma mark - Directions
- (RecipeDirectionMO *)createDirection;
- (RecipeDirectionMO *)directionWithID:(NSNumber *)uid;
- (NSArray *)directionsWithIDs:(NSArray *)ids;
- (void)deleteDirectionsExcludingIDs:(NSArray *)ids;
//- (NSArray *)directionsForRecipeWithID:(NSNumber *)recipeID;

@end
