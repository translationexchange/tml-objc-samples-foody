//
//  FCategory.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeCategory.h"
#import "Recipe.h"
#import "APIClient.h"
#import "AppDelegate.h"

@implementation RecipeCategory

- (id)copyWithZone:(NSZone *)zone {
    RecipeCategory *copy = (RecipeCategory *)[super copyWithZone:zone];
    copy.key = self.key;
    copy.name = self.name;
    copy.locale = self.locale;
    copy.featuredIndex = self.featuredIndex;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.key forKey:APIModel_KeyPropertyName];
    [aCoder encodeObject:self.name forKey:APIModel_NamePropertyName];
    [aCoder encodeObject:self.locale forKey:APIModel_LocalePropertyName];
    [aCoder encodeInteger:self.featuredIndex forKey:APIModel_FeaturedIndexPropertyName];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    [super decodeWithCoder:aDecoder];
    self.key = [aDecoder decodeObjectForKey:APIModel_KeyPropertyName];
    self.name = [aDecoder decodeObjectForKey:APIModel_NamePropertyName];
    self.locale = [aDecoder decodeObjectForKey:APIModel_LocalePropertyName];
    self.featuredIndex = [aDecoder decodeIntegerForKey:APIModel_FeaturedIndexPropertyName];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[self class]] == NO) {
        return NO;
    }
    return [self isEqualToCategory:(RecipeCategory *)object];
}

- (BOOL)isEqualToCategory:(RecipeCategory *)category {
    return (self.uid == category.uid
            && (self.key == category.key
                || [self.key isEqualToString:category.key])
            && (self.locale == category.locale
                || [self.locale isEqualToString:category.locale])
            && (self.name == category.name
                || [self.name isEqualToString:category.name])
            && self.featuredIndex == category.featuredIndex);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%li:%@ %p>", NSStringFromClass(self.class), self.uid, self.name, self];
}

@end
