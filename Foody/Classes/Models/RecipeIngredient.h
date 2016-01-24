//
//  FIngredient.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <TMLKit/TMLModel.h>

@interface RecipeIngredient : TMLModel

@property (assign, nonatomic) NSInteger ingredientID;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *measurement;
@property (strong, nonatomic) NSString *quantity;

@end
