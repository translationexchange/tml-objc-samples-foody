// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipeIngredientMO.m instead.

#import "_RecipeIngredientMO.h"

const struct RecipeIngredientMOAttributes RecipeIngredientMOAttributes = {
	.index = @"index",
	.measurement = @"measurement",
	.name = @"name",
	.quantity = @"quantity",
};

const struct RecipeIngredientMORelationships RecipeIngredientMORelationships = {
	.recipe = @"recipe",
};

@implementation RecipeIngredientMOID
@end

@implementation _RecipeIngredientMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RecipeIngredient" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RecipeIngredient";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RecipeIngredient" inManagedObjectContext:moc_];
}

- (RecipeIngredientMOID*)objectID {
	return (RecipeIngredientMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic index;

- (int32_t)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int32_t)value_ {
	[self setIndex:@(value_)];
}

- (int32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int32_t)value_ {
	[self setPrimitiveIndex:@(value_)];
}

@dynamic measurement;

@dynamic name;

@dynamic quantity;

@dynamic recipe;

@end

