//
//  FRecipe.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "FRecipe.h"
#import "FDirection.h"
#import "FIngredient.h"

@implementation FRecipe

+ (void) find: (NSString *) key
      success: (void (^)(FRecipe *recipe)) success
      failure: (void (^)(NSError *error)) failure {
    
    [[ApiClient sharedInstance] get: [NSString stringWithFormat:@"recipes/%@", key]
                             params: @{} options:@{}
                            success: ^(NSDictionary *responseObject) {
                                if (responseObject == nil)
                                    failure([NSError errorWithDomain:@"Not found" code:404 userInfo:nil]);
                                else
                                    success([[FRecipe alloc] initWithAttributes: responseObject]);
                            } failure:^(NSError *error) {
                                failure(error);
                            }];
}

- (void) getDirections: (NSDictionary *) params
               success: (void (^)(NSArray *directions)) success
               failure: (void (^)(NSError *error)) failure {
    
    [[ApiClient sharedInstance] get: [NSString stringWithFormat:@"recipes/%@/directions", [self getValue:@"id"]]
                             params: params options:@{}
                            success: ^(NSDictionary *responseObject) {
                                NSArray *results = (NSArray *) [responseObject objectForKey:@"results"];
                                NSMutableArray *directions = [NSMutableArray array];
                                for (NSDictionary *dir in results) {
                                    [directions addObject: [[FDirection alloc] initWithAttributes: dir]];
                                }
                                success(directions);
                            } failure:^(NSError *error) {
                                failure(error);
                            }];
}

- (void) getIngredients: (NSDictionary *) params
                success: (void (^)(NSArray *ingredients)) success
                failure: (void (^)(NSError *error)) failure {
    
    [[ApiClient sharedInstance] get: [NSString stringWithFormat:@"recipes/%@/ingredients", [self getValue:@"id"]]
                             params: params options:@{}
                            success: ^(NSDictionary *responseObject) {
                                NSArray *results = (NSArray *) [responseObject objectForKey:@"results"];
                                NSMutableArray *ingredients = [NSMutableArray array];
                                for (NSDictionary *ing in results) {
                                    [ingredients addObject: [[FIngredient alloc] initWithAttributes: ing]];
                                }
                                success(ingredients);
                            } failure:^(NSError *error) {
                                failure(error);
                            }];
}

@end
