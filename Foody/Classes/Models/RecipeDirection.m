//
//  FDirection.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "RecipeDirection.h"

@implementation RecipeDirection

- (id)copyWithZone:(NSZone *)zone {
    RecipeDirection *copy = (RecipeDirection *)[super copyWithZone:zone];
    copy.index = self.index;
    copy.directionDescription = self.directionDescription;
    copy.recipeID = self.recipeID;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.index forKey:APIModel_IndexPropertyName];
    [aCoder encodeObject:self.directionDescription forKey:APIModel_DescriptionPropertyName];
    [aCoder encodeInteger:self.recipeID forKey:APIModel_RecipeIDPropertyName];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    [super decodeWithCoder:aDecoder];
    self.index = [aDecoder decodeIntegerForKey:APIModel_IndexPropertyName];
    self.directionDescription = [aDecoder decodeObjectForKey:APIModel_DescriptionPropertyName];
    self.recipeID = [aDecoder decodeIntegerForKey:APIModel_RecipeIDPropertyName];
}

-(BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([self isKindOfClass:[RecipeDirection class]] == NO) {
        return NO;
    }
    return [self isEqualToDirection:(RecipeDirection *)object];
}

-(BOOL)isEqualToDirection:(RecipeDirection *)direction {
    return (self.uid == direction.uid
            && self.recipeID == direction.recipeID
            && self.index == direction.index
            && (self.directionDescription == direction.directionDescription
                || [self.directionDescription isEqualToString:direction.directionDescription]));
}

@end
