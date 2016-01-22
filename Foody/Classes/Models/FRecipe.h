//
//  FRecipe.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBase.h"

@interface FRecipe : FBase

+ (void) find: (NSString *)key
      success: (void (^)(FRecipe *recipe)) success
      failure: (void (^)(NSError *error)) failure;

- (void) getDirections: (NSDictionary *)params
               success: (void (^)(NSArray *directions)) success
               failure: (void (^)(NSError *error)) failure;

- (void) getIngredients: (NSDictionary *)params
                success: (void (^)(NSArray *ingredients)) success
                failure: (void (^)(NSError *error)) failure;

@end
