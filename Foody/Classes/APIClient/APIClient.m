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
#import "APISerializer.h"
#import "NSObject+JSON.h"

@implementation APIClient

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    if (self = [super init]) {
        self.baseURL = baseURL;
    }
    return self;
}

#pragma mark - Request Support

- (void) request: (NSURLRequest *) request
     cachePolicy:(NSURLRequestCachePolicy)cachePolicy
 completionBlock:(APIResponseHandler)completionBlock
{
    [[[NSURLSession sharedSession] dataTaskWithRequest: request
                                     completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^(void){
                                             [self processResponse:response
                                                              data:data
                                                             error:error
                                                   completionBlock:completionBlock];
                                         });
                                     }] resume];
}

#pragma mark - GET

- (void) get:(NSString *)path
  parameters:(NSDictionary *)parameters
completionBlock:(APIResponseHandler)completionBlock
{
    [self get:path
   parameters:parameters
  cachePolicy:NSURLRequestUseProtocolCachePolicy
completionBlock:completionBlock];
}

#pragma mark - POST

- (void) post:(NSString *)path
   parameters:(NSDictionary *)parameters
completionBlock:(APIResponseHandler)completionBlock
{
    [self post:path
    parameters:parameters
   cachePolicy:NSURLRequestUseProtocolCachePolicy
completionBlock:completionBlock];
}

- (void) get:(NSString *)path
  parameters:(NSDictionary *)parameters
 cachePolicy:(NSURLRequestCachePolicy)cachePolicy
completionBlock:(APIResponseHandler)completionBlock
{
    NSURL *url = [self URLForAPIPath:path parameters:parameters];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AppDebug(@"GET %@", url);
    [self request:request
      cachePolicy:cachePolicy
  completionBlock:completionBlock];
}

- (void) post:(NSString *)path
   parameters:(NSDictionary *)parameters
  cachePolicy:(NSURLRequestCachePolicy)cachePolicy
completionBlock:(APIResponseHandler)completionBlock
{
    NSURL *url = [self URLForAPIPath:path parameters:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[self urlEncodedStringFromParameters: parameters] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AppDebug(@"POST %@", url);
    [self request:request
      cachePolicy:cachePolicy
  completionBlock:completionBlock];
}

#pragma mark - Response Handling

- (void) processResponse:(NSURLResponse *)response
                    data:(NSData *)data
                   error:(NSError *)error
         completionBlock:(APIResponseHandler)completionBlock
{
    if (error != nil) {
        AppError(@"Request Error: %@", error);
    }
    
    if (completionBlock == nil) {
        return;
    }
    
    APIResponse *apiResponse = [[APIResponse alloc] initWithData:data];
    NSError *relevantError = nil;
    if (error != nil) {
        relevantError = error;
    }
    if (apiResponse != nil && relevantError == nil) {
        relevantError = apiResponse.error;
    }
    if (apiResponse == nil && relevantError == nil) {
        AppWarn(@"Unrecognized response object");
        relevantError = [NSError errorWithDomain:@"Unrecognized response"
                                            code:0
                                        userInfo:nil];
    }
    
    completionBlock(apiResponse, response, relevantError);
}


#pragma mark - URL Utils

- (NSURL *) URLForAPIPath: (NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableString *pathString = [NSMutableString stringWithFormat:@"%@/%@", self.baseURL, path];
    [pathString appendString:@"?"];
    for (NSString *key in parameters) {
        id value = [parameters objectForKey:key];
        NSString *valueClass = NSStringFromClass([value class]);
        if ([valueClass rangeOfString:@"Boolean"].location != NSNotFound) {
            value = ([value boolValue] == YES) ? @"true" : @"false";
        }
        [pathString appendFormat:@"&%@=%@", [self urlEncode:key], [self urlEncode:value]];
    }
    return [NSURL URLWithString:pathString];
}

- (NSString *) urlEncode: (id) object {
    NSString *string = [NSString stringWithFormat: @"%@", object];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString*) urlEncodedStringFromParameters:(NSDictionary *)parameters {
    NSMutableArray *parts = [NSMutableArray array];
    for (id paramKey in parameters) {
        id paramValue = [parameters objectForKey: paramKey];
        NSString *paramString = ([paramValue isKindOfClass:[NSString class]] == YES) ? (NSString *)paramValue : [paramValue JSONString];
        NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode: paramKey], [self urlEncode: paramString]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

#pragma mark - General Purpose

- (void)listObjectsOfClass:(Class)objectClass
                   apiPath:(NSString *)apiPath
                parameters:(NSDictionary *)parameters
                completion:(void (^)(APIResponse *apiResponse, NSArray *result, NSError *error))completion
{
    [self get:apiPath
   parameters:parameters
completionBlock:^(APIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    NSArray *objects = nil;
    if ([apiResponse isSuccessfulResponse] == YES) {
        NSArray *results = (NSArray *)[apiResponse results];
        objects = [APISerializer materializeObject:results withClass:objectClass];
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
              completion:(void (^)(APIResponse *apiResponse, APIModel *result, NSError *error))completion
{
    NSString *pathWithID = [NSString stringWithFormat:@"%@/%li", apiPath, objectID];
    [self get:pathWithID
   parameters:parameters
completionBlock:^(APIResponse *apiResponse, NSURLResponse *response, NSError *error) {
    APIModel *object = nil;
    if ([apiResponse isSuccessfulResponse] == YES) {
        object = [APISerializer materializeObject:[apiResponse results] withClass:objectClass];
    }
    if (completion != nil) {
        completion(apiResponse, object, error);
    }
}];
}


#pragma mark - Categories

- (void)listCategories:(NSDictionary *)parameters
               completion:(void (^)(APIResponse *apiResponse, NSArray *result, NSError *error))completion
{
    [self listObjectsOfClass:[RecipeCategory class]
                     apiPath:@"categories"
                  parameters:parameters
                  completion:completion];
}

- (void)categoryWithID:(NSInteger)categoryID
            parameters:(NSDictionary *)parameters
            completion:(void (^)(APIResponse *, RecipeCategory *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"categories/%li", categoryID];
    [self getObjectOfClass:[RecipeCategory class]
                    withID:categoryID
                   apiPath:path
                parameters:parameters
                completion:^(APIResponse *apiResponse, APIModel *model, NSError *error) {
                    if (completion != nil) {
                        completion(apiResponse, (RecipeCategory *)model, error);
                    }
                }];
}

#pragma mark - Recipes

- (void)listRecipes:(NSDictionary *)parameters
         completion:(void(^)(APIResponse *apiResponse, NSArray *recipes, NSError *error))completion
{
    [self listObjectsOfClass:[Recipe class]
                     apiPath:@"recipes"
                  parameters:parameters
                  completion:completion];
}

- (void)recipesForCategoryWithID:(NSInteger)categoryID
                      parameters:(NSDictionary *)parameters
                      completion:(void (^)(APIResponse *, NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"categories/%li/recipes", categoryID];
    [self listObjectsOfClass:[Recipe class]
                     apiPath:path
                  parameters:parameters
                  completion:completion];
}

- (void)recipeWithID:(NSInteger)recipeID
          parameters:(NSDictionary *)parameters
          completion:(void (^)(APIResponse *, Recipe *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li", recipeID];
    [self getObjectOfClass:[Recipe class]
                    withID:recipeID
                   apiPath:path
                parameters:parameters
                completion:^(APIResponse *apiResponse, APIModel *result, NSError *error) {
                    if (completion != nil) {
                        completion(apiResponse, (Recipe *)result, error);
                    }
                }];
}

#pragma mark - Directions

- (void)listDirections:(NSDictionary *)parameters
            completion:(void(^)(APIResponse *apiResponse, NSArray *directions, NSError *error))completion
{
    [self listObjectsOfClass:[RecipeDirection class]
                     apiPath:@"directions"
                  parameters:parameters
                  completion:completion];
}

- (void)directionsForRecipeWithID:(NSInteger)recipeID
                       parameters:(NSDictionary *)parameters
                       completion:(void (^)(APIResponse *, NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li/directions", recipeID];
    [self listObjectsOfClass:[RecipeDirection class]
                     apiPath:path
                  parameters:parameters
                  completion:completion];
}

#pragma mark - Ingredients

- (void)listIngredients:(NSDictionary *)parameters
             completion:(void(^)(APIResponse *apiResponse, NSArray *ingredients, NSError *error))completion
{
    [self listObjectsOfClass:[RecipeDirection class]
                     apiPath:@"ingredients"
                  parameters:parameters
                  completion:completion];
}

- (void)ingredientsForRecipeWithID:(NSInteger)recipeID
                        parameters:(NSDictionary *)parameters
                        completion:(void (^)(APIResponse *, NSArray *, NSError *))completion
{
    NSString *path = [NSString stringWithFormat:@"recipes/%li/ingredients", recipeID];
    [self listObjectsOfClass:[RecipeIngredient class]
                     apiPath:path
                  parameters:parameters
                  completion:completion];
}


@end
