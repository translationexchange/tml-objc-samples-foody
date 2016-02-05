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
    RecipeIngredient *copy = (RecipeIngredient *)[super copyWithZone:zone];
    copy.index = self.index;
    copy.name = self.name;
    copy.measurement = self.measurement;
    copy.quantity = self.quantity;
    copy.recipeID = self.recipeID;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.index forKey:APIModel_IndexPropertyName];
    [aCoder encodeObject:self.name forKey:APIModel_NamePropertyName];
    [aCoder encodeObject:self.measurement forKey:APIModel_MeasurementsPropertyName];
    [aCoder encodeObject:self.quantity forKey:APIModel_QuantityPropertyName];
    [aCoder encodeInteger:self.recipeID forKey:APIModel_RecipeIDPropertyName];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    [super decodeWithCoder:aDecoder];
    self.index = [aDecoder decodeIntegerForKey:APIModel_IndexPropertyName];
    self.name = [aDecoder decodeObjectForKey:APIModel_NamePropertyName];
    self.measurement = [aDecoder decodeObjectForKey:APIModel_MeasurementsPropertyName];
    self.quantity = [aDecoder decodeObjectForKey:APIModel_QuantityPropertyName];
    self.recipeID = [aDecoder decodeIntegerForKey:APIModel_RecipeIDPropertyName];
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
    return (self.uid == ingredient.uid
            && self.recipeID == ingredient.recipeID
            && self.index == ingredient.index
            && (self.name == ingredient.name
                || [self.name isEqualToString:ingredient.name])
            && (self.measurement == ingredient.measurement
                || [self.measurement isEqualToString:ingredient.measurement])
            && (self.quantity == ingredient.quantity
                || [self.quantity isEqualToString:ingredient.quantity]));
}

@end
