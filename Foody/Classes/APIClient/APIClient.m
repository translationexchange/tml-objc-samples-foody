//
//  ApiClient.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "APIClient.h"
#import "APIModel.h"
#import "RecipeCategory.h"
#import "RecipeDirection.h"
#import "Recipe.h"
#import "RecipeIngredient.h"
#import <TMLKit/TMLAPISerializer.h>

@implementation APIClient

#pragma mark - General Purpose

- (void)listObjectsOfClass:(Class)objectClass
                   apiPath:(NSString *)apiPath
                parameters:(NSDictionary *)parameters
                completion:(void (^)(TMLAPIResponse *apiResponse, NSArray *result, NSError *error))completion
{
    [self get:apiPath
   parameters:parameters
completionBlock:^(TMLAPIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    NSArray *objects = nil;
    if ([apiResponse isSuccessfulResponse] == YES) {
        NSArray *results = (NSArray *)[apiResponse results];
        objects = [TMLAPISerializer materializeObject:results withClass:objectClass];
    }
    if (completion != nil) {
        completion(apiResponse, objects, error);
    }
}];
}

- (void)getObjectOfClass:(Class)objectClass
                  withID:(NSInteger)objectID
                 apiPath:(NSString *)apiPath
              parameters:(NSDictionary *)parameters
              completion:(void (^)(TMLAPIResponse *apiResponse, APIModel *result, NSError *error))completion
{
    NSString *pathWithID = [NSString stringWithFormat:@"%@/%li", apiPath, objectID];
    [self get:pathWithID
   parameters:parameters
completionBlock:^(TMLAPIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    APIModel *object = nil;
    if ([apiResponse isSuccessfulResponse] == YES) {
        object = [TMLAPISerializer materializeObject:[apiResponse results] withClass:objectClass];
    }
    if (completion != nil) {
        completion(apiResponse, object, error);
    }
}];
}


#pragma mark - Categories

- (void)listCategories:(NSDictionary *)parameters
               completion:(void (^)(TMLAPIResponse *apiResponse, NSArray *result, NSError *error))completion
{
    [self listObjectsOfClass:[RecipeCategory class]
                     apiPath:@"categories"
                  parameters:parameters
                  completion:completion];
}

- (void)categoryWithID:(NSInteger)categoryID
            parameters:(NSDictionary *)parameters
            completion:(void (^)(TMLAPIResponse *, RecipeCategory *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"categories/%li", categoryID];
    [self getObjectOfClass:[RecipeCategory class]
                    withID:categoryID
                   apiPath:path
                parameters:parameters
                completion:^(TMLAPIResponse *apiResponse, APIModel *model, NSError *error) {
                    if (completion != nil) {
                        completion(apiResponse, (RecipeCategory *)model, error);
                    }
                }];
}

#pragma mark - Recipes

- (void)listRecipes:(NSDictionary *)parameters
         completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *recipes, NSError *error))completion
{
    [self listObjectsOfClass:[Recipe class]
                     apiPath:@"recipes"
                  parameters:parameters
                  completion:completion];
}

- (void)recipesForCategoryWithID:(NSInteger)categoryID
                      parameters:(NSDictionary *)parameters
                      completion:(void (^)(TMLAPIResponse *, NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"categories/%li/recipes", categoryID];
    [self listObjectsOfClass:[Recipe class]
                     apiPath:path
                  parameters:parameters
                  completion:completion];
}

- (void)recipeWithID:(NSInteger)recipeID
          parameters:(NSDictionary *)parameters
          completion:(void (^)(TMLAPIResponse *, Recipe *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li", recipeID];
    [self getObjectOfClass:[Recipe class]
                    withID:recipeID
                   apiPath:path
                parameters:parameters
                completion:^(TMLAPIResponse *apiResponse, APIModel *result, NSError *error) {
                    if (completion != nil) {
                        completion(apiResponse, (Recipe *)result, error);
                    }
                }];
}

#pragma mark - Directions

- (void)listDirections:(NSDictionary *)parameters
            completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *directions, NSError *error))completion
{
    [self listObjectsOfClass:[RecipeDirection class]
                     apiPath:@"directions"
                  parameters:parameters
                  completion:completion];
}

- (void)directionsForRecipeWithID:(NSInteger)recipeID
                       parameters:(NSDictionary *)parameters
                       completion:(void (^)(TMLAPIResponse *, NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li/directions", recipeID];
    [self listObjectsOfClass:[RecipeDirection class]
                     apiPath:path
                  parameters:parameters
                  completion:completion];
}

#pragma mark - Ingredients

- (void)listIngredients:(NSDictionary *)parameters
             completion:(void(^)(TMLAPIResponse *apiResponse, NSArray *ingredients, NSError *error))completion
{
    [self listObjectsOfClass:[RecipeDirection class]
                     apiPath:@"ingredients"
                  parameters:parameters
                  completion:completion];
}

- (void)ingredientsForRecipeWithID:(NSInteger)recipeID
                        parameters:(NSDictionary *)parameters
                        completion:(void (^)(TMLAPIResponse *, NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li/ingredients", recipeID];
    [self listObjectsOfClass:[RecipeIngredient class]
                     apiPath:path
                  parameters:parameters
                  completion:completion];
}


@end
