//
//  FCategory.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "FCategory.h"
#import "FRecipe.h"
#import "APIClient.h"
#import "AppDelegate.h"

@implementation FCategory

- (id)copyWithZone:(NSZone *)zone {
    FCategory *copy = [[FCategory alloc] init];
    copy.categoryID = self.categoryID;
    copy.key = self.key;
    copy.name = self.name;
    copy.locale = self.locale;
    copy.featuredIndex = self.featuredIndex;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.categoryID forKey:@"id"];
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.locale forKey:@"locale"];
    [aCoder encodeInteger:self.featuredIndex forKey:@"featured_index"];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    self.categoryID = [aDecoder decodeIntegerForKey:@"id"];
    self.key = [aDecoder decodeObjectForKey:@"key"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.locale = [aDecoder decodeObjectForKey:@"locale"];
    self.featuredIndex = [aDecoder decodeIntegerForKey:@"featured_index"];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[self class]] == NO) {
        return NO;
    }
    return [self isEqualToCategory:(FCategory *)object];
}

- (BOOL)isEqualToCategory:(FCategory *)category {
    return (self.categoryID == category.categoryID
            && (self.key == category.key
                || [self.key isEqualToString:category.key])
            && (self.locale == category.locale
                || [self.locale isEqualToString:category.locale])
            && (self.name == category.name
                || [self.name isEqualToString:category.name])
            && self.featuredIndex == category.featuredIndex);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%li:%@ %p>", NSStringFromClass(self.class), self.categoryID, self.name, self];
}

@end
