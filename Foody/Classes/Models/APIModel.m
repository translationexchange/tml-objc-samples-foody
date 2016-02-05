//
//  Model.m
//  Foody
//
//  Created by Pasha on 1/26/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "APIModel.h"

NSString * const APIModel_DescriptionPropertyName = @"description";
NSString * const APIModel_FeaturedIndexPropertyName = @"featured_index";
NSString * const APIModel_IDPropertyName = @"id";
NSString * const APIModel_ImagePropertyName = @"image";
NSString * const APIModel_IndexPropertyName = @"index";
NSString * const APIModel_KeyPropertyName = @"key";
NSString * const APIModel_LocalePropertyName = @"locale";
NSString * const APIModel_MeasurementsPropertyName = @"measurements";
NSString * const APIModel_NamePropertyName = @"name";
NSString * const APIModel_PreparationPropertyName = @"preparation";
NSString * const APIModel_QuantityPropertyName = @"quantity";
NSString * const APIModel_CategoryIDPropertyName = @"category_id";
NSString * const APIModel_RecipeIDPropertyName = @"recipe_id";

@implementation APIModel

- (id)copyWithZone:(NSZone *)zone {
    APIModel *copy = [[[self class] alloc] init];
    copy.uid = self.uid;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.uid forKey:APIModel_IDPropertyName];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    self.uid = [aDecoder decodeIntegerForKey:APIModel_IDPropertyName];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([self isKindOfClass:[self class]] == NO) {
        return NO;
    }
    return [self isEqualToModel:object];
}

- (BOOL)isEqualToModel:(APIModel *)model {
    return (self.uid == model.uid);
}

@end
