//
//  FCategory.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "APIModel.h"

@interface RecipeCategory : APIModel

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *locale;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger featuredIndex;

- (BOOL)isEqualToCategory:(RecipeCategory *)category;

@end
