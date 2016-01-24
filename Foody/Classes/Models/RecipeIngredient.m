//
//  FIngredient.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeIngredient.h"

@implementation RecipeIngredient

- (id)copyWithZone:(NSZone *)zone {
    RecipeIngredient *copy = [[RecipeIngredient alloc] init];
    copy.ingredientID = self.ingredientID;
    copy.index = self.index;
    copy.name = self.name;
    copy.measurement = self.measurement;
    copy.quantity = self.quantity;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.ingredientID forKey:@"id"];
    [aCoder encodeInteger:self.index forKey:@"index"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.measurement forKey:@"measurements"];
    [aCoder encodeObject:self.quantity forKey:@"quantity"];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    self.ingredientID = [aDecoder decodeIntegerForKey:@"id"];
    self.index = [aDecoder decodeIntegerForKey:@"index"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.measurement = [aDecoder decodeObjectForKey:@"measurements"];
    self.quantity = [aDecoder decodeObjectForKey:@"quantity"];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([self isKindOfClass:[RecipeIngredient class]] == NO) {
        return NO;
    }
    return [self isEqualToIngredient:(RecipeIngredient *)object];
}

- (BOOL)isEqualToIngredient:(RecipeIngredient *)ingredient {
    return (self.ingredientID == ingredient.ingredientID
            && self.index == ingredient.index
            && (self.name == ingredient.name
                || [self.name isEqualToString:ingredient.name])
            && (self.measurement == ingredient.measurement
                || [self.measurement isEqualToString:ingredient.measurement])
            && (self.quantity == ingredient.quantity
                || [self.quantity isEqualToString:ingredient.quantity]));
}

@end
