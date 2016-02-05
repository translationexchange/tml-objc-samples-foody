#import "RecipeIngredientMO.h"
#import "RecipeMO.h"

@interface RecipeIngredientMO ()

// Private interface goes here.

@end

@implementation RecipeIngredientMO

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:[self.index integerValue] forKey:APIModel_IndexPropertyName];
    [aCoder encodeObject:self.name forKey:APIModel_NamePropertyName];
    [aCoder encodeObject:self.measurement forKey:APIModel_MeasurementsPropertyName];
    [aCoder encodeObject:self.quantity forKey:APIModel_QuantityPropertyName];
    RecipeMO *recipe = self.recipe;
    if (recipe != nil) {
        [aCoder encodeInteger:recipe.uidValue forKey:APIModel_RecipeIDPropertyName];
    }
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    [super decodeWithCoder:aDecoder];
    self.index = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:APIModel_IndexPropertyName]];
    self.name = [aDecoder decodeObjectForKey:APIModel_NamePropertyName];
    self.measurement = [aDecoder decodeObjectForKey:APIModel_MeasurementsPropertyName];
    self.quantity = [aDecoder decodeObjectForKey:APIModel_QuantityPropertyName];
}

@end
