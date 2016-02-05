#import "RecipeCategoryMO.h"

@interface RecipeCategoryMO ()

// Private interface goes here.

@end

@implementation RecipeCategoryMO

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.key forKey:APIModel_KeyPropertyName];
    [aCoder encodeObject:self.name forKey:APIModel_NamePropertyName];
    [aCoder encodeObject:self.locale forKey:APIModel_LocalePropertyName];
    [aCoder encodeInteger:[self.featuredIndex integerValue] forKey:APIModel_FeaturedIndexPropertyName];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    [super decodeWithCoder:aDecoder];
    self.key = [aDecoder decodeObjectForKey:APIModel_KeyPropertyName];
    self.name = [aDecoder decodeObjectForKey:APIModel_NamePropertyName];
    self.locale = [aDecoder decodeObjectForKey:APIModel_LocalePropertyName];
    self.featuredIndex = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:APIModel_FeaturedIndexPropertyName]];
}

@end
