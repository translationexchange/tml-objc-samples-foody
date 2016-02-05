//
//  FDirection.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "APIModel.h"

@interface RecipeDirection : APIModel

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *directionDescription;
@property (assign, nonatomic) NSInteger recipeID;

@end
