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

- (id)copyWithZone:(NSZone *)zone {
    FRecipe *copy = [[FRecipe alloc] init];
    copy.recipeID = self.recipeID;
    copy.featuredIndex = self.featuredIndex;
    copy.key = self.key;
    copy.name = self.name;
    copy.imagePath = self.imagePath;
    copy.locale = self.locale;
    copy.preparationDescription = self.preparationDescription;
    copy.recipeDescription = self.recipeDescription;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.recipeID forKey:@"id"];
    [aCoder encodeInteger:self.featuredIndex forKey:@"featured_index"];
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.locale forKey:@"locale"];
    [aCoder encodeObject:self.imagePath forKey:@"image"];
    [aCoder encodeObject:self.recipeDescription forKey:@"description"];
    [aCoder encodeObject:self.preparationDescription forKey:@"preparation"];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    self.recipeID = [aDecoder decodeIntegerForKey:@"id"];
    self.featuredIndex = [aDecoder decodeIntegerForKey:@"featured_index"];
    self.key = [aDecoder decodeObjectForKey:@"key"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.locale = [aDecoder decodeObjectForKey:@"locale"];
    self.imagePath = [aDecoder decodeObjectForKey:@"image"];
    self.recipeDescription = [aDecoder decodeObjectForKey:@"description"];
    self.preparationDescription = [aDecoder decodeObjectForKey:@"preparation"];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([self isKindOfClass:[FRecipe class]] == NO) {
        return NO;
    }
    return [self isEqualToRecipe:(FRecipe *)object];
}

- (BOOL)isEqualToRecipe:(FRecipe *)recipe {
    return (self.recipeID == recipe.recipeID
            && self.featuredIndex == recipe.featuredIndex
            && (self.key == recipe.key
                || [self.key isEqualToString:recipe.key])
            && (self.name == recipe.name
                || [self.name isEqualToString:recipe.name])
            && (self.imagePath == recipe.imagePath
                || [self.imagePath isEqualToString:recipe.imagePath])
            && (self.locale == recipe.locale
                || [self.locale isEqualToString:recipe.locale])
            && (self.preparationDescription == recipe.preparationDescription
                || [self.preparationDescription isEqualToString:recipe.preparationDescription])
            && (self.recipeDescription == recipe.recipeDescription
                || [self.recipeDescription isEqualToString:recipe.recipeDescription]));
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%li:%@ %p>", NSStringFromClass(self.class), self.recipeID, self.name, self];
}

@end
