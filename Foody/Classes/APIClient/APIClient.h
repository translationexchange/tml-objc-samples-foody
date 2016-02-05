//
//  ApiClient.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

// piggy backing off of TMLBasicAPIClient
#import <TMLKit/TMLBasicAPIClient.h>

@class RecipeCategory, Recipe;

@interface APIClient : TMLBasicAPIClient

#pragma mark - Categories

- (void)listCategories:(NSDictionary *)parameters
            completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *categories, NSError *error))completion;

- (void)categoryWithID:(NSInteger)categoryID
            parameters:(NSDictionary *)parameters
            completion:(void(^)(TMLAPIResponse *apiResponse, RecipeCategory *category, NSError *error))completion;

#pragma mark - Recipes

- (void)listRecipes:(NSDictionary *)parameters
         completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *recipes, NSError *error))completion;

- (void)recipesForCategoryWithID:(NSInteger)categoryID
                      parameters:(NSDictionary *)parameters
                      completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *recipes, NSError *error))completion;

- (void)recipeWithID:(NSInteger)recipeID
          parameters:(NSDictionary *)parameters
          completion:(void(^)(TMLAPIResponse *apiResponse, Recipe *recipe, NSError *error))completion;

#pragma mark - Directions
- (void)listDirections:(NSDictionary *)parameters
            completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *directions, NSError *error))completion;
- (void)directionsForRecipeWithID:(NSInteger)recipeID
                       parameters:(NSDictionary *)parameters
                       completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *directions, NSError *error))completion;

#pragma mark - Ingredients
- (void)listIngredients:(NSDictionary *)parameters
             completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *ingredients, NSError *error))completion;
- (void)ingredientsForRecipeWithID:(NSInteger)recipeID
                        parameters:(NSDictionary *)parameters
                        completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *ingredients, NSError *error))completion;

@end
