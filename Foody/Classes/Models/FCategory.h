//
//  FCategory.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBase.h"

@interface FCategory : FBase

+ (void) findAll: (NSDictionary *)params
         success: (void (^)(NSArray *categories)) success
         failure: (void (^)(NSError *error)) failure;

+ (void) find: (NSString *)key
      success: (void (^)(FCategory *category)) success
      failure: (void (^)(NSError *error)) failure;

- (void) getRecipes: (NSDictionary *)params
            success: (void (^)(NSArray *recipes)) success
            failure: (void (^)(NSError *error)) failure;

@end
