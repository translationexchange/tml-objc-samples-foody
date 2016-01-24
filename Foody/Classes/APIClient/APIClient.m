//
//  ApiClient.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "APIClient.h"
#import "RecipeCategory.h"
#import "RecipeDirection.h"
#import "Recipe.h"
#import "RecipeIngredient.h"
#import <TMLKit/TMLAPISerializer.h>

@implementation APIClient

- (void)listAllCategories:(NSDictionary *)parameters
               completion:(void (^)(NSArray *, NSError *))completion
{
    [self get:@"categories"
   parameters:parameters
completionBlock:^(TMLAPIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    NSArray *categories = nil;
    if ([apiResponse isSuccessfulResponse] == YES) {
        NSArray *results = (NSArray *)[apiResponse results];
        categories = [TMLAPISerializer materializeObject:results withClass:[RecipeCategory class]];
    }
    if (completion != nil) {
        completion(categories, error);
    }
}];
}

- (void)categoryWithID:(NSInteger)categoryID
            parameters:(NSDictionary *)parameters
            completion:(void (^)(RecipeCategory *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"categories/%li", categoryID];
    [self get:path
   parameters:nil
completionBlock:^(TMLAPIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    RecipeCategory *category = nil;
    if ([apiResponse isSuccessfulResponse] == YES) {
        category = [TMLAPISerializer materializeObject:[apiResponse results] withClass:[RecipeCategory class]];
    }
    if (completion != nil) {
        completion(category, error);
    }
}];
}

- (void)recipesForCategoryWithID:(NSInteger)categoryID
                      parameters:(NSDictionary *)parameters
                      completion:(void (^)(NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"categories/%li/recipes", categoryID];
    [self get:path
   parameters:parameters
completionBlock:^(TMLAPIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    NSArray *recipes = nil;
    if ([apiResponse isSuccessfulResponse] == YES) {
        recipes = [TMLAPISerializer materializeObject:[apiResponse results] withClass:[Recipe class]];
    }
    if (completion != nil) {
        completion(recipes, error);
    }
}];
}

- (void)recipeWithID:(NSInteger)recipeID
          parameters:(NSDictionary *)parameters
          completion:(void (^)(Recipe *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li", recipeID];
    [self get:path
   parameters:parameters
completionBlock:^(TMLAPIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    Recipe *recipe = nil;
    if ([apiResponse isSuccessfulResponse] == YES) {
        NSArray *results = (NSArray *)[apiResponse results];
        recipe = [TMLAPISerializer materializeObject:results withClass:[Recipe class]];
    }
    if (completion != nil) {
        completion(recipe, error);
    }
}];
}

- (void)directionsForRecipeWithID:(NSInteger)recipeID
                       parameters:(NSDictionary *)parameters
                       completion:(void (^)(NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li/directions", recipeID];
    [self get:path
   parameters:parameters
completionBlock:^(TMLAPIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    NSArray *directions;
    if ([apiResponse isSuccessfulResponse] == YES) {
        directions = [TMLAPISerializer materializeObject:[apiResponse results] withClass:[RecipeDirection class]];
    }
    if (completion != nil) {
        completion(directions, error);
    }
}];
}

- (void)ingredientsForRecipeWithID:(NSInteger)recipeID
                        parameters:(NSDictionary *)parameters
                        completion:(void (^)(NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li/ingredients", recipeID];
    [self get:path
   parameters:parameters
completionBlock:^(TMLAPIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    NSArray *ingredients;
    if ([apiResponse isSuccessfulResponse] == YES) {
        ingredients = [TMLAPISerializer materializeObject:[apiResponse results] withClass:[RecipeIngredient class]];
    }
    if (completion != nil) {
        completion(ingredients, error);
    }
}];
}


@end
