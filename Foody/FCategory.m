//
//  FCategory.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "FCategory.h"
#import "FRecipe.h"
#import "ApiClient.h"

@implementation FCategory

+ (void) findAll: (NSDictionary *) params
         success: (void (^)(NSArray *categories)) success
         failure: (void (^)(NSError *error)) failure {
    
    [[ApiClient sharedInstance] get: @"categories"
                             params: params options:@{}
                            success: ^(NSDictionary *responseObject) {
        NSArray *results = (NSArray *) [responseObject objectForKey:@"results"];
        NSMutableArray *categories = [NSMutableArray array];
        for (NSDictionary *cat in results) {
            FCategory *category = [[FCategory alloc] initWithAttributes: cat];
            [categories addObject: category];
        }
        success(categories);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void) find: (NSString *) key
      success: (void (^)(FCategory *category)) success
      failure: (void (^)(NSError *error)) failure {

    [[ApiClient sharedInstance] get: [NSString stringWithFormat:@"categories/%@", key]
                             params: @{} options:@{}
                            success: ^(NSDictionary *responseObject) {
        if (responseObject == nil)
            failure([NSError errorWithDomain:@"Not found" code:404 userInfo:nil]);
        else
            success([[FCategory alloc] initWithAttributes: responseObject]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void) getRecipes: (NSDictionary *) params
             success: (void (^)(NSArray *recipes)) success
             failure: (void (^)(NSError *error)) failure {
    
    [[ApiClient sharedInstance] get: [NSString stringWithFormat:@"categories/%@/recipes", [self getValue:@"id"]]
                             params: params options:@{}
                            success: ^(NSDictionary *responseObject) {
        NSArray *results = (NSArray *) [responseObject objectForKey:@"results"];
        NSMutableArray *recipes = [NSMutableArray array];
        for (NSDictionary *rec in results) {
            [recipes addObject: [[FRecipe alloc] initWithAttributes: rec]];
        }
        success(recipes);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
