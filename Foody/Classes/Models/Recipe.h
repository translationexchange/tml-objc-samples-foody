//
//  FRecipe.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "APIModel.h"

@interface Recipe : APIModel

@property (assign, nonatomic) NSInteger featuredIndex;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *locale;
@property (strong, nonatomic) NSString *preparationDescription;
@property (strong, nonatomic) NSString *recipeDescription;
@property (assign, nonatomic) NSInteger categoryID;

- (BOOL)isEqualToRecipe:(Recipe *)recipe;

@end
