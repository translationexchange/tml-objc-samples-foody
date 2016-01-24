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

- (void)listAllCategories:(NSDictionary *)parameters
               completion:(void(^)(NSArray *categories, NSError *error))completion;

- (void)categoryWithID:(NSInteger)categoryID
            parameters:(NSDictionary *)parameters
            completion:(void(^)(RecipeCategory *category, NSError *error))completion;

- (void)recipesForCategoryWithID:(NSInteger)categoryID
                      parameters:(NSDictionary *)parameters
                      completion:(void(^)(NSArray *recipes, NSError *error))completion;

- (void)recipeWithID:(NSInteger)recipeID
          parameters:(NSDictionary *)parameters
          completion:(void(^)(Recipe *recipe, NSError *error))completion;

- (void)directionsForRecipeWithID:(NSInteger)recipeID
                       parameters:(NSDictionary *)parameters
                       completion:(void(^)(NSArray *directions, NSError *error))completion;

- (void)ingredientsForRecipeWithID:(NSInteger)recipeID
                        parameters:(NSDictionary *)parameters
                        completion:(void(^)(NSArray *ingredients, NSError *error))completion;

@end
