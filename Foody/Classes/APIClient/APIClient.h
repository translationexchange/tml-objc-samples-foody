//
//  ApiClient.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "APIResponse.h"

@class RecipeCategory, Recipe;

typedef void (^APIResponseHandler)(APIResponse *apiResponse, NSURLResponse *response, NSError *error);

@interface APIClient : NSObject

- (instancetype)initWithBaseURL:(NSURL *)baseURL;
@property (strong, nonatomic) NSURL *baseURL;

#pragma mark - Categories

- (void)listCategories:(NSDictionary *)parameters
            completion:(void(^)(APIResponse *apiResponse, NSArray *categories, NSError *error))completion;

- (void)categoryWithID:(NSInteger)categoryID
            parameters:(NSDictionary *)parameters
            completion:(void(^)(APIResponse *apiResponse, RecipeCategory *category, NSError *error))completion;

#pragma mark - Recipes

- (void)listRecipes:(NSDictionary *)parameters
         completion:(void(^)(APIResponse *apiResponse, NSArray *recipes, NSError *error))completion;

- (void)recipesForCategoryWithID:(NSInteger)categoryID
                      parameters:(NSDictionary *)parameters
                      completion:(void(^)(APIResponse *apiResponse, NSArray *recipes, NSError *error))completion;

- (void)recipeWithID:(NSInteger)recipeID
          parameters:(NSDictionary *)parameters
          completion:(void(^)(APIResponse *apiResponse, Recipe *recipe, NSError *error))completion;

#pragma mark - Directions
- (void)listDirections:(NSDictionary *)parameters
            completion:(void(^)(APIResponse *apiResponse, NSArray *directions, NSError *error))completion;
- (void)directionsForRecipeWithID:(NSInteger)recipeID
                       parameters:(NSDictionary *)parameters
                       completion:(void(^)(APIResponse *apiResponse, NSArray *directions, NSError *error))completion;

#pragma mark - Ingredients
- (void)listIngredients:(NSDictionary *)parameters
             completion:(void(^)(APIResponse *apiResponse, NSArray *ingredients, NSError *error))completion;
- (void)ingredientsForRecipeWithID:(NSInteger)recipeID
                        parameters:(NSDictionary *)parameters
                        completion:(void(^)(APIResponse *apiResponse, NSArray *ingredients, NSError *error))completion;

@end
