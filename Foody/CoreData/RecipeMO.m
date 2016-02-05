#import "RecipeMO.h"
#import "RecipeCategoryMO.h"
#import "CoreDataLocalStore.h"

@interface RecipeMO ()

// Private interface goes here.

@end

@implementation RecipeMO

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:[self.featuredIndex integerValue] forKey:APIModel_FeaturedIndexPropertyName];
    [aCoder encodeObject:self.imagePath forKey:APIModel_ImagePropertyName];
    [aCoder encodeObject:self.key forKey:APIModel_KeyPropertyName];
    [aCoder encodeObject:self.name forKey:APIModel_NamePropertyName];
    [aCoder encodeObject:self.locale forKey:APIModel_LocalePropertyName];
    [aCoder encodeObject:self.recipeDescription forKey:APIModel_DescriptionPropertyName];
    [aCoder encodeObject:self.preparationDescription forKey:APIModel_PreparationPropertyName];
    RecipeCategoryMO *category = self.category;
    if (category != nil) {
        [aCoder encodeInteger:category.uidValue forKey:APIModel_CategoryIDPropertyName];
    }
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    [super decodeWithCoder:aDecoder];
    self.featuredIndex = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:APIModel_FeaturedIndexPropertyName]];
    self.key = [aDecoder decodeObjectForKey:APIModel_KeyPropertyName];
    self.name = [aDecoder decodeObjectForKey:APIModel_NamePropertyName];
    self.locale = [aDecoder decodeObjectForKey:APIModel_LocalePropertyName];
    self.imagePath = [aDecoder decodeObjectForKey:APIModel_ImagePropertyName];
    self.recipeDescription = [aDecoder decodeObjectForKey:APIModel_DescriptionPropertyName];
    self.preparationDescription = [aDecoder decodeObjectForKey:APIModel_PreparationPropertyName];
}

@end
