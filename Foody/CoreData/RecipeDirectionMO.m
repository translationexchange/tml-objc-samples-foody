#import "RecipeDirectionMO.h"
#import "RecipeMO.h"

@interface RecipeDirectionMO ()

// Private interface goes here.

@end

@implementation RecipeDirectionMO

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:[self.index integerValue] forKey:APIModel_IndexPropertyName];
    [aCoder encodeObject:self.directionDescription forKey:APIModel_DescriptionPropertyName];
    RecipeMO *recipe = self.recipe;
    if (recipe != nil) {
        [aCoder encodeInteger:recipe.uidValue forKey:APIModel_RecipeIDPropertyName];
    }
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    [super decodeWithCoder:aDecoder];
    self.index = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:APIModel_IndexPropertyName]];
    self.directionDescription = [aDecoder decodeObjectForKey:APIModel_DescriptionPropertyName];
}

@end
