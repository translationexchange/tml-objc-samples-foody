// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipeCategoryMO.m instead.

#import "_RecipeCategoryMO.h"

const struct RecipeCategoryMOAttributes RecipeCategoryMOAttributes = {
	.featuredIndex = @"featuredIndex",
	.key = @"key",
	.locale = @"locale",
	.name = @"name",
};

const struct RecipeCategoryMORelationships RecipeCategoryMORelationships = {
	.recipes = @"recipes",
};

@implementation RecipeCategoryMOID
@end

@implementation _RecipeCategoryMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RecipeCategory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RecipeCategory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RecipeCategory" inManagedObjectContext:moc_];
}

- (RecipeCategoryMOID*)objectID {
	return (RecipeCategoryMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"featuredIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"featuredIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic featuredIndex;

- (int32_t)featuredIndexValue {
	NSNumber *result = [self featuredIndex];
	return [result intValue];
}

- (void)setFeaturedIndexValue:(int32_t)value_ {
	[self setFeaturedIndex:@(value_)];
}

- (int32_t)primitiveFeaturedIndexValue {
	NSNumber *result = [self primitiveFeaturedIndex];
	return [result intValue];
}

- (void)setPrimitiveFeaturedIndexValue:(int32_t)value_ {
	[self setPrimitiveFeaturedIndex:@(value_)];
}

@dynamic key;

@dynamic locale;

@dynamic name;

@dynamic recipes;

- (NSMutableSet*)recipesSet {
	[self willAccessValueForKey:@"recipes"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recipes"];

	[self didAccessValueForKey:@"recipes"];
	return result;
}

@end

