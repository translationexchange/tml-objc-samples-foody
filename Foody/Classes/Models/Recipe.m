//
//  FRecipe.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "Recipe.h"
#import "RecipeDirection.h"
#import "RecipeIngredient.h"

@implementation Recipe

- (id)copyWithZone:(NSZone *)zone {
    Recipe *copy = (Recipe *)[super copyWithZone:zone];
    copy.featuredIndex = self.featuredIndex;
    copy.key = self.key;
    copy.name = self.name;
    copy.imagePath = self.imagePath;
    copy.locale = self.locale;
    copy.preparationDescription = self.preparationDescription;
    copy.recipeDescription = self.recipeDescription;
    copy.categoryID = self.categoryID;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.featuredIndex forKey:APIModel_FeaturedIndexPropertyName];
    [aCoder encodeObject:self.key forKey:APIModel_KeyPropertyName];
    [aCoder encodeObject:self.name forKey:APIModel_NamePropertyName];
    [aCoder encodeObject:self.locale forKey:APIModel_LocalePropertyName];
    [aCoder encodeObject:self.imagePath forKey:APIModel_ImagePropertyName];
    [aCoder encodeObject:self.recipeDescription forKey:APIModel_DescriptionPropertyName];
    [aCoder encodeObject:self.preparationDescription forKey:APIModel_PreparationPropertyName];
    [aCoder encodeInteger:self.categoryID forKey:APIModel_CategoryIDPropertyName];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    [super decodeWithCoder:aDecoder];
    self.featuredIndex = [aDecoder decodeIntegerForKey:APIModel_FeaturedIndexPropertyName];
    self.key = [aDecoder decodeObjectForKey:APIModel_KeyPropertyName];
    self.name = [aDecoder decodeObjectForKey:APIModel_NamePropertyName];
    self.locale = [aDecoder decodeObjectForKey:APIModel_LocalePropertyName];
    self.imagePath = [aDecoder decodeObjectForKey:APIModel_ImagePropertyName];
    self.recipeDescription = [aDecoder decodeObjectForKey:APIModel_DescriptionPropertyName];
    self.preparationDescription = [aDecoder decodeObjectForKey:APIModel_PreparationPropertyName];
    self.categoryID = [aDecoder decodeIntegerForKey:APIModel_CategoryIDPropertyName];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([self isKindOfClass:[Recipe class]] == NO) {
        return NO;
    }
    return [self isEqualToRecipe:(Recipe *)object];
}

- (BOOL)isEqualToRecipe:(Recipe *)recipe {
    return (self.uid == recipe.uid
            && self.featuredIndex == recipe.featuredIndex
            && self.categoryID == recipe.categoryID
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
    return [NSString stringWithFormat:@"<%@:%li:%@ %p>", NSStringFromClass(self.class), self.uid, self.name, self];
}

@end
