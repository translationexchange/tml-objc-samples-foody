//
//  FRecipe.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <TMLKit/TMLModel.h>

@interface Recipe : TMLModel

@property (assign, nonatomic) NSInteger recipeID;
@property (assign, nonatomic) NSInteger featuredIndex;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *locale;
@property (strong, nonatomic) NSString *preparationDescription;
@property (strong, nonatomic) NSString *recipeDescription;

- (BOOL)isEqualToRecipe:(Recipe *)recipe;

@end
